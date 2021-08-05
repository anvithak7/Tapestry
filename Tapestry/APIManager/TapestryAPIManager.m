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

- (void)fetchGroup:(Group *)group :(void(^)(PFObject *group, NSError *error))completion {
    [group fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            completion(nil, error);
        } else {
            completion(object, nil);
        }
    }];
}

- (void)fetchUser:(PFUser *)user :(void(^)(PFUser *user, NSError *error))completion {
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

- (void)joinGroupWithInviteCode:(NSString*)code forUser:(PFUser*)user :(void(^)(BOOL succeeded, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query whereKey:@"groupInviteCode" equalTo:code];
    [query findObjectsInBackgroundWithBlock:^(NSArray *group, NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            completion(nil, error);
        } else {
            Group *groupToJoin = group[0];
            [groupToJoin fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Error: %@", error.localizedDescription);
                    completion(nil, error);
                } else {
                    [groupToJoin addUniqueObject:user forKey:@"membersArray"];
                    [user addObject:groupToJoin forKey:@"groups"];
                    [PFObject saveAllInBackground:@[groupToJoin, user] block:^(BOOL succeeded, NSError * _Nullable error) {
                        if (succeeded) {
                            completion(succeeded, nil);
                        } else {
                            NSLog(@"Error: %@", error.localizedDescription);
                            completion(nil, error);
                        }
                    }];
                }
            }];
        }
    }];
    
    
}


- (void)postStoryToTapestries:(NSArray*)groups :(void(^)(NSMutableArray *groups, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query whereKey:@"objectId" containedIn:groups];
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
            completion(storyGroups, nil);
        }
    }];
}

- (void)updateImageFor:(PFObject*)object withKey:(NSString*)key withImageFile:(PFFileObject*)file :(void(^)(BOOL succeeded, NSError *error))completion {
    object[key] = file;
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        completion(succeeded, error);
    }];
}

- (void)updateObject:(PFObject*)object withProperties:(NSMutableDictionary*)featuresToAdd :(void(^)(BOOL succeeded, NSError *error))completion {
    for (id key in featuresToAdd) {
        id value = [featuresToAdd objectForKey:key];
        object[key] = value;
    }
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        completion(succeeded, error);
    }];
}

- (void)fetchStoriesForGroup:(Group*)group fromStart:(NSDate*)start toEnd:(NSDate*)end :(void(^)(NSMutableArray *stories, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Story"];
    [query whereKey:@"groupsArray" containsAllObjectsInArray:@[group]];
    [query whereKey:@"createdAt" greaterThanOrEqualTo:start];
    [query whereKey:@"createdAt" lessThanOrEqualTo:end];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            completion(nil, error);
        } else {
            NSMutableArray *stories = [NSMutableArray new];
            for (Story *story in objects) {
                [story fetchIfNeededInBackground];
            }
            stories = [objects copy];
            completion(stories, nil);
        }
    }];
}

@end
