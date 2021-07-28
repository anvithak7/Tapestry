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
@protocol AddImageDelegate

- (UIImageView*)sendImageViewToFitInto;
- (void)setMediaUponPicking:(UIImage* _Nullable)image;

@end

@interface AddImageManager : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagesFromWebDelegate>

@property (nonatomic, strong) AlertManager *alertManager;
@property (nonatomic, strong) UIViewController* myViewController;
@property (nonatomic, strong) UIImage* imageForViewController;
@property (nonatomic, strong) PFFileObject* fileForViewController;

@property (weak, nonatomic) id<AddImageDelegate> delegate;

- (instancetype) initWithViewController:(UIViewController*)viewController;
- (UIAlertController*) addImageOptionsControllerTo:(UIViewController*)viewController;
- (UIImage* _Nullable)getImageFromManager;
- (PFFileObject*)getImageFileFromManager;
- (PFFileObject*)getPFFileFromImage:(UIImage * _Nullable)image;
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
