//
//  AppColorManager.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 8/2/21.
//

#import "AppColorManager.h"

@implementation AppColorManager

- (UIColor*)getRandomColorForTheme {
    // lowerBound + ((float)arc4random() / UINT32_MAX) * (upperBound - lowerBound);
    CGFloat hue = ((float)arc4random() / UINT32_MAX);
    CGFloat saturation = 0.1 + ((float)arc4random() / UINT32_MAX) * (0.7 - 0.1);
    CGFloat brightness = 0.68 + ((float)arc4random() / UINT32_MAX) * (1.0 - 0.68);
    /*
    CGFloat hue = (arc4random() % 256 / 256.0);
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.09;
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.65; */
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

- (UIColor*)getDarkerColorFor:(UIColor*)color {
    CGFloat hue, saturation, brightness, alpha;
    if ([color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        return [UIColor colorWithHue:hue
                              saturation:saturation
                              brightness:brightness * 0.65
                                   alpha:alpha];
    }
    return nil;
}

@end
