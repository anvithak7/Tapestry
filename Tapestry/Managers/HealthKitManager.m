//
//  HealthKitManager.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 8/4/21.
//

#import "HealthKitManager.h"

@implementation HealthKitManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.healthStore = [HKHealthStore new];
    }
    return self;
}

#pragma mark Create Health Data Options Controller

- (UIAlertController*)addHealthOptionsControllerTo:(UIViewController*)viewController {
    if (HKHealthStore.isHealthDataAvailable) {
        [self requestAuthorizationForWheelchairInformation];
        // Add a completion block to the above and then return self.healthController in that
        return self.healthController;
    }
    return nil;
}

- (void)createHealthController {
    BOOL wheelchairUse = [self.healthStore wheelchairUseWithError:nil].wheelchairUse == HKWheelchairUseYes;
    [self requestAuthorizationFor:wheelchairUse];
    // Put the below inside the completion above 
    UIAlertController* addHealthAction = [UIAlertController alertControllerWithTitle:@"Add Health Data" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    if (wheelchairUse) {
        UIAlertAction* pushCountAction = [UIAlertAction actionWithTitle:@"Add Daily Push Count" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            HKQuantityType *type = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierPushCount];
            [self getHealthDataForTodayOfType:type];
        }];
        UIAlertAction* wheelchairDistanceTraveledAction = [UIAlertAction actionWithTitle:@"Add Today's Distance Traveled" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            HKQuantityType *type = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWheelchair];
            [self getHealthDataForTodayOfType:type];
        }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        }];
        [addHealthAction addAction:pushCountAction];
        [addHealthAction addAction:wheelchairDistanceTraveledAction];
        [addHealthAction addAction:cancelAction];
    } else {
        UIAlertAction* stepCountAction = [UIAlertAction actionWithTitle:@"Add Daily Step Count" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            HKQuantityType *type = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
            [self getHealthDataForTodayOfType:type];
        }];
        UIAlertAction* flightsClimbedAction = [UIAlertAction actionWithTitle:@"Add Today's Flights Climbed" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            HKQuantityType *type = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
            [self getHealthDataForTodayOfType:type];
        }];
        UIAlertAction* distanceTraveledAction = [UIAlertAction actionWithTitle:@"Add Today's Distance Traveled" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            HKQuantityType *type = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
            [self getHealthDataForTodayOfType:type];
        }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        }];
        [addHealthAction addAction:stepCountAction];
        [addHealthAction addAction:flightsClimbedAction];
        [addHealthAction addAction:distanceTraveledAction];
        [addHealthAction addAction:cancelAction];
    }
    self.healthController = addHealthAction;
}

- (void)requestAuthorizationForWheelchairInformation {
    HKCharacteristicType *wheelchairUse = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierWheelchairUse];
    NSSet *types = [NSSet setWithObject:wheelchairUse];
    [self.healthStore requestAuthorizationToShareTypes:nil readTypes:types completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self createHealthController];
            });
            return;
        } else {
            NSLog(@"Error: %@", error.description);
            ;
        }
    }];
}

- (void)requestAuthorizationFor:(BOOL)wheelchairUse {
        NSSet *types;
        if (wheelchairUse) {
            HKQuantityType *pushCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierPushCount];
            HKQuantityType *distanceTraveledWheelchair = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWheelchair];
            types = [NSSet setWithArray:@[pushCount, distanceTraveledWheelchair]];
        } else {
            HKQuantityType *stepCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
            HKQuantityType *flightsClimbed = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
            HKQuantityType *distanceTraveled = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
            types = [NSSet setWithArray:@[stepCount, flightsClimbed, distanceTraveled]];
        }
        [self.healthStore requestAuthorizationToShareTypes:types readTypes:types completion:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                return;
            } else {
                NSLog(@"Error: %@", error.description);
            }
        }];
}

- (void)getHealthDataForTodayOfType:(HKQuantityType*)type {
    NSDate *today = [NSDate date];
    NSDate *startOfDay = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] startOfDayForDate:today];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startOfDay endDate:today options:HKQueryOptionStrictStartDate];
    NSDateComponents *interval = [[NSDateComponents alloc] init];
    interval.day = 1;
    HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:type quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum anchorDate:startOfDay intervalComponents:interval];
    query.initialResultsHandler = ^(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable result, NSError * _Nullable error) {
      if (error != nil) {
          NSLog(@"Error :%@", error.description);
      } else {
        [result enumerateStatisticsFromDate:startOfDay toDate:today withBlock:^(HKStatistics * _Nonnull result, BOOL * _Nonnull stop) {
            HKQuantity *quantity = [result sumQuantity];
            if ([type.identifier isEqual:HKQuantityTypeIdentifierStepCount]) {
                double count = [quantity doubleValueForUnit:[HKUnit countUnit]];
                self.fitnessUpdate = [NSString stringWithFormat:@"Today I walked %.02f steps!", count];
            } else if ([type.identifier isEqual:HKQuantityTypeIdentifierFlightsClimbed]) {
                double count = [quantity doubleValueForUnit:[HKUnit countUnit]];
                self.fitnessUpdate = [NSString stringWithFormat:@"Today I climbed %.02f flights of stairs!", count];
            } else if ([type.identifier isEqual:HKQuantityTypeIdentifierDistanceWalkingRunning]) {
                double count = [quantity doubleValueForUnit:[HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitMile]];
                self.fitnessUpdate = [NSString stringWithFormat:@"Today I walked and ran %f miles!", count]; //TODO: change distance metrics based on place?
            } else if ([type.identifier isEqual:HKQuantityTypeIdentifierPushCount]) {
                double count = [quantity doubleValueForUnit:[HKUnit countUnit]];
                self.fitnessUpdate = [NSString stringWithFormat:@"Today I pushed my wheelchair %.02f times!", count];
            } else if ([type.identifier isEqual:HKQuantityTypeIdentifierDistanceWheelchair]) {
                double count = [quantity doubleValueForUnit:[HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitMile]];
                self.fitnessUpdate = [NSString stringWithFormat:@"Today I pushed myself %f miles!", count];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate displayHealthDataFromString:self.fitnessUpdate];
            });
        }];
      }
    };
    [self.healthStore executeQuery:query];
}

@end
