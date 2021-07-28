//
//  AddImageManager.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/27/21.
//

#import "AddImageManager.h"

@implementation AddImageManager

- (instancetype) initWithViewController:(UIViewController*)viewController {
    self = [super init];
    if (self) {
     // remainder of your constructor
        self.myViewController = viewController;
        self.alertManager = [AlertManager new];
    }
    return self;
}

- (UIAlertController*) addImageOptionsControllerTo:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, ImagesFromWebDelegate>*)viewController {
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
    [addPhotoAction addAction:cancelAction];
    return addPhotoAction;
}

// UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>*
- (void)createFromCameraImagePickerFor:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>*)viewController {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.delegate = viewController;
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
    imagePickerVC.delegate = viewController;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [viewController presentViewController:imagePickerVC animated:YES completion:nil];
    } else {
        [self.alertManager createAlert:viewController withMessage:@"Please allow photo library access and try again!" error:@"Unable to Acccess Photo Library"];
    }
}

- (void)createImageFromWebControllerFor:(UIViewController<ImagesFromWebDelegate>*)viewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ImageFromWebViewController *imageFromWebViewController = [storyboard instantiateViewControllerWithIdentifier:@"ImageFromWebViewController"];
    imageFromWebViewController.delegate = viewController;
    [viewController presentViewController:imageFromWebViewController animated:YES completion:nil];
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
