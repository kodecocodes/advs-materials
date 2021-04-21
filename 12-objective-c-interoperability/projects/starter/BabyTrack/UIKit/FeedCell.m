/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

#import "FeedCell.h"

@interface FeedCell ()
@property (nonatomic, strong) IBOutlet UILabel *lblKindEmoji;
@property (nonatomic, strong) IBOutlet UILabel *lblKindTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UIImageView *attachment;
@end

@implementation FeedCell

- (void)configureWithFeedItem:(FeedItem *)feedItem {
  NSRelativeDateTimeFormatter *df = [NSRelativeDateTimeFormatter new];
  df.formattingContext = NSFormattingContextStandalone;
  self.lblDate.text = [df stringForObjectValue:feedItem.date];
  
  [self.attachment setHidden: feedItem.attachmentId == nil];
  
  [[NSURLSession.sharedSession dataTaskWithURL:[NSURL new]
                             completionHandler:^(NSData * _Nullable data,
                                                 NSURLResponse * _Nullable response,
                                                 NSError * _Nullable error) {

    __weak FeedCell *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
      weakSelf.attachment.image = [UIImage imageWithData:data];
    });
  }] resume];
}

@end
