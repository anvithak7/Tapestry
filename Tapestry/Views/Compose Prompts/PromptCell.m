//
//  PromptCell.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 8/3/21.
//

#import "PromptCell.h"

@implementation PromptCell

- (void)setPrompt:(NSString *)prompt {
    AppColorManager *colorManager = [AppColorManager new];
    self.promptLabel.text = prompt;
    self.backgroundColor = [colorManager getRandomColorForTheme];
}

@end
