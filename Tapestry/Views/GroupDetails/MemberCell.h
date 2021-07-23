//
//  MemberCell.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/22/21.
//

#import <UIKit/UIKit.h>
#import "TapestryAPIManager.h"
#import "Group.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface MemberCell : UITableViewCell
@property (strong, nonatomic) TapestryAPIManager *APIManager;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) Group *group;
@property (weak, nonatomic) IBOutlet PFImageView *memberProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *memberName;
@property (weak, nonatomic) IBOutlet UILabel *adminLabel;

@end

NS_ASSUME_NONNULL_END
