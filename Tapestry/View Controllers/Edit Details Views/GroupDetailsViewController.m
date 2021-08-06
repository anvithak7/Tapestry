//
//  GroupDetailsViewController.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/22/21.
//

#import "GroupDetailsViewController.h"
#import "ChangeGroupNameViewController.h"
#import "GroupImageCell.h"
#import "TextCell.h"
#import "InviteCodeCell.h"
#import "MemberCell.h"

@interface GroupDetailsViewController ()  <UITableViewDelegate, UITableViewDataSource, AddImageDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tapestryMembers;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) PFFileObject *groupImageFile;
@property (nonatomic, strong) GroupImageCell *groupImageCell;
@property (nonatomic, strong) TextCell *groupNameCell;
@property (nonatomic) BOOL privateGroup;

@end

@implementation GroupDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.alertManager = [AlertManager new];
    self.APIManager = [TapestryAPIManager new];
    self.imageManager = [[AddImageManager alloc] initWithViewController:self];
    [self fetchTableData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self fetchTableData];
}

- (void)fetchTableData {
    [self.APIManager fetchGroup:self.group :^(PFObject * _Nonnull group, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            self.tapestryMembers = [group[@"membersArray"] copy];
            self.tableData = [NSMutableArray new];
            if (group[@"groupImage"]) {
                self.groupImageFile = group[@"groupImage"];
            } else {
                self.groupImageFile = nil;
            }
            PFUser *user = [PFUser currentUser];
            [self.APIManager fetchUser:user :^(PFUser * _Nonnull user, NSError * _Nonnull error) {
                Group *userStories = [user objectForKey:@"userStories"];
                if ([userStories.objectId isEqual:group.objectId]) {
                    [self.tableData addObjectsFromArray:@[@[@"Image", group[@"groupName"]]]];
                    [self.tableData insertObject:self.tapestryMembers atIndex:1];
                    self.privateGroup = YES;
                } else {
                    [self.tableData addObjectsFromArray:@[@[@"Image", group[@"groupName"]], @[group[@"groupInviteCode"]], @[@"Leave Tapestry"]]];
                    [self.tableData insertObject:self.tapestryMembers atIndex:2];
                    self.privateGroup = NO;
                }
                [self.tableView reloadData];
            }];
        }
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            GroupImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupImageCell"];
            cell.groupImageView.file = self.groupImageFile;
            if (cell.groupImageView.file) {
                [cell.groupImageView loadInBackground];
            }
            return cell;
        } else {
            TextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"];
            cell.cellTextLabel.text = self.tableData[indexPath.section][1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }
    if (self.privateGroup) { // If it's a my stories group, users should not be able to share the invite code or leave the group.
        if (indexPath.section == 1) {
            MemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell"];
            PFUser *user = self.tapestryMembers[indexPath.row];
            cell.group = self.group;
            cell.user = user;
            return cell;
        } else {
            TextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"];
            cell.cellTextLabel.text = self.tableData[indexPath.section][0];
            return cell;
        }
    } else {
        if (indexPath.section == 1) {
                InviteCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InviteCodeCell"];
                cell.inviteCodeField.text = self.tableData[indexPath.section][0];
                [cell.inviteCodeField sizeToFit];
                return cell;
        } else if (indexPath.section == 2) {
            MemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell"];
            PFUser *user = self.tapestryMembers[indexPath.row];
            cell.group = self.group;
            cell.user = user;
            return cell;
        } else {
            TextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"];
            cell.cellTextLabel.text = self.tableData[indexPath.section][0];
            return cell;
        }
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableData.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Settings";
    }
    if (self.privateGroup) {
        if (section == 1) {
            return @"Weavers";
        }
    } else {
        if (section == 1) {
            return @"Invite Code";
        }
        if (section == 2) {
            return @"Weavers";
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // This is the image;
            return 250;
        } else {
            return 48;
        }
    } else if (indexPath.row == 2) {
        return 48; // These are the tapestry members
    } else {
        return 48;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // Change group image
            self.groupImageCell = (GroupImageCell*) [self.tableView cellForRowAtIndexPath:indexPath];
            [self presentViewController:[self.imageManager addImageOptionsControllerTo:self] animated:YES completion:^{
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            }];
        } else if (indexPath.row == 1) {
            self.groupNameCell = (TextCell*) [self.tableView cellForRowAtIndexPath:indexPath];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ChangeGroupNameViewController *changeGroupNameViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChangeGroupNameViewController"];
            changeGroupNameViewController.group = self.group;
            changeGroupNameViewController.previousView = self;
            [self presentViewController:changeGroupNameViewController animated:YES completion:^{
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                [self fetchTableData];
            }];
        }
    }
    if (!self.privateGroup) {
        if (indexPath.section == 1) {
            InviteCodeCell *inviteCodeCell = [self.tableView cellForRowAtIndexPath:indexPath];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [inviteCodeCell becomeFirstResponder];
                 UIMenuController* menuController = [UIMenuController sharedMenuController];
                 UIMenuItem* copyItem = [[UIMenuItem alloc] initWithTitle:@"Copy"
                                                                   action:@selector(copyTextFieldContent:)];
                 menuController.menuItems = @[copyItem];
                 CGRect selectionRect = inviteCodeCell.inviteCodeField.frame;
                [menuController showMenuFromView:inviteCodeCell.contentView rect:selectionRect];
             });
        } else if (indexPath.section == 3) {
            // Bring up an alert to ask if the user really wants to leave
            [self createAlertForLeavingTapestry];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFUser *user = [PFUser currentUser];
    [user fetchIfNeededInBackground];
    PFUser *admin = self.group.administrator;
    [admin fetchIfNeededInBackground];
    BOOL adminAccess = [PFUser.currentUser.objectId isEqual:self.group.administrator.objectId];
    if (!self.privateGroup && adminAccess && indexPath.section == 2) {
        UIContextualAction *removeUser = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Remove" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [self createAlertForRemovingUserFromTapestryFor:indexPath];
        }];
        UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:[[NSArray alloc] initWithObjects:removeUser, nil]];
        return actions;
    }
    return nil;
}

- (void)createAlertForRemovingUserFromTapestryFor:(NSIndexPath*)indexPath {
    MemberCell *memberCell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *removingUser = [@"Are you sure you want to remove " stringByAppendingString:memberCell.memberName.text];
    NSString *removingUserQuestion = [removingUser stringByAppendingString:@" from this tapestry?"];
    UIAlertController* removeUserController = [UIAlertController alertControllerWithTitle:removingUserQuestion message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* removeUserAction = [UIAlertAction actionWithTitle:@"Remove" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        PFUser *member = memberCell.user;
        [self removeMember:member];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [removeUserController addAction:removeUserAction];
    [removeUserController addAction:cancelAction];
    [self presentViewController:removeUserController animated:YES completion:nil];
}

- (void)removeMember:(PFUser*)member {
    NSLog(@"member %@", member);
    [self.APIManager fetchUser:member :^(PFUser * _Nonnull user, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            [self.group removeObject:user forKey:@"membersArray"];
            [self.group setObject:@1 forKey:@"groupMembersEdited"];
            [self.group saveInBackground];
            [self fetchTableData];
            /* I need to figure out how to remove the group from the user who was removed too!
            NSMutableArray *groups = user[@"groups"];
            [groups removeObject:self.group];
            NSMutableDictionary *properties = [NSMutableDictionary new];
            [properties setObject:groups
                      forKey:@"groups"];
            [self.APIManager updateObject:user withProperties:properties :^(BOOL succeeded, NSError * _Nonnull error) {
                if (succeeded) {
                    NSLog(@"Member removed from tapestry.");
                    [self fetchTableData];
                } else {
                    [self.alertManager createAlert:self withMessage:error.description error:@"Error"];
                }
            }]; */
        }
    }];
}

- (void)copyTextFieldContent:(id)sender {
    UIPasteboard* pb = [UIPasteboard generalPasteboard];
    pb.string = self.tableData[1][0];
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:YES];
}

- (void)createAlertForLeavingTapestry {
    NSString *leavingGroup = [@"Leave " stringByAppendingString:self.group.groupName];
    NSString *leavingGroupQuestion = [leavingGroup stringByAppendingString:@"?"];
    UIAlertController* leaveGroupController = [UIAlertController alertControllerWithTitle:leavingGroupQuestion message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* leaveGroupAction = [UIAlertAction actionWithTitle:@"Leave Tapestry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self leaveGroup];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [leaveGroupController addAction:leaveGroupAction];
    [leaveGroupController addAction:cancelAction];
    [self presentViewController:leaveGroupController animated:YES completion:nil];
}

- (void)leaveGroup {
    PFUser *user = [PFUser currentUser];
    [self.APIManager fetchUser:user :^(PFUser * _Nonnull user, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            [self.group removeObject:user forKey:@"membersArray"];
            [self.group saveInBackground];
            NSMutableArray *groups = user[@"groups"];
            [groups removeObject:self.group];
            NSMutableDictionary *properties = [NSMutableDictionary new];
            [properties setObject:groups
                      forKey:@"groups"];
            [self.APIManager updateObject:user withProperties:properties :^(BOOL succeeded, NSError * _Nonnull error) {
                if (succeeded) {
                    NSLog(@"User left the tapestry.");
                    UINavigationController *nav = [self navigationController];
                    [nav popViewControllerAnimated:YES];
                    [nav popViewControllerAnimated:YES];
                } else {
                    [self.alertManager createAlert:self withMessage:error.description error:@"Error"];
                }
            }];
        }
    }];
}

#pragma mark Change Group Image Methods

- (UIImageView *)sendImageViewToFitInto {
    return self.groupImageCell.groupImageView;
}

- (void)setMediaUponPicking:(UIImage *)image {
    self.groupImageCell.groupImageView.image = image;
    [self.APIManager updateImageFor:self.group withKey:@"groupImage" withImageFile:[self.imageManager getImageFileFromManager] :^(BOOL succeeded, NSError * _Nonnull error) {
        if (succeeded) {
            NSLog(@"Group data was updated");
        } else {
            [self.alertManager createAlert:self withMessage:error.description error:@"Error"];
        }
    }];
}

- (BOOL)needsColorForImages {
    return YES;
}

@end
