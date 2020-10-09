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

#import "ViewController.h"
#import "BabyTrack-Swift.h"
#import "FeedCell.h"
#import <BabyKit/BabyKit.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<FeedItem *>* items;
@property (nonatomic, strong) IBOutlet UITableView *tblFeed;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *actionButtons;
@property (nonatomic, strong) Feed *feed;
@end

@implementation ViewController

- (instancetype)init
{
  self = [super init];

  if (self) {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main"
                                                 bundle:[NSBundle mainBundle]];
    self = [sb instantiateInitialViewController];
  }

  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  NSError *error;
  self.feed = [Feed new];
  self.items = [[self.feed loadFeedItems] mutableCopy];

  if (error) {
    NSLog(@"Something went wrong: %@", error.localizedDescription);
  }

  [self reload];
}

-(IBAction)tappedAdd:(id)sender {
  FeedItemKind kind = (FeedItemKind) [_actionButtons indexOfObject: sender];

  if(kind == FeedItemKindSleep && [self.feed babySleeping]) {
    kind = FeedItemKindAwake;
  }

  if(kind == FeedItemKindMoment) {
    __weak ViewController *weakSelf = self;
    [self.feed addMomentOnPresenter:self
                         completion:^(FeedItem *moment) {
      [weakSelf.items insertObject:moment atIndex:0];
      [weakSelf reload];
    }];
  } else {
    [self.items insertObject:[self.feed addFeedItemOfKind:kind] atIndex:0];
    [self reload];
  }
}

- (void)reload {
  // Reload buttons
  for (FeedItemKind kind = 0; kind < 5; kind++) {
    if(kind == FeedItemKindSleep && [self.feed babySleeping]) {
      kind = FeedItemKindAwake;
    }
  }

  // Reload table
  [self.tblFeed reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FeedItem *item = self.items[indexPath.item];
  FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell" forIndexPath:indexPath];

  [cell configureWithFeedItem:item];

  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  FeedItem *item = self.items[indexPath.item];

  if(item.attachmentId == nil) {
    return 64;
  } else {
    return 200;
  }
}

@end
