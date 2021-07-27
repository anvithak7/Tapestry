//
//  ImageFromWebViewController.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/26/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ImagesFromWebDelegate

- (void)setImageFromWeb:(UIImage * _Nullable)image;

@end

@interface ImageFromWebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *imageURLField;
@property (weak, nonatomic) IBOutlet UIImageView *URLImageView;
@property (weak, nonatomic) IBOutlet UIButton *donePickingButton;
@property (weak, nonatomic) id<ImagesFromWebDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
