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
        self.colorManager = [AppColorManager new];
        UIColor *color = [self.colorManager getRandomColorForTheme];
        [self setBackgroundColor:color forState:UIControlStateNormal];
        self.buttonColor = color;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setButtonProperties:self];
        self.colorManager = [AppColorManager new];
        UIColor *color = [self.colorManager getRandomColorForTheme];
        [self setBackgroundColor:color forState:UIControlStateNormal];
        self.buttonColor = color;
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

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    self.buttonColor = backgroundColor;
    UIImage *image = [self imageFromColor:backgroundColor];
    [self setBackgroundImage:image forState:state];
}

- (void)setBackgroundColorForState:(UIControlState)state {
    UIColor *color = [self.colorManager getRandomColorForTheme];
    self.buttonColor = color;
    UIImage *image = [self imageFromColor:color];
    [self setBackgroundImage:image forState:state];
}

- (UIColor*)getDarkerColor {
    UIColor *color = [self.colorManager getDarkerColorFor:self.buttonColor];
    return color;
}

- (UIImage*)imageFromColor:(UIColor *)color{
    CGRect rect =  CGRectMake(0.0, 0.0, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
