//
//  StoryCell.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/20/21.
//

#import "StoryCell.h"
#import "StoriesLayout.h"

@implementation StoryCell

- (void)setStory:(Story *)story {
    self.storyImageView.image = nil; // Clear out the previous one before presenting the new one.
    self.storyLabel.text = story[@"storyText"];
    PFUser *user = story[@"author"];
    [user fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            self.author = (PFUser*) object;
            self.userNameLabel.text = object[@"fullName"];
            if (object[@"avatarImage"]) {
                self.profileImageView.file = object[@"avatarImage"];
                [self.profileImageView loadInBackground];
            }
        }
    }];
    if (story[@"image"]) {
        self.imageTopToTextTop.constant = 138;
        self.storyImageView.alpha = 1;
        self.storyImageView.file = story[@"image"];
        [self.storyImageView loadInBackground];
    } else {
        self.imageTopToTextTop.constant = 8;
        self.storyImageView.alpha = 0;
    }
    NSDate *createdDate = story.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMMM d, yyyy  h:mm a";
    self.storyDateLabel.text = [formatter stringFromDate:createdDate];
}

@end
