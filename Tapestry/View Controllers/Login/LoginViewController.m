//
//  LoginViewController.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/13/21.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

// This view controller is for the user to be able to input their credentials and log in.

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.alertManager = [AlertManager new];
}

// After validating that the username and password fields are not empty, this function logs the user in after authenticating them with Parse.
- (IBAction)onTapLogin:(id)sender {
    BOOL validated = [self validateFields];
    if (validated) {
        [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(PFUser * user, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                [self.alertManager createAlert:self withMessage:@"Unable to login. Please check your credentials or your internet connection and try again!" error:@"Login Failed"];
            } else {
                NSLog(@"User logged in successfully!");
                [self performSegueWithIdentifier:@"LoginToHome" sender:nil]; // Manually segue to logged in view
            }
        }];
    }
}

// The sign up button allows users to easily switch between creating a new account and logging in.
- (IBAction)onTapSignUp:(id)sender {
    [self performSegueWithIdentifier:@"LoginToSignUp" sender:nil];
}

// A user can close the keyboard by tapping anywhere on the screen.
- (IBAction)onTapAnywhere:(id)sender {
    [self.view endEditing:true];
}


// The below method checks for whether fields are blank, in which case an alert would be displayed.
- (BOOL) validateFields {
    if ([self.usernameField.text isEqual:@""]) {
        [self.alertManager createAlert:self withMessage:@"Username cannot be blank. Please enter a valid username and try again!" error:@"Unable to Login"];
        return NO;
    } else if ([self.passwordField.text isEqual:@""]) {
        [self.alertManager createAlert:self withMessage:@"Password cannot be blank. Please enter a valid password and try again!" error:@"Unable to Login"];
        return NO;
    }
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
