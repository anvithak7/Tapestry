//
//  AddImageManager.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/27/21.
//

#import <Foundation/Foundation.h>
#import "ImageFromWebViewController.h"
#import "AlertManager.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface AddImageManager : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) AlertManager *alertManager;
@property (nonatomic, strong) UIViewController* myViewController;

- (instancetype) initWithViewController:(UIViewController*)viewController;
- (UIAlertController*) addImageOptionsControllerTo:(UIViewController*)viewController;
- (void)createFromCameraImagePickerFor:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>*)viewController;
- (void)createFromPhotosImagePickerFor:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>*)viewController;
- (void)createImageFromWebControllerFor:(UIViewController<ImagesFromWebDelegate>*)viewController;
- (PFFileObject *)getPFFileFromImage:(UIImage * _Nullable)image;
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
