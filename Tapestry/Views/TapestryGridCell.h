//
//  TapestryGridCell.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/20/21.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface TapestryGridCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *tapestryImageView;
@property (weak, nonatomic) IBOutlet UILabel *tapestryNameLabel;

@end

NS_ASSUME_NONNULL_END
