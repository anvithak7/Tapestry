//
//  Group.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/14/21.
//

#import <Parse/Parse.h>
#import "AddImageManager.h"
#import "AppColorManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface Group : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *groupInviteCode;
@property (nonatomic, strong) PFUser *administrator;
@property (nonatomic, strong) PFFileObject *groupImage;
@property (nonatomic, strong) NSMutableArray *membersArray;

+ (NSString*) createGroup:(NSString *) name withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
