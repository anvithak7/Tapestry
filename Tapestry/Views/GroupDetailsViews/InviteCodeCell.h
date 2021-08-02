//
//  InviteCodeCell.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 8/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InviteCodeCell : UITableViewCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeField;

@end

NS_ASSUME_NONNULL_END
