//
//  ComposeStoryViewController.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/13/21.
//

#import "ComposeStoryViewController.h"

@interface ComposeStoryViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *storyTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendStoryButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addGroupsButton;

@end

@implementation ComposeStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // To use text view methods, we set the view controller as a delegate for the text view.
    self.storyTextView.delegate = self;
    // The default text is light gray, because it is meant to go away when a user types in their real text.
    self.storyTextView.textColor = UIColor.lightGrayColor;
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

- (IBAction)onTapAddGroups:(id)sender {
    
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
