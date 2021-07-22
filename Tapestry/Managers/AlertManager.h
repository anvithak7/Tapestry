//
//  AlertManager.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/21/21.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlertManager : NSObject

- (void) createAlert:(UIViewController*)viewController withMessage:(NSString *)message error:(NSString*)error;

@end

NS_ASSUME_NONNULL_END
