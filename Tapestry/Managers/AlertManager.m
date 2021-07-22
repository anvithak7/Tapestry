//
//  AlertManager.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/21/21.
//

#import "AlertManager.h"

@implementation AlertManager

// A function to create alerts, instead of writing this out multiple times.
- (void) createAlert:(UIViewController*)viewController withMessage:(NSString *)message error:(NSString*)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:error message:message preferredStyle:(UIAlertControllerStyleAlert)];
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    // handle response here.
    }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    // show alert
    [viewController presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

@end
