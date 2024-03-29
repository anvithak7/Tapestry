//
//  Story.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/15/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Story : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *storyID;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *storyText;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSString *backgroundColor;
@property (nonatomic, strong) NSArray *groupsArray;

//+ (void) createStory: ( NSString * _Nullable )story withImage:( UIImage * _Nullable )image withGroups:(NSMutableArray *)groups withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (void) createStory: ( NSString * _Nullable )story withGroups:(NSArray*) groups withProperties:(NSMutableDictionary * _Nullable )dictionary withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
