//
//  TapestryViewController.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/20/21.
//

#import "TapestryViewController.h"
#import "GroupDetailsViewController.h"
#import "TapestriesHeaderReusableView.h"
#import "StoriesLayout.h"
#import "StoryCell.h"

@interface TapestryViewController () <UICollectionViewDelegate, UICollectionViewDataSource, StoriesLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *groupNameTitle;
@property (nonatomic, strong) StoriesLayout *layout;

@end

@implementation TapestryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.APIManager = [TapestryAPIManager new];
    [self.startDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [self.endDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    self.startDatePicker.date = [calendar startOfDayForDate:[NSDate date]];
    self.endDatePicker.maximumDate = [NSDate date];
    self.endDatePicker.minimumDate = self.startDatePicker.date;
    self.startDatePicker.maximumDate = self.endDatePicker.date;
    self.groupNameTitle.text = self.group.groupName;
    self.layout = [StoriesLayout new];
    self.collectionView.collectionViewLayout = self.layout;
    self.layout.delegate = self;
    self.stringsToGetSizeFrom = [NSMutableArray new];
    self.extraMediaExists = [NSMutableArray new];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getStories) forControlEvents:UIControlEventValueChanged];
    self.collectionView.refreshControl = self.refreshControl;
}

- (void)viewWillAppear:(BOOL)animated {
    [self getStories];
}

- (void) getStories {
    PFQuery *query = [PFQuery queryWithClassName:@"Story"];
    [query whereKey:@"groupsArray" containsAllObjectsInArray:@[self.group]];
    [query whereKey:@"createdAt" greaterThanOrEqualTo:self.startDatePicker.date];
    [query whereKey:@"createdAt" lessThanOrEqualTo:self.endDatePicker.date];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            for (Story *story in objects) {
                [story fetchIfNeededInBackground];
            }
            self.storiesToShow = [objects copy];
            for (Story *story in objects) {
                NSString *textString = [story objectForKey:@"storyText"];
                [self.stringsToGetSizeFrom addObject:textString];
                if (story[@"image"]) {
                    [self.extraMediaExists addObject:@"Yes"];
                } else {
                    [self.extraMediaExists addObject:@""];
                }
            }
            [self.collectionView reloadData];
            [self.refreshControl endRefreshing];
        }
    }];
}

- (void)dateChanged:(id)sender {
    self.endDatePicker.minimumDate = self.startDatePicker.date;
    self.startDatePicker.maximumDate = self.endDatePicker.date;
    [self getStories];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1; //TODO: change this later!!!
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    StoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoryCell" forIndexPath:indexPath];
    Story *story = self.storiesToShow[indexPath.item];
    cell.story = story;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.storiesToShow.count;
}

- (CGFloat)heightForText:(nonnull UICollectionView *)collectionView atIndexPath:(nonnull NSIndexPath *)indexPath {
    UILabel *stringLabel = [UILabel new];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0 weight:UIFontWeightLight]};
    stringLabel.frame = CGRectMake(20,20,self.layout.columnWidth,[self.stringsToGetSizeFrom[indexPath.item] sizeWithAttributes:attributes].height);
    [stringLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightLight]];
    stringLabel.numberOfLines = 0;
    stringLabel.text = self.stringsToGetSizeFrom[indexPath.item];
    [stringLabel sizeToFit];
    if ([self.extraMediaExists[indexPath.item] isEqual:@"Yes"]) {
        return stringLabel.frame.size.height + 130;
    } else {
        return stringLabel.frame.size.height;
    }
    //return [self.stringsToGetSizeFrom[indexPath.item] sizeWithAttributes:attributes].height;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"groupDetails"]) {
        GroupDetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.group = self.group; // Passing over group to next view controller.
    }
}


@end
