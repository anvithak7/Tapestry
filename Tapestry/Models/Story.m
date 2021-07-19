//
//  Story.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/15/21.
//

#import "Story.h"

@implementation Story

@dynamic storyID;
@dynamic author;
@dynamic storyText;
@dynamic image;
@dynamic groupsArray;

+ (nonnull NSString *)parseClassName {
    return @"Story";
}

/*
+ (void) createStory:(NSString *)story withImage:(UIImage *)image withGroups:(NSMutableArray *)groups withCompletion:(PFBooleanResultBlock)completion {
    Story *newStory = [Story new];
    newStory.storyText = story;
    newStory.author = [PFUser currentUser];
    newStory.image = [self getPFFileFromImage:image];
    newStory.groupsArray = [NSMutableArray new];
    [newStory saveInBackgroundWithBlock: completion];
} */

+ (void) createStory:(NSString *)story withGroups:(NSArray *)groups withImage:( UIImage * _Nullable )image withCompletion:(PFBooleanResultBlock)completion {
    Story *newStory = [Story new];
    newStory.storyText = story;
    newStory.author = [PFUser currentUser];
    newStory.image = [self getPFFileFromImage:image];
    newStory.groupsArray = groups;
    [newStory saveInBackgroundWithBlock: completion];
}


+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
