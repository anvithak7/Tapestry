//
//  TapestryViewController.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/20/21.
//

#import <UIKit/UIKit.h>
#import "Group.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface TapestryViewController : UIViewController
@property (nonatomic, strong) Group *group;

@end

NS_ASSUME_NONNULL_END
