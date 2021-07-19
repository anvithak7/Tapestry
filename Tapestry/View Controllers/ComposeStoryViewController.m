//
//  ComposeStoryViewController.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/13/21.
//

#import "ComposeStoryViewController.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "Story.h"
#import "Group.h"
#import "Parse/Parse.h"

@interface ComposeStoryViewController () <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *storyTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addGroupsButton;
@property (weak, nonatomic) IBOutlet UIImageView *storyImageView;
@property (weak, nonatomic) IBOutlet UILabel *addImageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *sendStoryButton; //TODO: does this need to be an IBOutlet???
@property (nonatomic, strong) NSMutableArray *buttonsCurrentlyOnScreen;
@property (nonatomic, strong) NSMutableArray *groupsCurrentlyOnScreen;
@property (nonatomic, strong) NSMutableArray *groupsToSendUpdate;
@property (nonatomic, strong) NSMutableArray *buttonColorsArray;
@property (nonatomic) int currentXEdge;
@property (nonatomic) int currentYLine;

@end

@implementation ComposeStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // To use text view methods, we set the view controller as a delegate for the text view.
    self.storyTextView.delegate = self;
    // The default text is light gray, because it is meant to go away when a user types in their real text.
    self.storyTextView.textColor = UIColor.lightGrayColor;
    //self.storyTextView.textContainer.heightTracksTextView = true;
    self.groupsToSendUpdate = [NSMutableArray new];
    // I have to somehow query the groups array and add My Stories to the list of groups to send the update to
    self.buttonColorsArray = [NSMutableArray new];
    self.buttonsCurrentlyOnScreen = [NSMutableArray new];
}

- (void) viewDidAppear:(BOOL)animated {
    self.currentXEdge = 8;
    self.currentYLine = self.storyTextView.frame.origin.y + self.storyTextView.frame.size.height + 8;
    self.addImageLabel.alpha = 1;
    self.photoImageView.alpha = 1;
    self.sendStoryButton = nil;
    [self addGroupButtons];
}

- (void)viewDidDisappear:(BOOL)animated {
    for (UIButton *button in self.buttonsCurrentlyOnScreen) {
        [button removeFromSuperview];
    }
    [self.buttonsCurrentlyOnScreen removeAllObjects];
    NSLog(@" Buttons on screen: %@", self.buttonsCurrentlyOnScreen);
    //[(UIButton*)[self.view viewWithTag:TAG_ID]  removeFromSuperview];
}

// The below is for style purposes, so that the textview placeholder text disappears when a user starts typing and turns black, so a user knows it is their actual text.
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView.textColor == UIColor.lightGrayColor) {
        textView.text = @"";
        textView.textColor = UIColor.blackColor;
    }
}

// And when a user finishes editing, we want to make sure they actually wrote something, or else we remind them again to write a caption in gray text. Otherwise, the caption is whatever they said it is.
- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqual:@""]) {
        textView.text = @"How's it going?";
        textView.textColor = UIColor.lightGrayColor;
    }
}

- (IBAction)onTapAnywhere:(id)sender {
    [self.storyTextView endEditing:true];
}

- (IBAction)onTapLogout:(id)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
}

- (void) onTapWeave {
    [Story createStory:self.storyTextView.text withGroups:self.groupsToSendUpdate withImage: self.storyImageView.image withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            [self createAlert:@"Unable to share story. Please check your internet connection and try again!" error:@"Unable to Share"];
        } else {
            NSLog(@"Story shared");
            self.storyTextView.text = @"How's it going?";
            self.storyTextView.textColor = UIColor.lightGrayColor;
            for (UIButton *button in self.buttonsCurrentlyOnScreen) {
                [button setBackgroundColor:[UIColor lightGrayColor]];
                [button setSelected:false];
            }
            self.storyImageView.image = nil;
            self.addImageLabel.alpha = 1;
            self.photoImageView.alpha = 1;
            [self.storyImageView setTintColor:[UIColor systemGray6Color]];
            [self.storyTextView endEditing:true];
        }
    }];
}

- (void) addGroupButtons {
    PFUser *user = PFUser.currentUser;
    int count = 0;
    // TODO: add an all groups button too
    for (Group *group in user[@"groups"]) {
        if (![self.groupsCurrentlyOnScreen containsObject:group]) { //TODO: this doesn't work - buttons keep getting added anyways.
            [group fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"Error: %@", error.localizedDescription);
                    [self createAlert:@"Please check your internet connection and try again!" error:@"Unable to load groups"];
                } else {
                    if (![object[@"groupName"] isEqual:@"My Stories"]) {
                        UIButton *groupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        groupButton.tag = count;
                        groupButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                        groupButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                        groupButton.titleLabel.font = [UIFont systemFontOfSize:13];
                        [groupButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                        if ([object[@"groupName"] length] > 50) {
                            NSString *thisGroupName = object[@"groupName"];
                            NSString *stringToFindSpaceIn = [thisGroupName substringFromIndex:(NSInteger) 45]; // Change this number based on the longest length of a group name;
                            NSInteger indexToCut = [stringToFindSpaceIn rangeOfString:@" "].location + 45;
                            NSString *buttonTitle = [[thisGroupName substringToIndex:indexToCut] stringByAppendingString:@"\n"];
                            NSString *completeButtonTitle = [buttonTitle stringByAppendingString:[thisGroupName substringFromIndex:indexToCut]];
                            // The above allows a group name to be multi-line.
                            [groupButton setTitle:completeButtonTitle forState:UIControlStateNormal];
                        } else {
                            [groupButton setTitle:object[@"groupName"] forState:UIControlStateNormal];
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
                        [self.view addSubview:groupButton];
                        [self.buttonsCurrentlyOnScreen addObject:groupButton];
                        [self.groupsCurrentlyOnScreen addObject:group];
                    }
                }
            }];
        }
        count ++;
    }
    self.storyImageView.frame = CGRectMake(8.0, self.currentYLine + 46, 50.0, 50.0); // TODO: why am I unable to place this where I want it to go???
    //TODO: can I add some constraints programmatically and others through autolayout??
    if (self.sendStoryButton == nil) {
        UIButton *weaveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.sendStoryButton = weaveButton;
        self.sendStoryButton.frame = CGRectMake((self.view.frame.size.width - 150) / 2, self.currentYLine + 96.0, 150.0, 30.0);
        self.sendStoryButton.titleLabel.font = [UIFont systemFontOfSize:15];
        self.sendStoryButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.sendStoryButton setTitle:@"Weave!" forState:UIControlStateNormal];
        [self.sendStoryButton addTarget:self action:@selector(onTapWeave) forControlEvents:UIControlEventTouchUpInside];
        self.sendStoryButton.layer.cornerRadius = 10;
        self.sendStoryButton.clipsToBounds = YES;
        [self.view addSubview:self.sendStoryButton];
    } else {
        self.sendStoryButton.frame = CGRectMake((self.view.frame.size.width - 150) / 2, self.currentYLine + 96.0, 150.0, 30.0);
    }
}

-(void)buttonClicked:(UIButton*)sender {
    // A way to set the selected vs unselected state of a button
    int tag = (int) sender.tag;
    BOOL firstTap = sender.backgroundColor == [UIColor lightGrayColor];
    if (firstTap) {
        // TODO: how to change all of their colors and make them look nice?
        if (tag == 0) {
            [sender setBackgroundColor:[UIColor redColor]];
        } else if (tag == 1) {
            [sender setBackgroundColor:[UIColor blueColor]];
        } else if (tag == 2) {
            [sender setBackgroundColor:[UIColor greenColor]];
        }
    } else {
        [sender setBackgroundColor:[UIColor lightGrayColor]];
    }
    //Move this to message completion
    // Make dictionary of
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query whereKey:@"groupName" equalTo:sender.titleLabel.text];
    [query whereKey:@"membersArray" containsAllObjectsInArray:@[PFUser.currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error != nil) {
            [self createAlert:@"Please check your internet connection and try again!" error:@"Unable to Add to Tapestry"];
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Objects: %@", objects);
            for (Group *group in objects) {
                NSLog(@"Group: %@", group);
                [group fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"Error: %@", error.localizedDescription);
                    } else {
                        if (firstTap) {
                            if (![self.groupsToSendUpdate containsObject:object]) {
                                [self.groupsToSendUpdate addObject:object];
                                NSLog(@"Added group to story: %@", self.groupsToSendUpdate);
                            }
                        } else if (!firstTap) {
                            if ([self.groupsToSendUpdate containsObject:object]) {
                                [self.groupsToSendUpdate removeObject:object];
                                NSLog(@"Removed group from story: %@", self.groupsToSendUpdate);
                                // TODO: remove or contains don't currently work
                            }
                        }
                }
                }];
            }
        }
    }];
}

- (IBAction)onTapImageView:(id)sender {
    UIAlertController* addPhotoAction = [UIAlertController alertControllerWithTitle:@"Add Photo" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* fromCameraAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self fromCamera];
    }];
    UIAlertAction* fromPhotosAction = [UIAlertAction actionWithTitle:@"From Photos Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self fromLibrary];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];

    [addPhotoAction addAction:fromCameraAction];
    [addPhotoAction addAction:fromPhotosAction];
    [addPhotoAction addAction:cancelAction];
    [self presentViewController:addPhotoAction animated:YES completion:nil];
}

- (void) fromCamera {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
    else {
        [self createAlert:@"Please allow camera access and try again!" error:@"Unable to Acccess Camera"];
    }
}

- (void) fromLibrary {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
    else {
        [self createAlert:@"Please allow photo library access and try again!" error:@"Unable to Acccess Photo Library"];
    }
}

// This function is to set the image in the post to the image picked or taken and to make sure it's been resized.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.addImageLabel.alpha = 0;
    self.photoImageView.alpha = 0;
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    //UIImage *editedImage = info[UIImagePickerControllerEditedImage]; Not sure what this line is for.
    CGSize imageSize = CGSizeMake(self.storyImageView.frame.size.width, self.storyImageView.frame.size.height);
    UIImage *resizedImage = [self resizeImage:originalImage withSize:imageSize];
    // Do something with the images (based on your use case)
    self.storyImageView.image = resizedImage;
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

// This function resizes images in case they are too large so they can be stored in the database.
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// A function to create alerts, instead of writing this out multiple times.
- (void) createAlert: (NSString *)message error:(NSString*)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:error message:message preferredStyle:(UIAlertControllerStyleAlert)];
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    // handle response here.
    }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    // show alert
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
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
