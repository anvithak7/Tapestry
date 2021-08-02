//
//  TapestryGridCell.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/20/21.
//

#import <UIKit/UIKit.h>
@import Parse;
#import "Group.h"
#import "AppColorManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TapestryGridCell : UICollectionViewCell
@property (strong, nonatomic) AppColorManager *colorManager;
@property (strong, nonatomic) Group *group;
@property (strong, nonatomic) UIColor *groupColor;
@property (weak, nonatomic) IBOutlet PFImageView *tapestryImageView;
@property (weak, nonatomic) IBOutlet UILabel *tapestryNameLabel;

@end

NS_ASSUME_NONNULL_END
