//
//  AppColorManager.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 8/2/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// This manager generates colors according to the app's theme and creates images with them.

@interface AppColorManager : NSObject

@property (nonatomic, strong) NSMutableArray *colorsArray;

- (UIColor*)getRandomColorForTheme;
- (UIColor*)getDarkerColorFor:(UIColor*)color;
- (UIImage*)imageFromColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
