//
//  ComposeStoryViewController.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/13/21.
//

#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>
#import "TapestryAPIManager.h"
#import "AlertManager.h"
#import "AddImageManager.h"
#import "GroupButtonManager.h"
#import "HealthKitManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComposeStoryViewController : UIViewController
@property (nonatomic, strong) TapestryAPIManager *APIManager;
@property (nonatomic, strong) AlertManager *alertManager;
@property (nonatomic, strong) AddImageManager *imageManager;
@property (nonatomic, strong) GroupButtonManager *buttonsManager;

@property (weak, nonatomic) IBOutlet UITextView *storyTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addGroupsButton;
@property (weak, nonatomic) IBOutlet UIView *groupButtonsView;
@property (weak, nonatomic) IBOutlet UIView *additionalInformationView;

@property (weak, nonatomic) IBOutlet UIView *imageSelectionView;
@property (weak, nonatomic) IBOutlet UIImageView *storyImageView;
@property (weak, nonatomic) IBOutlet UILabel *addImageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addPhotoImage;

@property (weak, nonatomic) IBOutlet UIView *addColorView;
@property (weak, nonatomic) IBOutlet UILabel *addColorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addColorPhoto;

@property (weak, nonatomic) IBOutlet UIView *fromHealthView;
@property (strong, nonatomic) HealthKitManager *healthManager;

@end

NS_ASSUME_NONNULL_END
