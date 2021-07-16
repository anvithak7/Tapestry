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

@interface ComposeStoryViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *storyTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addGroupsButton;
@property (weak, nonatomic) IBOutlet UIButton *sendStoryButton;
@property (nonatomic, strong) NSMutableArray *buttonsCurrentlyOnScreen;
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
    self.groupsToSendUpdate = [NSMutableArray new];
    self.buttonColorsArray = [NSMutableArray new];
    self.buttonsCurrentlyOnScreen = [NSMutableArray new];
    self.currentXEdge = 8;
    self.currentYLine = self.storyTextView.frame.origin.y + self.storyTextView.frame.size.height + 8;
}

- (void) viewDidAppear:(BOOL)animated {
    [self addGroupButtons];
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
    [Story createStory:self.storyTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            [self createAlert:@"Unable to share story. Please check your internet connection and try again!" error:@"Unable to Share"];
        } else {
            NSLog(@"Story shared");
        }
    }];
}

- (void) addGroupButtons {
    PFUser *user = PFUser.currentUser;
    int count = 0;
    // TODO: add an all groups button too
    for (Group *group in user[@"groups"]) {
        if (![self.buttonsCurrentlyOnScreen containsObject:group]) {
            [group fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"Error: %@", error.localizedDescription);
                    [self createAlert:@"Please check your internet connection and try again!" error:@"Unable to load groups"];
                } else {
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
                    groupButton.backgroundColor = [UIColor systemGray6Color]; //TODO: CHANGE THIS COLOR
                    [groupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    groupButton.layer.cornerRadius = 10;
                    groupButton.clipsToBounds = YES;
                    [self.view addSubview:groupButton];
                    [self.buttonsCurrentlyOnScreen addObject:group];
                }
            }];
        }
        count ++;
    }
    UIButton *weaveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.sendStoryButton = weaveButton;
    self.sendStoryButton.frame = CGRectMake((self.view.frame.size.width - 150) / 2, self.currentYLine + 46, 150.0, 30.0);
    self.sendStoryButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.sendStoryButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.sendStoryButton setTitle:@"Weave!" forState:UIControlStateNormal];
    [self.sendStoryButton addTarget:self action:@selector(onTapWeave) forControlEvents:UIControlEventTouchUpInside];
    self.sendStoryButton.layer.cornerRadius = 10;
    self.sendStoryButton.clipsToBounds = YES;
    [self.view addSubview:self.sendStoryButton];
}

-(void)buttonClicked:(UIButton*)sender {
    int tag = (int) sender.tag;
    if (sender.backgroundColor != [UIColor systemGray6Color]) {
        [sender setBackgroundColor:[UIColor systemGray6Color]];
        // I still have to remove this group from the list of groups
    } else {
        if (tag == 0) {
            [sender setBackgroundColor:[UIColor redColor]];
        } else if (tag == 1) {
            [sender setBackgroundColor:[UIColor blueColor]];
        } else if (tag == 2) {
            [sender setBackgroundColor:[UIColor greenColor]];
        }
        PFQuery *query = [PFQuery queryWithClassName:@"Group"];
        [query whereKey:@"groupName" equalTo:sender.titleLabel.text];
        [query whereKey:@"membersArray" containsAllObjectsInArray:@[PFUser.currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (error != nil) {
                [self createAlert:@"Please check your internet connection and try again!" error:@"Unable to Add to Tapestry"];
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                // Need to figure out how to keep track of the groups I want to send the update to!
                /*NSArray *newObjects = [self.groupsToSendUpdate copy];
                [newObjects arrayByAddingObjectsFromArray:objects];
                self.groupsToSendUpdate = [[NSSet setWithArray:duplicateArray] allObjects]; */
                NSLog(@"%@", self.groupsToSendUpdate);
            }
        }];
    }
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
