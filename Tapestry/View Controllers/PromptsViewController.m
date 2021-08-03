//
//  PromptsViewController.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 8/3/21.
//

#import "PromptsViewController.h"

@interface PromptsViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) NSMutableArray *prompts;
@property (strong, nonatomic) NSMutableArray *todayPrompts;

@end

@implementation PromptsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.promptsPicker.delegate = self;
    self.promptsPicker.dataSource = self;
    self.prompts = [NSMutableArray new];
    [self.prompts addObjectsFromArray:@[@"A funny story I remember is...", @"Today I made _____ for _____!", @"The most interesting problem I faced today was...", @"The hardest thing about today was...", @"One thing that made me smile today was...", @"Something cute I saw today was...", @"A compliment I got today that I would love to remember...", @"What are some of your hobbies?", @"What song are you currently obsessed with?", @"What book are you currently reading?", @"What's the most recent movie or show you watched?", @"A book you would recommend", @"What is one thing you would like to remember from today?"]];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.prompts.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.prompts[row];
}

@end
