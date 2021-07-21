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
    //self.userNameLabel
    if (story[@"image"]) {
        self.imageTopToTextTop.constant = 138;
        self.storyImageView.alpha = 1;
        self.storyImageView.file = story[@"image"];
        [self.storyImageView loadInBackground];
    } else {
        self.imageTopToTextTop.constant = 0;
        self.storyImageView.alpha = 0;
    }
}

@end
