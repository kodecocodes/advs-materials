/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

#import <UIKit/UIKit.h>
#import <BabyKit/BabyKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedCell : UITableViewCell

- (void)configureWithFeedItem:(FeedItem *)feedItem;

@end

NS_ASSUME_NONNULL_END
