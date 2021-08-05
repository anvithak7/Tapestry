//
//  AddImageManager.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/27/21.
//

#import "AddImageManager.h"

@implementation AddImageManager

#pragma mark Initialization
- (instancetype)initWithViewController:(UIViewController<AddImageDelegate>*)viewController {
    self = [super init];
    if (self) {
     // remainder of your constructor
        self.myViewController = viewController;
        self.delegate = viewController;
        self.alertManager = [AlertManager new];
        self.colorManager = [AppColorManager new];
        self.needsColor = [self.delegate needsColorForImages];
    }
    return self;
}

#pragma mark Creating Add Image Panel

- (UIAlertController*)addImageOptionsControllerTo:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, ImagesFromWebDelegate>*)viewController {
    UIAlertController* addPhotoAction = [UIAlertController alertControllerWithTitle:@"Add Photo" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* fromCameraAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self createFromCameraImagePickerFor:viewController];
    }];
    UIAlertAction* fromPhotosAction = [UIAlertAction actionWithTitle:@"From Photos Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self createFromPhotosImagePickerFor:viewController];
    }];
    UIAlertAction* fromURL = [UIAlertAction actionWithTitle:@"From Web" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self createImageFromWebControllerFor:viewController];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [addPhotoAction addAction:fromCameraAction];
    [addPhotoAction addAction:fromPhotosAction];
    [addPhotoAction addAction:fromURL];
    NSLog(@"Needs color: %i", self.needsColor);
    if (self.needsColor) {
        UIAlertAction* selectColorAction = [UIAlertAction actionWithTitle:@"Choose Color" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self chooseColorForView:viewController];
        }];
        [addPhotoAction addAction:selectColorAction];
    }
    [addPhotoAction addAction:cancelAction];
    return addPhotoAction;
}

#pragma mark Add Image Options

- (void)createFromCameraImagePickerFor:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>*)viewController {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [viewController presentViewController:imagePickerVC animated:YES completion:nil];
    } else {
        [self.alertManager createAlert:viewController withMessage:@"Please allow camera access and try again!" error:@"Unable to Acccess Camera"];
    }
}

- (void)createFromPhotosImagePickerFor:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>*)viewController {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [viewController presentViewController:imagePickerVC animated:YES completion:nil];
    } else {
        [self.alertManager createAlert:viewController withMessage:@"Please allow photo library access and try again!" error:@"Unable to Acccess Photo Library"];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImageView* mediaView = [self.delegate sendImageViewToFitInto];
    CGSize imageSize = CGSizeMake(mediaView.frame.size.width, mediaView.frame.size.height);
    UIImage *resizedImage = [self resizeImage:originalImage withSize:imageSize];
    self.imageForViewController = resizedImage;
    [self.delegate setMediaUponPicking:resizedImage];
    // Dismiss UIImagePickerController to go back to your original view controller
    [self.myViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)createImageFromWebControllerFor:(UIViewController<ImagesFromWebDelegate>*)viewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ImageFromWebViewController *imageFromWebViewController = [storyboard instantiateViewControllerWithIdentifier:@"ImageFromWebViewController"];
    imageFromWebViewController.delegate = self;
    [viewController presentViewController:imageFromWebViewController animated:YES completion:nil];
}

- (void)setImageFromWeb:(UIImage *)image {
    if (image) {
        self.imageForViewController = image;
        [self.delegate setMediaUponPicking:image];
    }
}

- (void)chooseColorForView:(UIViewController*)viewController {
    UIColorPickerViewController *colorPicker = [UIColorPickerViewController new];
    colorPicker.delegate = self;
    colorPicker.supportsAlpha = true;
    [viewController presentViewController:colorPicker animated:YES completion:nil];
}

- (void)colorPickerViewControllerDidFinish:(UIColorPickerViewController *)viewController {
    if (!self.imageForViewController) {
        self.imageForViewController = [self.colorManager imageFromColor:[self.colorManager getRandomColorForTheme]];
    }
    [self.delegate setMediaUponPicking:self.imageForViewController];
}

- (void)colorPickerViewControllerDidSelectColor:(UIColorPickerViewController *)viewController {
    UIImage *image = [self.colorManager imageFromColor:viewController.selectedColor];
    self.imageForViewController = image;
}

#pragma mark Methods for Getting, Resizing, and Resetting

- (UIImage* _Nullable)getImageFromManager {
    return self.imageForViewController;
}

- (PFFileObject*)getImageFileFromManager {
    return [self getPFFileFromImage:self.imageForViewController];
}

- (PFFileObject *)getPFFileFromImage:(UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

- (void)resetImageManager {
    self.imageForViewController = nil;
    self.fileForViewController = nil;
}

// This function resizes images in case they are too large so they can be stored in the database.
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
