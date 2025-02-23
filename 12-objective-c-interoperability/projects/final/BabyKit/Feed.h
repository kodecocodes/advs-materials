/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2025 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

#import <Foundation/Foundation.h>
#import <BabyKit/FeedItem.h>
#import <PhotosUI/PhotosUI.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const FeedStorageFilename;

NS_REFINED_FOR_SWIFT
@interface Feed: NSObject <PHPickerViewControllerDelegate>

@property (nonatomic, readonly) BOOL babySleeping NS_SWIFT_NAME(isBabySleeping);

- (NSArray <FeedItem *> *) loadFeedItems;
- (FeedItem *) addFeedItem: (FeedItem *) item;
- (FeedItem *) addFeedItemOfKind: (FeedItemKind) kind;

- (NSUUID * _Nullable) storeImage:(UIImage *) image NS_SWIFT_NAME(storeImage(_:));

- (void) addMomentOnPresenter: (UIViewController *) presenter
                   completion: (void (^ _Nullable)(FeedItem *)) completion NS_SWIFT_UNAVAILABLE("Use `AddMomentView` instead");

@end

NS_ASSUME_NONNULL_END
