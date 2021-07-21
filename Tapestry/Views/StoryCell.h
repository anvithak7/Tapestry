//
//  StoryCell.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/20/21.
//

#import <UIKit/UIKit.h>
#import "Group.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoryCell : UICollectionViewCell
@property (nonatomic, strong) Group *group;
@property (weak, nonatomic) IBOutlet UIImageView *storyImageView;
@property (weak, nonatomic) IBOutlet UILabel *storyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storyDateLabel;


@end

NS_ASSUME_NONNULL_END
