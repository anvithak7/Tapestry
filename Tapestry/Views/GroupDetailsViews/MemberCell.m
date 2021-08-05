//
//  MemberCell.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/22/21.
//

#import "MemberCell.h"

@implementation MemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.APIManager = [TapestryAPIManager new];
    self.memberProfileImageView.layer.masksToBounds = YES;
    self.memberProfileImageView.layer.cornerRadius = self.memberProfileImageView.frame.size.width / 2;
}

- (void)setUser:(PFUser *)user {
    [self.APIManager fetchUser:user :^(PFUser * _Nonnull user, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            PFUser *cellUser = user;
            self.memberName.text = cellUser[@"fullName"];
            self.memberProfileImageView.file = cellUser[@"avatarImage"];
            [self.memberProfileImageView loadInBackground];
            PFUser *admin = [self.group objectForKey:@"administrator"];
            [self.APIManager fetchUser:admin :^(PFUser * _Nonnull user, NSError * _Nonnull error) {
                if (error == nil) {
                    NSString *adminID = user.objectId;
                    NSString *userID = cellUser.objectId;
                    if ([adminID isEqual:userID]) {
                        self.adminLabel.alpha = 1;
                    } else {
                        self.adminLabel.alpha = 0;
                    }
                }
                else {
                    NSLog(@"Error while fetching admin in background: %@", error.localizedDescription);
                }
            }];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
