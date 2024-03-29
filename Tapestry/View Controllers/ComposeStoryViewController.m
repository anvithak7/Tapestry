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
#import "PromptCell.h"
#import "Parse/Parse.h"
#import <AVFoundation/AVFoundation.h>

// This view controller allows a user to compose a story, with text, and add additional media and attributes.

@interface ComposeStoryViewController () <UITextViewDelegate, UIColorPickerViewControllerDelegate, AddImageDelegate, GroupButtonsDelegate, HealthDataDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
// In the future, add <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) NSMutableDictionary *storyProperties;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *promptsCollection;
@property (strong, nonatomic) NSMutableArray *prompts;
@property (strong, nonatomic) NSArray *todayPrompts;

@end

@implementation ComposeStoryViewController

#pragma mark Loading/Setting Up the View

- (void)viewDidLoad {
    [super viewDidLoad];
    // Create all of the necessary managers and set their delegates (if needed) to self:
    self.APIManager = [TapestryAPIManager new];
    self.alertManager = [AlertManager new];
    self.imageManager = [[AddImageManager alloc] initWithViewController:self];
    self.buttonsManager = [GroupButtonManager alloc];
    self.buttonsManager.delegate = self;
    self.buttonsManager = [self.buttonsManager initWithView:self.groupButtonsView];
    self.healthManager = [[HealthKitManager alloc] init];
    self.healthManager.delegate = self;
    self.promptsCollection.delegate = self;
    self.promptsCollection.dataSource = self;
    [self.promptsCollection setPagingEnabled:TRUE];
    // To use text view methods, we set the view controller as a delegate for the text view.
    self.storyTextView.delegate = self;
    // The default text is light gray, because it is meant to go away and turn black when a user types in their real text.
    self.storyTextView.textColor = UIColor.lightGrayColor;
    //self.storyTextView.textContainer.heightTracksTextView = true;
    self.storyProperties = [NSMutableDictionary new];
    self.prompts = [NSMutableArray new];
    [self addAllPromptsToArray:self.prompts];
    self.todayPrompts = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated {
    [self resetComposeView];
    [self addGroupButtons];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.buttonsManager removeAllButtonsFromSuperview:self.groupButtonsView];
    self.buttonsViewHeightConstraint.constant = 16;
    self.todayPrompts = [NSArray new];
}

- (void)resetComposeView {
    [self getPromptsForToday];
    self.storyImageView.image = nil;
    self.addImageLabel.alpha = 1;
    self.addPhotoImage.alpha = 1;
    self.addColorLabel.alpha = 1;
    self.addColorPhoto.alpha = 1;
    [self.storyProperties removeAllObjects];
    self.addColorView.backgroundColor = [UIColor systemGray6Color];
    [self.storyImageView setTintColor:[UIColor systemGray6Color]];
    [self.storyTextView endEditing:true];
}

- (void)updateUserIfNecessaryForGroup:(Group*)group {
    PFUser *user = [PFUser currentUser];
    [self.APIManager fetchUser:user :^(PFUser * _Nonnull user, NSError * _Nonnull error) {
        if (error == nil) {
            for (PFUser* member in group.membersArray) {
                [member fetchIfNeededInBackground];
                if ([member.objectId isEqual:user.objectId]) {
                    return;
                }
            }
            NSMutableArray *groups = user[@"groups"];
            [groups removeObject:group];
            NSMutableDictionary *properties = [NSMutableDictionary new];
            [properties setObject:groups
                      forKey:@"groups"];
            [self.APIManager updateObject:user withProperties:properties :^(BOOL succeeded, NSError * _Nonnull error) {
                if (succeeded) {
                    NSLog(@"Member removed from tapestry.");
                    [group setObject:@0 forKey:@"groupMembersEdited"];
                    [group saveInBackground];
                    return;
                } else {
                    [self.alertManager createAlert:self withMessage:error.description error:@"Error"];
                }
            }];
        }
    }];
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
        textView.text = @"What would you like to remember from today? Or, answer one of the prompts above!";
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
                    self.storyTextView.text = @"What would you like to remember from today? Or, answer one of the prompts above!";
                    self.storyTextView.textColor = UIColor.lightGrayColor;
                    [self.imageManager resetImageManager];
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
                        if ([[group objectForKey:@"groupMembersEdited"] isEqual:@(1)]) {
                            [self updateUserIfNecessaryForGroup:(Group*)group];
                        }
                        NSString *groupId = group.objectId;
                        if (![groupId isEqual:userStoriesId]) {
                            [self.buttonsManager createButtonforObject:group withTag:count];
                            self.buttonsViewHeightConstraint.constant = [self.buttonsManager resizeParentViewToButtons:self.groupButtonsView];
                        }
                    }
                }];
                count ++;
            }
        }
    }];
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

- (BOOL)needsColorForImages {
    return NO;
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

#pragma mark Health Manager

- (IBAction)onTapFromHealth:(id)sender {
    // Not sure about this below line but it prevents this warning from showing up: "Capturing 'self' strongly in this block is likely to lead to a retain cycle"
    __weak typeof(self) weakSelf = self;
    [self.healthManager addHealthOptionsControllerTo :^(UIAlertController * _Nonnull healthAction, NSError * _Nonnull error) {
            if (error == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf presentViewController:healthAction animated:YES completion:nil];
                });
            } else {
                NSLog(@"Error: %@", error.description);
            }
    }];
}

- (void)displayHealthDataFromString:(NSString *)update {
    self.storyTextView.textColor = UIColor.blackColor;
    if ([self.storyTextView.text isEqualToString:@"What would you like to remember from today? Or, answer one of the prompts above!"]) {
        self.storyTextView.text = update;
    } else {
        NSString *appendedText = [self.storyTextView.text stringByAppendingString:@" "];
        NSString *newText = [appendedText stringByAppendingString:update];
        self.storyTextView.text = newText;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Prompts

- (void)addAllPromptsToArray:(NSMutableArray*)array {
    [array addObjectsFromArray:@[@"A funny story I remember is...", @"Today I made _____ for _____!", @"The most interesting problem I faced today was...", @"The hardest thing about today was...", @"One thing that made me smile today was...", @"Something cute I saw today was...", @"A compliment I received today that I would love to remember...", @"What are some of your hobbies?", @"What song are you currently obsessed with?", @"What book are you currently reading?", @"What's the most recent movie or show you watched?", @"A book you would recommend", @"What is one thing you would like to remember from today?", @"Today I learned how to...", @"The most interesting thing that happened to me today...", @"Someone interesting I met today...", @"Something new I tried today...", @"Today I remembered that...", @"I felt proud today when...", @"I am so grateful for...", @"My favorite food is...", @"I wish I could go to...", @"Something silly I did today...", @"This made my day better today...", @"Today I learned...", @"I hope this will make you laugh...", @"The songs I enjoyed dancing to today...", @"Updates on a new project I started...", @"A yummy meal I had today...", @"A pretty place I saw today...", @"Something that made me happy today...", @"Something that made me think about...", @"Ways I practiced self-care today...", @"The reasons why I think you're awesome...", @"I baked _____ today!", @"I walked _____ steps today!", @"The little things that made me happy today...", @"A good new habit I'm developing..."]];
}

- (void)shuffle:(NSMutableArray*)array {
    for (NSUInteger i = array.count; i > 1; i--)
        [array exchangeObjectAtIndex:i - 1 withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
}

- (void)getPromptsForToday {
    [self shuffle:self.prompts];
    self.todayPrompts = [self.prompts subarrayWithRange:NSMakeRange((NSUInteger) 0, (NSUInteger) 5)];
    [self.promptsCollection reloadData];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PromptCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PromptCell" forIndexPath:indexPath];
    cell.prompt = self.todayPrompts[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.todayPrompts.count;
}


@end
