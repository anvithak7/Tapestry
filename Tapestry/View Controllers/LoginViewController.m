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
}

- (IBAction)onTapLogin:(id)sender {
    NSLog(@"Started login process");
    BOOL validated = [self validateFields];
    if (validated) {
        [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(PFUser * user, NSError * error) {
            ;            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                [self createAlert:@"Unable to login. Please check your credentials or your internet connection and try again!" error:@"Login Failed"];
            } else {
                NSLog(@"User registered successfully");
                [self performSegueWithIdentifier:@"LoginToHome" sender:nil]; // Manually segue to logged in view
            }
        }];
    }
}

- (IBAction)onTapSignUp:(id)sender {
    [self performSegueWithIdentifier:@"LoginToSignUp" sender:nil];
}

- (IBAction)onTapAnywhere:(id)sender {
    [self.view endEditing:true];
}


// The below method checks for whether fields are blank, in which case an error would be thrown.
- (BOOL) validateFields {
    if ([self.usernameField.text isEqual:@""]) {
        [self createAlert:@"Username cannot be blank. Please enter a valid username and try again!" error:@"Unable to Login"];
        return NO;
    } else if ([self.passwordField.text isEqual:@""]) {
        [self createAlert:@"Password cannot be blank. Please enter a valid password and try again!" error:@"Unable to Login"];
        return NO;
    }
    return YES;
}

// A function to create alerts, instead of writing this out multiple times.
- (void) createAlert: (NSString *)message error:(NSString*)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:error message:message preferredStyle:(UIAlertControllerStyleAlert)];
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    // handle response here.
    }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    // show alert
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
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
