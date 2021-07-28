//
//  GroupDetailsViewController.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/22/21.
//

#import <UIKit/UIKit.h>
#import "AlertManager.h"
#import "TapestryAPIManager.h"
#import "AddImageManager.h"
#import "Group.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface GroupDetailsViewController : UIViewController
@property (strong, nonatomic) AlertManager *alertManager;
@property (strong, nonatomic) TapestryAPIManager *APIManager;
@property (strong, nonatomic) AddImageManager *imageManager;
@property (strong, nonatomic) Group *group;
@end

NS_ASSUME_NONNULL_END
