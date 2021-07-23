//
//  TapestryHeaderforDates.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/21/21.
//

#import "TapestryHeaderforDates.h"

@implementation TapestryHeaderforDates

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleLabel = [UILabel new];
        self.titleLabel.text = @"Testing: If You See This It Worked";
        [self.titleLabel sizeToFit];
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}
@end
