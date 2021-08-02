//
//  InviteCodeCell.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 8/2/21.
//

#import "InviteCodeCell.h"

@implementation InviteCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.inviteCodeField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)copyTextFieldContent:(id)sender {
    UIPasteboard* pb = [UIPasteboard generalPasteboard];
    pb.string = self.inviteCodeField.text;
}

// From this post: https://stackoverflow.com/a/31485463/16475718
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // UIKit changes the first responder after this method, so we need to show the copy menu after this method returns.
    if (textField == self.inviteCodeField) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self becomeFirstResponder];
             UIMenuController* menuController = [UIMenuController sharedMenuController];
             UIMenuItem* copyItem = [[UIMenuItem alloc] initWithTitle:@"Copy"
                                                               action:@selector(copyTextFieldContent:)];
             menuController.menuItems = @[copyItem];
             CGRect selectionRect = textField.frame;
            [menuController showMenuFromView:textField.rightView rect:selectionRect];
         });
         return NO;
    }
    return YES;
}

@end
