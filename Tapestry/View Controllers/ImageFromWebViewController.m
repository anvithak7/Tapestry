//
//  ImageFromWebViewController.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/26/21.
//

#import "ImageFromWebViewController.h"

@interface ImageFromWebViewController ()

@end

@implementation ImageFromWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onTapAnywhere:(id)sender {
    [self.imageURLField endEditing:true];
}

- (IBAction)imageURLEditingEnded:(id)sender {
    NSURL *url = [NSURL URLWithString:self.imageURLField.text];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    self.URLImageView.image = image;
}

- (IBAction)donePickingImage:(id)sender {
    [self.delegate setImageFromWeb:self.URLImageView.image];
    self.imageURLField.text = @"";
    self.imageURLField.placeholder = @"Image URL";
    self.URLImageView.image = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
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
