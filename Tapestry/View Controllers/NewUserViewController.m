//
//  NewUserViewController.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/14/21.
//

#import "NewUserViewController.h"
#import "Parse/Parse.h"

// This view controller registers a new user to Tapestry.

@interface NewUserViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation NewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onTapSignUp:(id)sender {
    BOOL accepted = [self validateFields];
    if (accepted) {
        // initialize a user object
        PFUser *newUser = [PFUser user];
        
        // set user properties
        newUser.email = self.emailField.text;
        newUser[@"fullName"] = self.nameField.text;
        newUser.username = self.usernameField.text;
        newUser.password = self.passwordField.text;
        newUser[@"groups"] = [NSMutableArray new];
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                [self createAlert:error.localizedDescription error:@"Unable to Register User"];
            } else {
                NSLog(@"User registered successfully");
                [self performSegueWithIdentifier:@"SignUpToHome" sender:nil];
                // manually segue to logged in view
            }
        }];
    }
}

- (IBAction)onTapLogin:(id)sender {
    [self performSegueWithIdentifier:@"SignUpToLogin" sender:nil];
}

// A user can tap anywhere to stop editing the fields and close the keyboard.
- (IBAction)onTapAnywhere:(id)sender {
    [self.view endEditing:true];
}

// A function to create alerts, so I don't have to reuse all this code again within functions.
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

// The below method checks all of the fields and calls out errors in case any of the fields are blank. Parse seems to validate emails and valid strings, so I didn't have to do that here.
- (BOOL) validateFields {
    if ([self.nameField.text isEqual:@""]) {
        [self createAlert:@"Please enter your full name and try again!" error:@"Unable to Register User"];
        return NO;
    } else if ([self.emailField.text isEqual:@""]) {
        [self createAlert:@"Please enter a valid email and try again!" error:@"Unable to Register User"];
        return NO;
    } else if ([self.usernameField.text isEqual:@""]) {
        [self createAlert:@"Please choose a username and try again!" error:@"Unable to Register User"];
        return NO;
    } else if ([self.passwordField.text isEqual:@""]) {
        [self createAlert:@"Please enter a password and try again!" error:@"Unable to Register User"];
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
