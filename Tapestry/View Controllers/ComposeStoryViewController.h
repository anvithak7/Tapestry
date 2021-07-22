//
//  ComposeStoryViewController.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "TapestryAPIManager.h"
#import "AlertManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComposeStoryViewController : UIViewController
@property (nonatomic, strong) TapestryAPIManager *APIManager;
@property (nonatomic, strong) AlertManager *alertManager;
@end

NS_ASSUME_NONNULL_END
