/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

#import <Foundation/Foundation.h>

typedef enum {
  FeedItemKindBottle,
  FeedItemKindFood,
  FeedItemKindSleep,
  FeedItemKindDiaper,
  FeedItemKindMoment,
  FeedItemKindAwake
} FeedItemKind;

@interface FeedItem: NSObject

- (FeedItem *) initWithKind: (FeedItemKind) kind;

- (FeedItem *) initWithKind: (FeedItemKind) kind
                       date: (NSDate *) date;

- (FeedItem *) initWithKind: (FeedItemKind) kind
                       date: (NSDate *) date
               attachmentId: (NSUUID *) attachmentId;

@property (nonatomic, assign) FeedItemKind kind;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSUUID * attachmentId;
@end

NSString * FeedItemKindDescription(FeedItemKind);
