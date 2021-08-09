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

@property (strong, nonatomic) HKHealthStore *healthStore;
@property (strong, nonatomic) NSString* fitnessUpdate;
@property (nonatomic, strong) UIAlertController *healthController;

- (void)addHealthOptionsControllerTo :(void(^)(UIAlertController *healthAction, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
