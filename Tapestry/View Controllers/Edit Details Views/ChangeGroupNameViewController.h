//
//  ChangeGroupNameViewController.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/27/21.
//

#import <UIKit/UIKit.h>
#import "AlertManager.h"
#import "TapestryAPIManager.h"
#import "GroupDetailsViewController.h"
#import "Group.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangeGroupNameViewController : UIViewController

@property (nonatomic, strong) AlertManager *alertManager;
@property (nonatomic, strong) TapestryAPIManager *APIManager;
@property (nonatomic, strong) GroupDetailsViewController *previousView;
@property (nonatomic, strong) Group *group;
@property (weak, nonatomic) IBOutlet UITextField *groupNameField;

@end

NS_ASSUME_NONNULL_END
