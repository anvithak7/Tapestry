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
}

- (void)setUser:(PFUser *)user {
    [self.APIManager fetchUser:user :^(PFUser * _Nonnull user, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            self.memberName.text = user[@"fullName"];
            self.memberProfileImageView.file = user[@"avatarImage"];
            [self.memberProfileImageView loadInBackground];
            PFUser *admin = [self.group objectForKey:@"administrator"];
            [admin fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                if (error == nil) {
                    NSString *adminID = object.objectId;
                    NSString *userID = user.objectId;
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
