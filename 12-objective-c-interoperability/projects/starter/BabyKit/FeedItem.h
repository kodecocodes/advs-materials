/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2025 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

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
