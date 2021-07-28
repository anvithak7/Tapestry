//
//  AddImageManager.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/27/21.
//

#import <Foundation/Foundation.h>
#import "ImageFromWebViewController.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@protocol AddImageDelegate

- (void)fromCamera;
- (void)fromLibrary;
- (void)fromWeb;

@end

@interface AddImageManager : NSObject

@property (weak, nonatomic) id<AddImageDelegate> delegate;

- (UIAlertController*) addImageOptionsControllerTo:(UIViewController*)viewController;
- (UIImagePickerController*)createFromCameraImagePickerFor:(UIViewController*)viewController;
- (UIImagePickerController*)createFromPhotosImagePickerFor:(UIViewController*)viewController;
- (ImageFromWebViewController*)createImageFromWebControllerFor:(UIViewController*)viewController;
- (PFFileObject *)getPFFileFromImage:(UIImage * _Nullable)image;
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
