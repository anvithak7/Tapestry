//
//  AddGroupsViewController.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/13/21.
//

#import "AddGroupsViewController.h"
#import "Group.h"

@interface AddGroupsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *createGroupButton;
@property (weak, nonatomic) IBOutlet UIButton *joinGroupButton;
@property (weak, nonatomic) IBOutlet UIView *createNewView;
@property (weak, nonatomic) IBOutlet UITextField *groupName;
@property (weak, nonatomic) IBOutlet UIButton *justMeButton;
@property (weak, nonatomic) IBOutlet UIButton *friendsButton;
@property (weak, nonatomic) IBOutlet UIButton *familyButton;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteStringLabel;
@property (weak, nonatomic) IBOutlet UIView *joinGroupView;
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeEntryField;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIImageView *doneCreating;
@property (weak, nonatomic) IBOutlet UIImageView *doneJoining;
@property (nonatomic) BOOL createGroupShow;
@property (nonatomic) BOOL joinGroupShow;

@end

@implementation AddGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.createNewView.alpha = 0;
    self.joinGroupView.alpha = 0;
    self.doneCreating.alpha = 0;
    self.doneJoining.alpha = 0;
    self.createGroupShow = NO;
    self.joinGroupShow = NO;
}

- (IBAction)onTapAnywhere:(id)sender {
    [self.view endEditing:true];
}

// When a user taps create, the necessary elements to create a group are opened up.
- (IBAction)onTapCreate:(id)sender {
    if (!self.createGroupShow) {
        [UIView animateWithDuration:0.2 animations:^{
        CGRect joinButtonFrame = self.joinGroupButton.frame;
        joinButtonFrame.origin.y += 400;
        self.joinGroupButton.frame = joinButtonFrame;
        self.createNewView.alpha = 1;
        self.joinGroupView.alpha = 0;
        }];
        self.createGroupShow = YES;
    } else if (self.createGroupShow) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect joinButtonFrame = self.joinGroupButton.frame;
            joinButtonFrame.origin.y -= 400;
            self.joinGroupButton.frame = joinButtonFrame;
            self.createNewView.alpha = 0;
            self.joinGroupView.alpha = 0;
        }];
        self.createGroupShow = NO;
    }
}

// When a user taps join, the necessary elements to join a group are opened up.
- (IBAction)onTapJoin:(id)sender {
    if (!self.joinGroupShow) {
        [UIView animateWithDuration:0.2 animations:^{
            self.joinGroupView.alpha = 1;
            self.createNewView.alpha = 0;
        }];
        self.joinGroupShow = YES;
    } else if (self.joinGroupShow) {
        [UIView animateWithDuration:0.2 animations:^{
            self.joinGroupView.alpha = 0;
            self.createNewView.alpha = 0;
        }];
        self.joinGroupShow = NO;
    }
}

- (IBAction)instantiateGroup:(id)sender {
    NSString *inviteCode = [Group createGroup:self.groupName.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            [self createAlert:@"Unable to create tapestry. Please check your internet connection and try again!" error:@"Unable to Create Tapestry"];
        }
    }];
    self.doneCreating.alpha = 1;
    self.inviteStringLabel.text = inviteCode;
}

- (IBAction)joinGroup:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query whereKey:@"groupInviteCode" equalTo:self.inviteCodeEntryField.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *group, NSError *error) {
        if (error != nil) {
            [self createAlert:@"Unable to join tapestry. Please check your internet connection and try again!" error:@"Unable to Join Tapestry"];
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            Group *groupToJoin = group[0];
            NSLog(@"%@", groupToJoin);
            [groupToJoin fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Error: %@", error.localizedDescription);
                } else {
                    NSLog(@"Members array!!!!! : %@", groupToJoin[@"membersArray"]);
                    [groupToJoin addUniqueObject:PFUser.currentUser forKey:@"membersArray"];
                    [PFUser.currentUser addObject:groupToJoin forKey:@"groups"];
                    [PFObject saveAllInBackground:@[groupToJoin, PFUser.currentUser] block:^(BOOL succeeded, NSError * _Nullable error) {
                        if (succeeded) {
                            NSLog(@"Current user groups %@", PFUser.currentUser[@"groups"]);
                            NSLog(@"%@", groupToJoin.membersArray);
                            self.doneJoining.alpha = 1;
                        } else {
                            NSLog(@"Error: %@", error.localizedDescription);
                        }
                    }];
                }
            }];
        }
    }];
}

- (IBAction)onTapDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        // Do something after the view goes back.
    }];
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
