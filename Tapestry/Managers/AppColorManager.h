//
//  AppColorManager.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 8/2/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppColorManager : NSObject

@property (nonatomic, strong) NSMutableArray *colorsArray;

- (UIColor*)getRandomColorForTheme;
- (UIColor*)getDarkerColorFor:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
