//
//  AddGroupsViewController.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "TapestryAPIManager.h"
#import "AlertManager.h"
#import "AppColorManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddGroupsViewController : UIViewController
@property (nonatomic, strong) TapestryAPIManager *APIManager;
@property (nonatomic, strong) AlertManager *alertManager;
@property (nonatomic, strong) AppColorManager *colorManager;

@end

NS_ASSUME_NONNULL_END
