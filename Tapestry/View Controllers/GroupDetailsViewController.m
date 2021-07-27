//
//  GroupDetailsViewController.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/22/21.
//

#import "GroupDetailsViewController.h"
#import "GroupImageCell.h"
#import "TextCell.h"
#import "MemberCell.h"

@interface GroupDetailsViewController ()  <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tapestryMembers;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) PFFileObject *groupImageFile;

@end

@implementation GroupDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.APIManager = [TapestryAPIManager new];
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
            [self.tableData addObjectsFromArray:@[@[@"Image", group[@"groupName"]], @[@"Leave Tapestry"]]];
            [self.tableData insertObject:self.tapestryMembers atIndex:1];
            NSLog(@"Table data: %@", self.tableData);
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
            return cell;
        }
    } else if (indexPath.section == 1) {
        MemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell"]; // We create a table view cell of type PostCell.
        PFUser *user = self.tapestryMembers[indexPath.row];
        //cell.delegate = self; // The view controller is the delegate for the post cell (this allows us to add segue functionality to the button inside each post cell, with each cell allowing for going to the associated user.
        cell.group = self.group;
        cell.user = user;
        return cell;
    } else {
        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"];
        cell.cellTextLabel.text = self.tableData[indexPath.section][0];
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableData.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
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
    } else if (indexPath.row == 1) {
        return 48; // These are the tapestry members
    } else {
        return 48;
    }
}

@end
