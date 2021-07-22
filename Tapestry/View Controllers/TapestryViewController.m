//
//  TapestryViewController.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/20/21.
//

#import "TapestryViewController.h"
#import "TapestryHeaderforDates.h"
#import "StoriesLayout.h"
#import "StoryCell.h"

@interface TapestryViewController () <UICollectionViewDelegate, UICollectionViewDataSource, StoriesLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) StoriesLayout *layout;

@end

@implementation TapestryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:TapestryHeaderforDates.self forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TapestryHeaderforDates"];
    self.layout = [StoriesLayout new];
    self.collectionView.collectionViewLayout = self.layout;
    self.layout.delegate = self;
    self.stringsToGetSizeFrom = [NSMutableArray new];
    self.extraMediaExists = [NSMutableArray new];
    [self getStories];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getStories) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:self.refreshControl atIndex:0];
}

- (void) getStories {
    PFQuery *query = [PFQuery queryWithClassName:@"Story"];
    [query whereKey:@"groupsArray" containsAllObjectsInArray:@[self.group]];
    [query orderByDescending:@"createdAt"];
    query.limit = self.group.membersArray.count;
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
            NSLog(@"List of image files %@", self.extraMediaExists);
            [self.collectionView reloadData];
            [self.refreshControl endRefreshing];
        }
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1; //TODO: change this later!!!
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    TapestryHeaderforDates *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TapestryHeaderforDates" forIndexPath:indexPath];
        //NSString *title = [[NSString alloc]initWithFormat:@"Recipe Group #%i", indexPath.section + 1];
        //headerView.title.text = title;
        //UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
        //headerView.backgroundImage.image = headerImage;
    return headerView;
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
    NSLog(@"String to get size of: %@", self.stringsToGetSizeFrom[indexPath.item]);
    if ([self.extraMediaExists[indexPath.item] isEqual:@"Yes"]) {
        return stringLabel.frame.size.height + 130;
    } else {
        return stringLabel.frame.size.height;
    }
    //return [self.stringsToGetSizeFrom[indexPath.item] sizeWithAttributes:attributes].height;
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
