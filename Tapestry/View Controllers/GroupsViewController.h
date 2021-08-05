//
//  GroupsViewController.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/19/21.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "TapestryAPIManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupsViewController : UIViewController
@property (nonatomic, strong) TapestryAPIManager *APIManager;

@end

NS_ASSUME_NONNULL_END
