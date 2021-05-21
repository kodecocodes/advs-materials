/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_CLOSED_ENUM(NSInteger, FeedItemKind) {
  FeedItemKindBottle,
  FeedItemKindFood,
  FeedItemKindSleep,
  FeedItemKindDiaper,
  FeedItemKindMoment,
  FeedItemKindAwake
} NS_SWIFT_NAME(FeedItem.Kind);

@interface FeedItem: NSObject

- (FeedItem *) initWithKind: (FeedItemKind) kind;

- (FeedItem *) initWithKind: (FeedItemKind) kind
                       date: (NSDate *) date;

- (FeedItem *) initWithKind: (FeedItemKind) kind
                       date: (NSDate * _Nullable) date
               attachmentId: (NSUUID * _Nullable) attachmentId;

@property (nonatomic, assign) FeedItemKind kind;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSUUID * _Nullable attachmentId;
@end

NSString * FeedItemKindDescription(FeedItemKind)
NS_SWIFT_NAME(getter:FeedItemKind.description(self:));

NS_ASSUME_NONNULL_END
