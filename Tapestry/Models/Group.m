//
//  Group.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/14/21.
//

#import "Group.h"

@implementation Group

@dynamic groupName;
@dynamic groupInviteCode;
@dynamic administrator;
@dynamic groupImage;
@dynamic membersArray;

+ (nonnull NSString *)parseClassName {
    return @"Group";
}

+ (NSString *) createGroup:(NSString *) name withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Group *newGroup = [Group new];
    newGroup.groupName = name;
    NSString *inviteString = [NSUUID UUID].UUIDString;
    newGroup.groupInviteCode = inviteString;
    newGroup.administrator = [PFUser currentUser];
    newGroup.membersArray = [NSMutableArray new];
    [newGroup addObject:[PFUser currentUser] forKey:@"membersArray"];
    [newGroup saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            PFUser *user = PFUser.currentUser;
            [user addObject:newGroup forKey:@"groups"];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                  // The PFUser has been saved.
                    NSLog(@"New group was added to user.");
                } else {
                  // There was a problem, check error.description
                    NSLog(@"Error: %@", error.localizedDescription);
                }
              }];
        } else {
            // Could not save group!
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }]; // Saves the group
    return inviteString;
}

@end
