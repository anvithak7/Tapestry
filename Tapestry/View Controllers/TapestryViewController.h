//
//  TapestryViewController.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/20/21.
//

#import <UIKit/UIKit.h>
#import "TapestryAPIManager.h"
#import "Group.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface TapestryViewController : UIViewController
@property (nonatomic, strong) TapestryAPIManager *APIManager;
@property (nonatomic, strong) Group *group;
@property (nonatomic, strong) NSMutableArray *groupMembers;
@property (nonatomic, strong) NSMutableArray *storiesToShow;
@property (nonatomic, strong) NSMutableArray *stringsToGetSizeFrom;
@property (nonatomic, strong) NSMutableArray *extraMediaExists;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;

@end

NS_ASSUME_NONNULL_END
