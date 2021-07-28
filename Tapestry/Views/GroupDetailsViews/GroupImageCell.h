//
//  GroupImageCell.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/27/21.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN
@class GroupImageCell;

@protocol GroupImageCellDelegate

- (void) setGroupImage:(GroupImageCell*) groupImageCell;

@end

@interface GroupImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *groupImageView;

@end

NS_ASSUME_NONNULL_END
