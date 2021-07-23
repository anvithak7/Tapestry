//
//  TapestryAPIManager.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/21/21.
//

#import "TapestryAPIManager.h"

@implementation TapestryAPIManager

- (id)init {
    self = [super init];
    return self;
}

- (void) fetchGroup:(Group *)group :(void(^)(PFObject *group, NSError *error))completion {
    [group fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            completion(nil, error);
        } else {
            completion(object, nil);
        }
    }];
}

- (void) fetchUser:(PFUser *)user :(void(^)(PFUser *user, NSError *error))completion {
    [user fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            completion(nil, error);
        } else {
            PFUser *user = (PFUser*) object;
            completion(user, nil);
        }
    }];
}

- (void)postStoryToTapestries:(NSArray*)groups :(void(^)(NSMutableArray *groups, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query whereKey:@"groupName" containedIn:groups];
    [query whereKey:@"membersArray" containsAllObjectsInArray:@[PFUser.currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSMutableArray *storyGroups = [NSMutableArray new];
            for (Group *group in objects) {
                [group fetchIfNeededInBackground];
            }
            storyGroups = [objects copy];
            NSLog(@"Groups array I am sending out %@", storyGroups);
            completion(storyGroups, nil);
        }
    }];
}

@end
