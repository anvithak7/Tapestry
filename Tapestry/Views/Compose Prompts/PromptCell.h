//
//  PromptCell.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 8/3/21.
//

#import <UIKit/UIKit.h>
#import "AppColorManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface PromptCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (strong, nonatomic) NSString* prompt;

@end

NS_ASSUME_NONNULL_END
