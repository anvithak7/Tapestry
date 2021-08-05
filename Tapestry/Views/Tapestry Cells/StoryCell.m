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
    self.contentView.backgroundColor = nil;
    self.storyLabel.text = story[@"storyText"];
    [self.storyLabel sizeToFit];
    PFUser *user = story[@"author"];
    [user fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            self.author = (PFUser*) object;
            self.userNameLabel.text = object[@"fullName"];
            if (object[@"avatarImage"]) {
                self.profileImageView.layer.masksToBounds = YES;
                self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
                self.profileImageView.file = object[@"avatarImage"];
                [self.profileImageView loadInBackground];
            }
        }
    }];
    if (story[@"image"]) {
        self.imageHeight.constant = 130;
        self.imageTopToTextTop.constant = 138;
        self.storyImageView.alpha = 1;
        self.storyImageView.file = story[@"image"];
        [self.storyImageView loadInBackground];
    } else {
        self.imageHeight.constant = 0;
        self.imageTopToTextTop.constant = 8;
        self.storyImageView.alpha = 0;
    }
    if (story[@"backgroundColor"]) {
        self.contentView.backgroundColor = [self colorWithHexString:story[@"backgroundColor"]];
    } else {
        self.contentView.backgroundColor = [UIColor systemGray6Color];
    }
    NSDate *createdDate = story.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMMM d, yyyy  h:mm a";
    self.storyDateLabel.text = [formatter stringFromDate:createdDate];
}

- (UIColor *) colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    // #RGB
    alpha = 1.0f;
    red   = [self colorComponentFrom: colorString start: 0 length: 2];
    green = [self colorComponentFrom: colorString start: 2 length: 2];
    blue  = [self colorComponentFrom: colorString start: 4 length: 2];
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}


- (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@end
