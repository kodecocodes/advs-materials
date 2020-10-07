/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

#import "Feed.h"

NSString * _Nonnull const FeedStorageFilename = @"feed.data";

@interface Feed ()
@property (nonatomic, strong) NSURL *storageUrl;
@property (nonatomic, copy, nullable) void (^pickerCompletion)(FeedItem *);
@end

@implementation Feed

- (instancetype)init
{
  self = [super init];

  if (self) {
    self.storageUrl = [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                              inDomain:NSUserDomainMask
                                                     appropriateForURL:nil
                                                                create:true
                                                                 error:nil]
                       URLByAppendingPathComponent: FeedStorageFilename];
  }

  return self;
}

- (BOOL)babySleeping {
  NSArray <FeedItem *> *feed = [self loadFeedItems];

  NSInteger sleepIndex = [feed indexOfObjectPassingTest:^BOOL(FeedItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    return obj.kind == FeedItemKindSleep;
  }];

  NSInteger awakeIndex = [feed indexOfObjectPassingTest:^BOOL(FeedItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    return obj.kind == FeedItemKindAwake;
  }];

  return sleepIndex < awakeIndex;
}

- (NSArray <FeedItem *> *) loadFeedItems {
  NSError *error;

  if (![[NSFileManager defaultManager] fileExistsAtPath: self.storageUrl.path]) {
    [[NSFileManager defaultManager] createFileAtPath:self.storageUrl.path contents:nil attributes:@{}];
  }

  NSString *content = [NSString stringWithContentsOfURL:self.storageUrl encoding:NSUTF8StringEncoding error:&error];

  if (error) {
    NSLog(@"Something went wrong: %@", error.localizedDescription);
    return @[];
  }

  NSMutableArray <FeedItem *> *result = [@[] mutableCopy];
  [content enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
    NSArray <NSString *> *components = [line componentsSeparatedByString:@","];
    if (components.count != 3) { return; }

    FeedItem *item = [[FeedItem alloc] initWithKind:[components[0] integerValue]
                                               date:[NSDate dateWithTimeIntervalSince1970:[components[1] doubleValue]]
                                       attachmentId:[[NSUUID alloc] initWithUUIDString:components[2]]];

    [result insertObject:item atIndex:0];
  }];

  return result;
}

- (FeedItem *) addFeedItemOfKind: (FeedItemKind) kind {
  FeedItem *feedItem = [[FeedItem alloc] initWithKind:kind
                                                 date:[[NSDate new] dateByAddingTimeInterval:-1]
                                         attachmentId:nil];
  return [self addFeedItem:feedItem];
}

- (FeedItem *) addFeedItem: (FeedItem *) item {
  NSDate *date = item.date;
  NSTimeInterval interval = [date timeIntervalSince1970];
  NSString *line = [NSString stringWithFormat:@"%ld,%f,%@\n", (long)item.kind, interval, item.attachmentId == nil ? @"" : item.attachmentId];

  NSFileHandle *handle = [NSFileHandle fileHandleForWritingToURL:self.storageUrl error:nil];

  [handle seekToEndOfFile];
  [handle writeData:[line dataUsingEncoding:NSUTF8StringEncoding] error:nil];
  [handle closeFile];

  return item;
}

- (void) addMomentOnPresenter: (UIViewController *) presenter
                   completion: (void (^ _Nullable)(FeedItem *)) completion {
  PHPickerConfiguration *configuration = [[PHPickerConfiguration alloc] init];
  configuration.selectionLimit = 1;
  configuration.filter = PHPickerFilter.imagesFilter;

  PHPickerViewController *picker = [[PHPickerViewController alloc] initWithConfiguration: configuration];
  picker.delegate = self;
  self.pickerCompletion = completion;

  [presenter presentViewController:picker animated:true completion:nil];
}

- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results {
  if (results.count == 0) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [picker dismissViewControllerAnimated:true completion:nil];
    });
    return;
  }

  PHPickerResult *result = results[0];

  if (result == nil) {
    return;
  }

  [result.itemProvider loadObjectOfClass:[UIImage self]
                       completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
    UIImage *image = object;

    if(error != nil || image == nil) {
      NSLog(@"Something went wrong %@", error.localizedDescription);
      return;
    }


    NSUUID *attachmentId = [self storeImage:image];

    if(!attachmentId) { return; }

    dispatch_async(dispatch_get_main_queue(), ^{
      [picker dismissViewControllerAnimated:true completion:nil];
      FeedItem *feedItem = [[FeedItem alloc] initWithKind:FeedItemKindMoment
                                                     date:[[NSDate new] dateByAddingTimeInterval:-1]
                                             attachmentId:attachmentId];

      self.pickerCompletion([self addFeedItem:feedItem]);
    });
  }];
}

- (NSUUID * _Nullable) storeImage:(UIImage * _Nonnull) image {
  NSError *error;

  NSUUID *attachmentId = [NSUUID new];
  CGFloat ratio = 600 / image.size.height;
  CGSize newSize = CGSizeMake(image.size.width * ratio,
                              image.size.height * ratio);
  UIImage *resizedimage = [[[UIGraphicsImageRenderer alloc] initWithSize: newSize] imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
    [image drawInRect: CGRectMake(0, 0, newSize.width, newSize.height)];
  }];

  NSData *imageData = UIImageJPEGRepresentation(resizedimage, 0.75);
  NSURL *imageURL = [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:true error:&error] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", attachmentId.UUIDString]];

  if(error != nil) {
    NSLog(@"Failed constructing URL: %@", error.localizedDescription);
    return nil;
  }

  [imageData writeToURL:imageURL atomically:true];
  return attachmentId;
}

@end
