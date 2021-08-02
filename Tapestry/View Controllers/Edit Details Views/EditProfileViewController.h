//
//  EditProfileViewController.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/27/21.
//

#import <UIKit/UIKit.h>
#import "AlertManager.h"
#import "TapestryAPIManager.h"
#import "AddImageManager.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface EditProfileViewController : UIViewController
@property (nonatomic, strong) AlertManager *alertManager;
@property (nonatomic, strong) TapestryAPIManager *APIManager;
@property (nonatomic, strong) AddImageManager *imageManager;
@property (nonatomic, strong) PFUser *user;
@property (weak, nonatomic) IBOutlet PFImageView *profilePhotoView;
@property (weak, nonatomic) IBOutlet UIButton *changeProfilePhotoButton;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

@end

NS_ASSUME_NONNULL_END
