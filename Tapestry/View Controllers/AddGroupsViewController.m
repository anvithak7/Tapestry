//
//  AddGroupsViewController.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/13/21.
//

#import "AddGroupsViewController.h"
#import "Group.h"

@interface AddGroupsViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *createGroupButton;
@property (weak, nonatomic) IBOutlet UIButton *joinGroupButton;
@property (weak, nonatomic) IBOutlet UIView *createNewView;
@property (weak, nonatomic) IBOutlet UITextField *groupName;
@property (weak, nonatomic) IBOutlet UIButton *justMeButton;
@property (weak, nonatomic) IBOutlet UIButton *friendsButton;
@property (weak, nonatomic) IBOutlet UIButton *familyButton;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;
@property (weak, nonatomic) IBOutlet UITextField *inviteStringField;
@property (weak, nonatomic) IBOutlet UIView *joinGroupView;
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeEntryField;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIImageView *doneCreating;
@property (weak, nonatomic) IBOutlet UIImageView *doneJoining;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceBetweenCreateAndJoinButtons;
@property (nonatomic) BOOL createGroupShow;
@property (nonatomic) BOOL joinGroupShow;
@property (nonatomic) BOOL joinMoved;

@end

@implementation AddGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.alertManager = [AlertManager new];
    self.APIManager = [TapestryAPIManager new];
    self.colorManager = [AppColorManager new];
    self.createNewView.alpha = 0;
    self.joinGroupView.alpha = 0;
    self.doneCreating.alpha = 0;
    self.doneJoining.alpha = 0;
    self.createGroupShow = NO;
    self.joinGroupShow = NO;
    self.joinMoved = NO;
    self.inviteStringField.delegate = self;
    [self.justMeButton setImage:[self.colorManager imageFromColor:[self.colorManager getRandomColorForTheme]] forState:UIControlStateSelected];
    [self.justMeButton addTarget:self action:@selector(onTapTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.friendsButton setImage:[self.colorManager imageFromColor:[self.colorManager getRandomColorForTheme]] forState:UIControlStateSelected];
    [self.friendsButton addTarget:self action:@selector(onTapTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.familyButton setImage:[self.colorManager imageFromColor:[self.colorManager getRandomColorForTheme]] forState:UIControlStateSelected];
    [self.familyButton addTarget:self action:@selector(onTapTypeButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)onTapAnywhere:(id)sender {
    [self.view endEditing:true];
}

// When a user taps create, the necessary elements to create a group are opened up.
- (IBAction)onTapCreate:(id)sender {
    if (![self.groupName hasText]) {
        self.doneCreating.alpha = 0;
        self.inviteStringField.placeholder = @"Press create to generate an invite code!";
    }
    self.joinGroupShow = NO;
    if (!self.createGroupShow) {
        [self openCreateView];
    } else if (self.createGroupShow) {
        [self closeCreateView];
    }
}

- (void)openCreateView {
    [UIView animateWithDuration:0.1 animations:^{
        CGRect joinButtonFrame = self.joinGroupButton.frame;
        joinButtonFrame.origin.y += 306;
        CGRect joinViewFrame = self.joinGroupView.frame;
        joinViewFrame.origin.y += 306;
        self.joinGroupButton.frame = joinButtonFrame;
        self.joinGroupView.frame = joinViewFrame;
        self.spaceBetweenCreateAndJoinButtons.constant = 306;
        self.createNewView.alpha = 1;
        self.joinGroupView.alpha = 0;
        self.joinMoved = YES;
    }];
    self.createGroupShow = YES;
}

- (void)onTapTypeButton:(UIButton*)button {
    [button setSelected:YES];
}
- (void)closeCreateView {
    [UIView animateWithDuration:0.1 animations:^{
        CGRect joinButtonFrame = self.joinGroupButton.frame;
        joinButtonFrame.origin.y -= 306;
        CGRect joinViewFrame = self.joinGroupView.frame;
        joinViewFrame.origin.y -= 306;
        self.joinGroupButton.frame = joinButtonFrame;
        self.joinGroupView.frame = joinViewFrame;
        self.spaceBetweenCreateAndJoinButtons.constant = 80;
        self.createNewView.alpha = 0;
        self.joinGroupView.alpha = 0;
        if (self.joinMoved) {
            self.joinMoved = NO;
        }
    }];
    self.createGroupShow = NO;
}

// When a user taps join, the necessary elements to join a group are opened up.
- (IBAction)onTapJoin:(id)sender {
    self.createGroupShow = NO;
    if (self.joinMoved) {
        [UIView animateWithDuration:0.1 animations:^{
            CGRect joinButtonFrame = self.joinGroupButton.frame;
            joinButtonFrame.origin.y -= 306;
            CGRect joinViewFrame = self.joinGroupView.frame;
            joinViewFrame.origin.y -= 306;
            self.joinGroupButton.frame = joinButtonFrame;
            self.joinGroupView.frame = joinViewFrame;
            self.spaceBetweenCreateAndJoinButtons.constant = 80;
            self.joinMoved = NO;
        }];
    }
    if (!self.joinGroupShow) {
        [UIView animateWithDuration:0.1 animations:^{
            self.joinGroupView.alpha = 1;
            self.createNewView.alpha = 0;
        }];
        self.joinGroupShow = YES;
    } else if (self.joinGroupShow) {
        [UIView animateWithDuration:0.1 animations:^{
            self.joinGroupView.alpha = 0;
            self.createNewView.alpha = 0;
        }];
        self.joinGroupShow = NO;
    }
}

- (IBAction)groupNameEditingChanged:(id)sender {
    if (![self.groupName hasText]) {
        self.doneCreating.alpha = 0;
        self.inviteStringField.text = @"";
        self.inviteStringField.placeholder = @"Press create to generate an invite code!";
        [self.justMeButton setSelected:NO];
        [self.friendsButton setSelected:NO];
        [self.familyButton setSelected:NO];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if (textField != self.inviteStringField) {
        if (range.length + range.location > self.groupName.text.length) {
            return NO;
        }
        return self.groupName.text.length + (string.length - range.length) <= 50;
    }
    return textField != self.inviteStringField;
}

- (IBAction)groupNameEditingDidEnd:(id)sender {
    if (self.groupName.text.length > 50) {
        [self.alertManager createAlert:self withMessage:@"Please choose a shorter tapestry name and try again!" error:@"Tapestry Name Exceeds 50 Characters"];
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)copyTextFieldContent:(id)sender {
    UIPasteboard* pb = [UIPasteboard generalPasteboard];
    pb.string = self.inviteStringField.text;
}

// From this post: https://stackoverflow.com/a/31485463/16475718
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // UIKit changes the first responder after this method, so we need to show the copy menu after this method returns.
    if (textField == self.inviteStringField) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self becomeFirstResponder];
             UIMenuController* menuController = [UIMenuController sharedMenuController];
             UIMenuItem* copyItem = [[UIMenuItem alloc] initWithTitle:@"Copy"
                                                               action:@selector(copyTextFieldContent:)];
             menuController.menuItems = @[copyItem];
             CGRect selectionRect = textField.frame;
            [menuController showMenuFromView:self.createNewView rect:selectionRect];
         });
         return NO;
    }
    return YES;
}

- (IBAction)instantiateGroup:(id)sender {
    NSString *inviteCode = [Group createGroup:self.groupName.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            [self.alertManager createAlert:self withMessage:@"Unable to create tapestry. Please check your internet connection and try again!" error:@"Unable to Create Tapestry"];
        }
    }];
    self.doneCreating.alpha = 1;
    self.inviteStringField.text = inviteCode;
}

- (IBAction)joinGroup:(id)sender {
    if ([self.inviteCodeEntryField hasText]) {
        [self.APIManager joinGroupWithInviteCode:self.inviteCodeEntryField.text forUser:PFUser.currentUser :^(BOOL succeeded, NSError * _Nonnull error) {
            if (succeeded) {
                self.doneJoining.alpha = 1;
            } else {
                NSLog(@"Error: %@", error.localizedDescription);
                [self.alertManager createAlert:self withMessage:@"Unable to join tapestry. Please check your internet connection and try again!" error:@"Unable to Join Tapestry"];
            }
        }];
    } else {
        [self.alertManager createAlert:self withMessage:@"Please input a valid tapestry invite code and try again!" error:@"Unable to Join Tapestry"];
    }
}

- (IBAction)onTapDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        // Do something after the view goes back.
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
