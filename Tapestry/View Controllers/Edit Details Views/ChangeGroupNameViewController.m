//
//  ChangeGroupNameViewController.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/27/21.
//

#import "ChangeGroupNameViewController.h"

@interface ChangeGroupNameViewController ()

@end

@implementation ChangeGroupNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.groupNameField.text = self.group.groupName;
    self.alertManager = [AlertManager new];
    self.APIManager = [TapestryAPIManager new];
}

- (IBAction)onTapAnywhere:(id)sender {
    [self.groupNameField endEditing:true];
}

- (IBAction)saveGroupNameButton:(id)sender {
    self.group.groupName = self.groupNameField.text;
    NSMutableDictionary *properties  = [NSMutableDictionary new];
    [properties setObject:self.groupNameField.text
              forKey:@"groupName"];
    [self.APIManager updateObject:self.group withProperties:properties :^(BOOL succeeded, NSError * _Nonnull error) {
        if (succeeded) {
            NSLog(@"Group name was updated");
            [self.previousView fetchTableData];
        } else {
            [self.alertManager createAlert:self withMessage:error.description error:@"Error"];
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelEditingButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
