//
//  TapestryAPIManager.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/21/21.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Group.h"
#import "Story.h"

NS_ASSUME_NONNULL_BEGIN

@interface TapestryAPIManager : NSObject

- (void) fetchGroup:(Group *)group :(void(^)(PFObject *group, NSError *error))completion;
- (void) postStoryToTapestries:(NSArray*)groups :(void(^)(NSMutableArray *groups, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
