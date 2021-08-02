//
//  TapestryGridCell.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/20/21.
//

#import "TapestryGridCell.h"

@implementation TapestryGridCell

- (void)setGroup:(Group *)group {
    self.colorManager = [AppColorManager new];
    self.tapestryImageView.image = nil; // Clear out the previous one before presenting the new one.
    self.tapestryNameLabel.text = group[@"groupName"];
    if (group[@"groupImage"]) {
        self.tapestryImageView.file = group[@"groupImage"];
        [self.tapestryImageView loadInBackground];
    } else {
        /*if (!self.groupColor) {
            self.groupColor = [self.colorManager getRandomColorForTheme];
        } */
        self.groupColor = [self.colorManager getRandomColorForTheme];
        self.tapestryImageView.backgroundColor = self.groupColor;
    }
}

@end
