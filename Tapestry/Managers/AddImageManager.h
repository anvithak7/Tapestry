//
//  AddImageManager.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/27/21.
//

#import <Foundation/Foundation.h>
#import "ImageFromWebViewController.h"
#import "AlertManager.h"
#import "AppColorManager.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

// This manager creates and controls the ways a user can add images to any part of the app, and also contains methods for resizing images and getting PFFiles.

@protocol AddImageDelegate

- (UIImageView*)sendImageViewToFitInto;
- (void)setMediaUponPicking:(UIImage* _Nullable)image;
- (void)needsColorForImages;

@end

@interface AddImageManager : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIColorPickerViewControllerDelegate, ImagesFromWebDelegate>

@property (nonatomic, strong) AlertManager *alertManager;
@property (nonatomic, strong) AppColorManager *colorManager;
@property (nonatomic, strong) UIViewController* myViewController;
@property (nonatomic, strong) UIImage* _Nullable imageForViewController;
@property (nonatomic, strong) PFFileObject* _Nullable fileForViewController;
@property (nonatomic) BOOL needsColor;

@property (weak, nonatomic) id<AddImageDelegate> delegate;

- (instancetype) initWithViewController:(UIViewController*)viewController;
- (UIAlertController*) addImageOptionsControllerTo:(UIViewController*)viewController;
- (void)resetImageManager;
- (UIImage* _Nullable)getImageFromManager;
- (PFFileObject*)getImageFileFromManager;
- (PFFileObject*)getPFFileFromImage:(UIImage * _Nullable)image;
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
