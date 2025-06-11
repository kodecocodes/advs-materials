/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2025 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

#import <UIKit/UIKit.h>
#import <BabyKit/BabyKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedCell : UITableViewCell

- (void)configureWithFeedItem:(FeedItem *)feedItem;

@end

NS_ASSUME_NONNULL_END
