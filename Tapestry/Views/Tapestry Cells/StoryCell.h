//
//  StoryCell.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/20/21.
//

#import <UIKit/UIKit.h>
#import "StoriesLayout.h"
#import "Story.h"
#import "Group.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface StoryCell : UICollectionViewCell
@property (nonatomic, strong) Group *group;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) Story *story;
@property (weak, nonatomic) IBOutlet PFImageView *storyImageView;
@property (weak, nonatomic) IBOutlet UILabel *storyLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storyDateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopToTextTop;
@property (nonatomic, strong) NSLayoutConstraint *maxWidthConstraint;


@end

NS_ASSUME_NONNULL_END
