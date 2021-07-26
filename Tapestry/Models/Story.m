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
@dynamic backgroundColor;
@dynamic groupsArray;

+ (nonnull NSString *)parseClassName {
    return @"Story";
}

+ (void) createStory:(NSString *)story withGroups:(NSArray *)groups withProperties:(NSMutableDictionary * _Nullable )dictionary withCompletion:(PFBooleanResultBlock)completion {
    Story *newStory = [Story new];
    newStory.storyText = story;
    newStory.author = [PFUser currentUser];
    id image = [dictionary objectForKey:@"Image"];
    if (image) {
        newStory.image = [self getPFFileFromImage:image];
    }
    id backgroundColor = [dictionary objectForKey:@"Background Color"];
    if (backgroundColor) {
        newStory.backgroundColor = [self hexStringFromColor:backgroundColor];
    }
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

+ (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

@end
