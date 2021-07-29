//
//  ComposeStoryViewController.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/13/21.
//

#import "ComposeStoryViewController.h"
#import "LoginViewController.h"
#import "ImageFromWebViewController.h"
#import "SceneDelegate.h"
#import "Story.h"
#import "Group.h"
#import "Parse/Parse.h"
#import <AVFoundation/AVFoundation.h>

// This view controller allows a user to compose a story, with text, and add additional media and attributes.

@interface ComposeStoryViewController () <UITextViewDelegate, UIColorPickerViewControllerDelegate, AddImageDelegate, GroupButtonsDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) NSMutableArray *buttonColorsArray;
@property (nonatomic, strong) NSMutableDictionary *storyProperties;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewToMediaView;

@end

@implementation ComposeStoryViewController

#pragma mark Loading/Setting Up the View

- (void)viewDidLoad {
    [super viewDidLoad];
    // Create all of the necessary managers and set their delegates (if needed) to self:
    self.APIManager = [TapestryAPIManager new];
    self.alertManager = [AlertManager new];
    self.imageManager = [[AddImageManager alloc] initWithViewController:self];
    self.imageManager.delegate = self;
    self.buttonsManager = [GroupButtonManager alloc];
    self.buttonsManager.delegate = self;
    self.buttonsManager = [self.buttonsManager initWithView:self.groupButtonsView];
    // To use text view methods, we set the view controller as a delegate for the text view.
    self.storyTextView.delegate = self;
    // The default text is light gray, because it is meant to go away and turn black when a user types in their real text.
    self.storyTextView.textColor = UIColor.lightGrayColor;
    //self.storyTextView.textContainer.heightTracksTextView = true;
    self.buttonColorsArray = [NSMutableArray new];
    self.storyProperties = [NSMutableDictionary new];
}

- (void)viewDidAppear:(BOOL)animated {
    [self resetComposeView];
    [self addGroupButtons];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.buttonsManager removeAllButtonsFromSuperview:self.groupButtonsView];
}

- (void)resetComposeView {
    self.storyImageView.image = nil;
    self.addImageLabel.alpha = 1;
    self.addPhotoImage.alpha = 1;
    self.addColorLabel.alpha = 1;
    self.addColorPhoto.alpha = 1;
    self.addColorView.backgroundColor = [UIColor systemGray6Color];
    [self.storyImageView setTintColor:[UIColor systemGray6Color]];
    [self.storyTextView endEditing:true];
}

#pragma mark UITextViewDelegate Methods

// When a user starts typing, the text becomes solid black to replace the placeholder text.
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView.textColor == UIColor.lightGrayColor) {
        textView.text = @"";
        textView.textColor = UIColor.blackColor;
    }
}

// When a user stops typing, we check to make sure they wrote something, or else there should be placeholder text again.
- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqual:@""]) {
        textView.text = @"How's it going?";
        textView.textColor = UIColor.lightGrayColor;
    }
}

// A user can close the keyboard by tapping anywhere on the screen.
- (IBAction)onTapAnywhere:(id)sender {
    [self.storyTextView endEditing:true];
}

#pragma mark Navigation Bar Button Methods

// Upon tapping logout, a user is logged out and returned to the log in view controller.
- (IBAction)onTapLogout:(id)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current will now be nil
    }];
}

# pragma mark Weave!

- (IBAction)onTapWeave:(id)sender {
    [self.APIManager postStoryToTapestries:[self.buttonsManager groupsSelectedInView] :^(NSMutableArray * _Nonnull groups, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            [Story createStory:self.storyTextView.text withGroups:groups withProperties:self.storyProperties withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if (error != nil) {
                    [self.alertManager createAlert:self withMessage:@"Unable to share story. Please check your internet connection and try again!" error:@"Unable to Share"];
                } else {
                    self.storyTextView.text = @"How's it going?";
                    self.storyTextView.textColor = UIColor.lightGrayColor;
                    [self.buttonsManager resetAllButtons];
                    [self resetComposeView];
                }
            }];
        }
    }];
}

#pragma mark User Group Buttons

- (void)addGroupButtons {
    PFUser *user = PFUser.currentUser;
    Group *userStories = [user objectForKey:@"userStories"];
    __block NSString *userStoriesId;
    [self.APIManager fetchGroup:userStories :^(PFObject * _Nonnull group, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            [self.alertManager createAlert:self withMessage:@"Please check your internet connection and try again!" error:@"Unable to load groups"];
        } else {
            userStoriesId = userStories.objectId;
            int count = 0;
            // TODO: add an all groups button too
            for (Group *group in user[@"groups"]) {
                [self.APIManager fetchGroup:group :^(PFObject * _Nonnull group, NSError * _Nonnull error) {
                    if (error) {
                        NSLog(@"Error: %@", error.localizedDescription);
                        [self.alertManager createAlert:self withMessage:@"Please check your internet connection and try again!" error:@"Unable to load groups"];
                    } else {
                        NSString *groupId = group.objectId;
                        if (![groupId isEqual:userStoriesId]) {
                            [self.buttonsManager createButtonforObject:group withTag:count];
                        }
                    }
                }];
                count ++;
            }
        }
    }];
    //self.groupButtonsView.frame = CGRectMake(self.groupButtonsView.frame.origin.x, self.groupButtonsView.frame.origin.y, self.groupButtonsView.frame.size.width, [self.buttonsManager resizeParentViewToButtons:self.groupButtonsView]);
    //self.textViewToMediaView.constant = 16; // 54 includes 30 (button height) + 24 (3 * 8 away)
    //self.storyImageView.frame = CGRectMake(8.0, self.currentYLine + 46, 50.0, 50.0);
    //TODO: redo autolayout constraints in program
    //TODO: can I add some constraints programmatically and others through autolayout?
}

#pragma mark Add Image Methods

- (IBAction)onTapImageView:(id)sender {
    [self presentViewController:[self.imageManager addImageOptionsControllerTo:self] animated:YES completion:nil];
}

- (UIImageView *)sendImageViewToFitInto {
    return self.storyImageView;
}

- (void)setMediaUponPicking:(UIImage *)image {
    self.addImageLabel.alpha = 0;
    self.addPhotoImage.alpha = 0;
    self.storyImageView.image = image;
    self.storyProperties[@"Image"] = image;
}

#pragma mark Add Color Methods

- (IBAction)onTapAddColor:(id)sender {
    UIColorPickerViewController *colorPicker = [UIColorPickerViewController new];
    colorPicker.delegate = self;
    colorPicker.supportsAlpha = true;
    [self presentViewController:colorPicker animated:YES completion:nil];
}

// This method needs to be there but doesn't have to do anything since it is taken care of when the color is selected.
- (void)colorPickerViewControllerDidFinish:(UIColorPickerViewController *)viewController {
    
}

- (void)colorPickerViewControllerDidSelectColor:(UIColorPickerViewController *)viewController {
    self.addColorView.backgroundColor = viewController.selectedColor;
    self.storyProperties[@"Background Color"] = viewController.selectedColor;
    self.addColorLabel.alpha = 0;
    self.addColorPhoto.alpha = 0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
