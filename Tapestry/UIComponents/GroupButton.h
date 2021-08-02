//
//  GroupButton.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/28/21.
//

#import <UIKit/UIKit.h>
#import "Group.h"
@import Parse;
#import "AppColorManager.h"

// An experiment to create my own custom UI components
NS_ASSUME_NONNULL_BEGIN

@interface GroupButton : UIButton

@property (nonatomic, strong) AppColorManager *colorManager;
@property (nonatomic, strong) NSString* groupTag;
@property (nonatomic, strong) UIColor* buttonColor;

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
- (void)setBackgroundColorForState:(UIControlState)state;
- (UIColor*)getDarkerColor;

@end

NS_ASSUME_NONNULL_END
