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
    self.imageManager = [AddImageManager alloc];
    self.imageManager.delegate = self;
    self.imageManager = [self.imageManager initWithViewController:self];
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
            [self.tableData addObjectsFromArray:@[@[@"Image", group[@"groupName"]], @[group[@"groupInviteCode"]], @[@"Leave Tapestry"]]];
            [self.tableData insertObject:self.tapestryMembers atIndex:2];
            NSLog(@"Table data: %@", self.tableData);
            [self.tableView reloadData];
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
    } else if (indexPath.section == 1) {
        InviteCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InviteCodeCell"];
        cell.inviteCodeField.text = self.tableData[indexPath.section][0];
        return cell;
    } else if (indexPath.section == 2) {
        MemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell"]; // We create a table view cell of type PostCell.
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

/*
- (void)longPressInviteCode:(UIGestureRecognizer*)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self becomeFirstResponder];
             UIMenuController* menuController = [UIMenuController sharedMenuController];
             UIMenuItem* copyItem = [[UIMenuItem alloc] initWithTitle:@"Copy"
                                                               action:@selector(copyTextContent:)];
             menuController.menuItems = @[copyItem];
             CGRect selectionRect = sender.view.frame;
        [menuController showMenuFromView:sender.view rect:selectionRect];
         });
}

- (void)copyTextContent:(id)sender {
    UIPasteboard* pb = [UIPasteboard generalPasteboard];
    pb.string = self.tableData[1][0];
} */

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
    if (section == 1) {
        return @"Invite Code";
    }
    if (section == 2) {
        return @"Weavers";
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
            [self presentViewController:[self.imageManager addImageOptionsControllerTo:self] animated:YES completion:nil];
        } else if (indexPath.row == 1) {
            self.groupNameCell = (TextCell*) [self.tableView cellForRowAtIndexPath:indexPath];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ChangeGroupNameViewController *changeGroupNameViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChangeGroupNameViewController"];
            changeGroupNameViewController.group = self.group;
            [self presentViewController:changeGroupNameViewController animated:YES completion:nil];
        }
    } else if (indexPath.section == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self becomeFirstResponder];
             UIMenuController* menuController = [UIMenuController sharedMenuController];
             UIMenuItem* copyItem = [[UIMenuItem alloc] initWithTitle:@"Copy"
                                                               action:@selector(copyTextFieldContent:)];
             menuController.menuItems = @[copyItem];
            InviteCodeCell *inviteCodeCell = [self.tableView cellForRowAtIndexPath:indexPath];
             CGRect selectionRect = inviteCodeCell.inviteCodeField.frame;
            [menuController showMenuFromView:inviteCodeCell.contentView rect:selectionRect];
         });
    } else if (indexPath.section == 3) {
        // Bring up an alert to ask if the user really wants to leave
        [self createAlertForLeavingTapestry];
    }
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
                } else {
                    [self.alertManager createAlert:self withMessage:error.description error:@"Error"];
                }
            }];
        }
    }];
    UINavigationController *nav = [self navigationController];
    [nav popViewControllerAnimated:YES];
    [nav popViewControllerAnimated:YES];
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

- (void)needsColorForImages {
    self.imageManager.needsColor = YES;
}

@end
