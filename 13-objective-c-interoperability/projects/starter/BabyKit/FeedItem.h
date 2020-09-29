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

#import <Foundation/Foundation.h>

//typedef NSString *FeedItemKind NS_EXTENSIBLE_STRING_ENUM;
//extern FeedItemKind const _Nonnull FeedItemKindBottle;
//extern FeedItemKind const _Nonnull FeedItemKindFood;
//extern FeedItemKind const _Nonnull FeedItemKindSleep;
//extern FeedItemKind const _Nonnull FeedItemKindDiaper;
//extern FeedItemKind const _Nonnull FeedItemKindMoment;
//extern FeedItemKind const _Nonnull FeedItemKindAwake;

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
