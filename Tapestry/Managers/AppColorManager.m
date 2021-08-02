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
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

- (UIColor*)getDarkerColorFor:(UIColor*)color {
    CGFloat hue, saturation, brightness, alpha;
    if ([color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        return [UIColor colorWithHue:hue saturation:saturation brightness:brightness * 0.65 alpha:alpha];
    }
    return nil;
}

- (UIImage*)imageFromColor:(UIColor *)color {
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
