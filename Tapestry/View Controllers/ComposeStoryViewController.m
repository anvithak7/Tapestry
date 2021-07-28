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

@interface ComposeStoryViewController () <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIColorPickerViewControllerDelegate, ImagesFromWebDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) NSMutableArray *buttonsCurrentlyOnScreen;
@property (nonatomic, strong) NSMutableDictionary *groupsSelected;
@property (nonatomic, strong) NSMutableArray *groupNamesForStory;
@property (nonatomic, strong) NSMutableArray *buttonColorsArray;
@property (nonatomic, strong) NSMutableDictionary *storyProperties;
@property (nonatomic) int currentXEdge;
@property (nonatomic) int currentYLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewToMediaView;

@end

@implementation ComposeStoryViewController

#pragma mark Loading/Setting Up the View

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.APIManager = [TapestryAPIManager new];
    self.alertManager = [AlertManager new];
    self.imageManager = [[AddImageManager alloc] initWithViewController:self];
    // To use text view methods, we set the view controller as a delegate for the text view.
    self.storyTextView.delegate = self;
    // The default text is light gray, because it is meant to go away and turn black when a user types in their real text.
    self.storyTextView.textColor = UIColor.lightGrayColor;
    //self.storyTextView.textContainer.heightTracksTextView = true;
    self.groupNamesForStory = [NSMutableArray new];
    self.buttonColorsArray = [NSMutableArray new];
    self.buttonsCurrentlyOnScreen = [NSMutableArray new];
    self.groupsSelected = [NSMutableDictionary new];
    self.storyProperties = [NSMutableDictionary new];
}

- (void)viewDidAppear:(BOOL)animated {
    self.currentXEdge = 8;
    self.currentYLine = self.storyTextView.frame.origin.y + self.storyTextView.frame.size.height + 8;
    self.addImageLabel.alpha = 1;
    self.addPhotoImage.alpha = 1;
    self.storyImageView.image = nil;
    self.addColorLabel.alpha = 1;
    self.addColorPhoto.alpha = 1;
    self.addColorView.backgroundColor = [UIColor systemGray6Color];
    [self addGroupButtons];
}

- (void)viewDidDisappear:(BOOL)animated {
    for (UIButton *button in self.buttonsCurrentlyOnScreen) {
        [button removeFromSuperview];
    }
    [self.buttonsCurrentlyOnScreen removeAllObjects];
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
    for (id key in self.groupsSelected) {
        id value = [self.groupsSelected objectForKey:key];
        if ([value isEqual:@(1)]) {
            [self.groupNamesForStory addObject:key];
        }
    }
    [self.groupNamesForStory addObject:@"My Stories"];
    [self.APIManager postStoryToTapestries:self.groupNamesForStory :^(NSMutableArray * _Nonnull groups, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            [Story createStory:self.storyTextView.text withGroups:groups withProperties:self.storyProperties withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if (error != nil) {
                    [self.alertManager createAlert:self withMessage:@"Unable to share story. Please check your internet connection and try again!" error:@"Unable to Share"];
                } else {
                    self.storyTextView.text = @"How's it going?";
                    self.storyTextView.textColor = UIColor.lightGrayColor;
                    for (UIButton *button in self.buttonsCurrentlyOnScreen) {
                        [button setBackgroundColor:[UIColor lightGrayColor]];
                        [button setSelected:false];
                    }
                    self.storyImageView.image = nil;
                    self.addImageLabel.alpha = 1;
                    self.addPhotoImage.alpha = 1;
                    self.storyImageView.image = nil;
                    self.addColorLabel.alpha = 1;
                    self.addColorPhoto.alpha = 1;
                    [self.groupNamesForStory removeAllObjects];
                    self.addColorView.backgroundColor = [UIColor systemGray6Color];
                    [self.storyImageView setTintColor:[UIColor systemGray6Color]];
                    [self.storyTextView endEditing:true];
                }
            }];
        }
    }];
}

#pragma mark User Group Buttons

- (void)addGroupButtons {
    PFUser *user = PFUser.currentUser;
    int count = 0;
    // TODO: add an all groups button too
    for (Group *group in user[@"groups"]) {
        [self.APIManager fetchGroup:group :^(PFObject * _Nonnull group, NSError * _Nonnull error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
                [self.alertManager createAlert:self withMessage:@"Please check your internet connection and try again!" error:@"Unable to load groups"];
            } else {
                if (![group[@"groupName"] isEqual:@"My Stories"]) {
                    [self createButtonforObject:group withTag:count];
                }
            }
        }];
        count ++;
    }
    self.textViewToMediaView.constant = self.currentYLine - (self.storyTextView.frame.origin.y + self.storyTextView.frame.size.height + 8) + 54; // 54 includes 30 (button height) + 24 (3 * 8 away)
    //self.storyImageView.frame = CGRectMake(8.0, self.currentYLine + 46, 50.0, 50.0);
    //TODO: redo autolayout constraints in program
    //TODO: can I add some constraints programmatically and others through autolayout?
}

- (void)createButtonforObject:(PFObject*)group withTag:(int)tag {
    UIButton *groupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    groupButton.tag = tag;
    groupButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    groupButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    groupButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [groupButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if ([group[@"groupName"] length] > 50) {
        NSString *thisGroupName = group[@"groupName"];
        NSString *stringToFindSpaceIn = [thisGroupName substringFromIndex:(NSInteger) 45]; // Change this number based on the longest length of a group name;
        NSInteger indexToCut = [stringToFindSpaceIn rangeOfString:@" "].location + 45;
        NSString *buttonTitle = [[thisGroupName substringToIndex:indexToCut] stringByAppendingString:@"\n"];
        NSString *completeButtonTitle = [buttonTitle stringByAppendingString:[thisGroupName substringFromIndex:indexToCut]];
        // The above allows a group name to be multi-line.
        [groupButton setTitle:completeButtonTitle forState:UIControlStateNormal];
    } else {
        [groupButton setTitle:group[@"groupName"] forState:UIControlStateNormal];
    }
    [groupButton sizeToFit];
    if ((self.currentXEdge + groupButton.frame.size.width + 8) > self.view.frame.size.width) {
        self.currentYLine += 38;
        self.currentXEdge = 8;
    }
    groupButton.frame = CGRectMake(self.currentXEdge, self.currentYLine, groupButton.frame.size.width + 6, 30.0);
    self.currentXEdge += groupButton.frame.size.width + 8;
    groupButton.backgroundColor = [UIColor lightGrayColor]; //TODO: CHANGE THIS COLOR
    [groupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    groupButton.layer.cornerRadius = 10;
    groupButton.clipsToBounds = YES;
    self.groupsSelected[group[@"groupName"]] = @0;
    [self.view addSubview:groupButton];
    [self.buttonsCurrentlyOnScreen addObject:groupButton];
}

-(void)buttonClicked:(UIButton*)sender {
    // A way to set the selected vs unselected state of a button
    int tag = (int) sender.tag;
    if (!sender.isSelected) {
        [sender setSelected:TRUE];
        [self.groupsSelected setValue:@1 forKey:sender.titleLabel.text];
        if (tag == 0) {
            [sender setBackgroundColor:[UIColor redColor]];
        } else if (tag == 1) {
            [sender setBackgroundColor:[UIColor blueColor]];
        } else if (tag == 2) {
            [sender setBackgroundColor:[UIColor greenColor]];
        }
        NSLog(@"Dictionary of all groups after selected: %@", self.groupsSelected);
    } else {
        [sender setSelected:FALSE];
        [self.groupsSelected setValue:@0 forKey:sender.titleLabel.text];
        [sender setBackgroundColor:[UIColor lightGrayColor]];
        NSLog(@"Dictionary of all groups after unselected: %@", self.groupsSelected);
    }
}

#pragma mark Add Image Methods

- (IBAction)onTapImageView:(id)sender {
    [self presentViewController:[self.imageManager addImageOptionsControllerTo:self] animated:YES completion:nil];
}

- (void)setImageFromWeb:(UIImage *)image {
    if (image) {
        CGSize imageSize = CGSizeMake(self.storyImageView.frame.size.width, self.storyImageView.frame.size.height);
        UIImage *resizedImage = [self.imageManager resizeImage:image withSize:imageSize];
        self.storyImageView.image = resizedImage;
        self.storyProperties[@"Image"] = resizedImage;
        self.addImageLabel.alpha = 0;
        self.addPhotoImage.alpha = 0;
    }
}

// This function is to set the image in the post to the image picked or taken and to make sure it's been resized.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.addImageLabel.alpha = 0;
    self.addPhotoImage.alpha = 0;
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    //UIImage *editedImage = info[UIImagePickerControllerEditedImage]; Not sure what this line is for.
    CGSize imageSize = CGSizeMake(self.storyImageView.frame.size.width, self.storyImageView.frame.size.height);
    UIImage *resizedImage = [self.imageManager resizeImage:originalImage withSize:imageSize];
    // Do something with the images (based on your use case)
    self.storyImageView.image = resizedImage;
    self.storyProperties[@"Image"] = resizedImage;
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
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
