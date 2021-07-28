//
//  AddImageManager.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/27/21.
//

#import "AddImageManager.h"

@implementation AddImageManager

- (UIAlertController*) addImageOptionsControllerTo:(UIViewController*)viewController {
    UIAlertController* addPhotoAction = [UIAlertController alertControllerWithTitle:@"Add Photo" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* fromCameraAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self.delegate fromCamera];
    }];
    UIAlertAction* fromPhotosAction = [UIAlertAction actionWithTitle:@"From Photos Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self.delegate fromLibrary];
    }];
    UIAlertAction* fromURL = [UIAlertAction actionWithTitle:@"From Web" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self.delegate fromWeb];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [addPhotoAction addAction:fromCameraAction];
    [addPhotoAction addAction:fromPhotosAction];
    [addPhotoAction addAction:fromURL];
    [addPhotoAction addAction:cancelAction];
    return addPhotoAction;
}

- (UIImagePickerController*)createFromCameraImagePickerFor:(UIViewController*)viewController {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        return imagePickerVC;
    }
    return nil;
}

- (UIImagePickerController*)createFromPhotosImagePickerFor:(UIViewController*)viewController {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        return imagePickerVC;
    }
    return nil;
}

- (ImageFromWebViewController*)createImageFromWebControllerFor:(UIViewController*)viewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ImageFromWebViewController *imageFromWebViewController = [storyboard instantiateViewControllerWithIdentifier:@"ImageFromWebViewController"];
    return imageFromWebViewController;
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
