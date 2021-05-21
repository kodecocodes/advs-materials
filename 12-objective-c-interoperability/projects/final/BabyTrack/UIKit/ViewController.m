/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

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
    UIButton *button = self.actionButtons[kind];

    if(kind == FeedItemKindSleep && [self.feed babySleeping]) {
      kind = FeedItemKindAwake;
    }

    [button setTitle:[FeedItem emojiForKind:kind]
            forState:UIControlStateNormal];
    [button setBackgroundColor:[FeedItem colorForKind:kind]];
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
