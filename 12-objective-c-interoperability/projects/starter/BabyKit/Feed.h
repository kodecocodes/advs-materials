/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

#import <Foundation/Foundation.h>
#import <BabyKit/FeedItem.h>
#import <PhotosUI/PhotosUI.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const FeedStorageFilename;

@interface Feed: NSObject <PHPickerViewControllerDelegate>

@property (nonatomic, readonly) BOOL babySleeping;

- (NSArray <FeedItem *> *) loadFeedItems;
- (FeedItem *) addFeedItem: (FeedItem *) item;
- (FeedItem *) addFeedItemOfKind: (FeedItemKind) kind;

- (NSUUID * _Nullable) storeImage:(UIImage *) image;

- (void) addMomentOnPresenter: (UIViewController *) presenter
                   completion: (void (^ _Nullable)(FeedItem *)) completion;

@end

NS_ASSUME_NONNULL_END
