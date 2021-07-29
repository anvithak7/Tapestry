//
//  GroupButton.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/28/21.
//

#import "GroupButton.h"

@implementation GroupButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setButtonProperties:self];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setButtonProperties:self];
    }
    return self;
}

- (void)setButtonProperties:(GroupButton*)button {
    button.alpha = 1;
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 10;
    button.backgroundColor = [UIColor systemGrayColor];
}


@end
