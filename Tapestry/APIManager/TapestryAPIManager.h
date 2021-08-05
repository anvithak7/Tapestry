//
//  TapestryAPIManager.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/21/21.
//

#import <Foundation/Foundation.h>
#import "Group.h"
#import "Story.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface TapestryAPIManager : NSObject

- (void) fetchGroup:(Group *)group :(void(^)(PFObject *group, NSError *error))completion;
- (void) fetchUser:(PFUser *)user :(void(^)(PFUser *user, NSError *error))completion;
- (void)joinGroupWithInviteCode:(NSString*)code forUser:(PFUser*)user :(void(^)(BOOL succeeded, NSError *error))completion;
- (void) postStoryToTapestries:(NSArray*)groups :(void(^)(NSMutableArray *groups, NSError *error))completion;
- (void) updateImageFor:(PFObject*)object withKey:(NSString*)key withImageFile:(PFFileObject*)file :(void(^)(BOOL succeeded, NSError *error))completion;
- (void) updateObject:(PFObject*)object withProperties:(NSMutableDictionary*)featuresToAdd :(void(^)(BOOL succeeded, NSError *error))completion;
- (void)fetchStoriesForGroup:(Group*)group fromStart:(NSDate*)start toEnd:(NSDate*)end :(void(^)(NSMutableArray *stories, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
