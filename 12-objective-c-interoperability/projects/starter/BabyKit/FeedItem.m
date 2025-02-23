/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2025 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

#import "FeedItem.h"

@implementation FeedItem

- (FeedItem * _Nonnull) initWithKind: (FeedItemKind) kind {
  self = [super init];
  
  if (self) {
    self.kind = kind;
    self.date = [[NSDate new] dateByAddingTimeInterval: -1];
  }
  
  return self;
}

- (FeedItem * _Nonnull) initWithKind: (FeedItemKind) kind date:(NSDate *)date {
  self = [super init];
  
  if (self) {
    self.kind = kind;
    self.date = date;
  }
  
  return self;
}

- (FeedItem * _Nonnull)initWithKind:(FeedItemKind)kind date:(NSDate *)date attachmentId:(NSUUID *)attachmentId {
  self = [super init];
  
  if (self) {
    self.kind = kind;
    self.date = date == nil ? [[NSDate new] dateByAddingTimeInterval:-1] : date;
    self.attachmentId = attachmentId;
  }
  
  return self;
}

NSString * _Nonnull FeedItemKindDescription(FeedItemKind kind) {
  switch (kind) {
    case FeedItemKindFood:
      return @"Food";
    case FeedItemKindBottle:
      return @"Bottle";
    case FeedItemKindDiaper:
      return @"Diaper";
    case FeedItemKindSleep:
      return @"Sleeping";
    case FeedItemKindAwake:
      return @"Awake";
    case FeedItemKindMoment:
      return @"A moment";
    default:
      break;
  }
}
@end

