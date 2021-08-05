//
//  HealthKitManager.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 8/4/21.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HealthDataDelegate

- (void)displayHealthDataFromString:(NSString*)update;

@end

@interface HealthKitManager : NSObject

@property (weak, nonatomic) id<HealthDataDelegate> delegate;
@property (nonatomic, strong) UIAlertController *healthController;
@property (strong, nonatomic) HKHealthStore *healthStore;
@property (strong, nonatomic) NSString* fitnessUpdate;

- (UIAlertController*)addHealthOptionsControllerTo:(UIViewController*)viewController;

@end

NS_ASSUME_NONNULL_END
