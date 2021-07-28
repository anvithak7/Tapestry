//
//  EditProfileViewController.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/27/21.
//

#import "EditProfileViewController.h"
#import "ImageFromWebViewController.h"

@interface EditProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagesFromWebDelegate>

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.alertManager = [AlertManager new];
    self.APIManager = [TapestryAPIManager new];
    self.imageManager = [[AddImageManager alloc] initWithViewController:self];
    self.profilePhotoView.layer.masksToBounds = YES;
    self.profilePhotoView.layer.cornerRadius = self.profilePhotoView.frame.size.width / 2;
    self.nameField.text = self.user[@"fullName"];
    self.usernameField.text = self.user.username;
    self.emailField.text = self.user.email;
    self.profilePhotoView.file = self.user[@"avatarImage"];
    [self.profilePhotoView loadInBackground];
}

- (IBAction)changeProfilePhoto:(id)sender {
    [self presentViewController:[self.imageManager addImageOptionsControllerTo:self] animated:YES completion:nil];
}

- (IBAction)onTapDone:(id)sender {
    NSMutableDictionary *properties = [NSMutableDictionary new];
    [properties setValue:self.nameField.text forKey:@"fullName"];
    [properties setValue:self.usernameField.text forKey:@"username"];
    [properties setValue:self.emailField.text forKey:@"email"];
    [properties setValue:[self.imageManager getPFFileFromImage:self.profilePhotoView.image] forKey:@"avatarImage"];
    [self.APIManager updateObject:self.user withProperties:properties :^(BOOL succeeded, NSError * _Nonnull error) {
        if (succeeded) {
            NSLog(@"User profile was updated");
        } else {
            [self.alertManager createAlert:self withMessage:error.description error:@"Error"];
        }
    }];
    UINavigationController *nav = [self navigationController];
    [nav popViewControllerAnimated:YES]; // Allows us to go back without stacking too many views over each other each time.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    CGSize imageSize = CGSizeMake(self.profilePhotoView.frame.size.width, self.profilePhotoView.frame.size.height);
    UIImage *resizedImage = [self.imageManager resizeImage:originalImage withSize:imageSize];
    self.profilePhotoView.image = resizedImage;
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setImageFromWeb:(UIImage * _Nullable)image {
    if (image) {
        CGSize imageSize = CGSizeMake(self.profilePhotoView.frame.size.width, self.profilePhotoView.frame.size.height);
        UIImage *resizedImage = [self.imageManager resizeImage:image withSize:imageSize];
        self.profilePhotoView.image = resizedImage;
    }
}

@end
