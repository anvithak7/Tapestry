//
//  GroupButton.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/28/21.
//

#import <UIKit/UIKit.h>
#import "Group.h"
@import Parse;

// An experiment to create my own custom UI components
NS_ASSUME_NONNULL_BEGIN

@interface GroupButton : UIButton

@property (nonatomic, strong) NSString* groupTag;

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
