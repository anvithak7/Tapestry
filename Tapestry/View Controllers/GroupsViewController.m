//
//  GroupsViewController.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/19/21.
//

#import "GroupsViewController.h"
#import "TapestryGridCell.h"
#import "Group.h"

@interface GroupsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *userTapestries;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation GroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //self.searchBar.delegate = self;
    // We're setting the sizes of the items.
    // The width of the collectionView will change according to the size of the phone.
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 3;
    CGFloat groupsPerRow = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (groupsPerRow - 1)) / groupsPerRow;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    [self getTapestries];
    // TODO: do we need refresh control here? Since groups get added elsewhere anyways. Might be more useful in the newsletter view?
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getTapestries) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:self.refreshControl atIndex:0]; // addSubview allows you to nest views. insertSubview layers at whatever index.
}

- (void) getTapestries {
    PFUser *user = [PFUser currentUser];
    [user fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            self.userTapestries = object[@"groups"];
            NSLog(@"Within completion: %@", self.userTapestries);
            [self.collectionView reloadData];
            [self.refreshControl endRefreshing];
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TapestryGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TapestryGridCell" forIndexPath:indexPath];
    Group *group = self.userTapestries[indexPath.item];
    cell.tapestryImageView.image = nil; // Clear out the previous one before presenting the new one.
    NSLog(@"Cell name: %@", group[@"groupName"]);
    cell.tapestryNameLabel.text = group[@"groupName"];
    if (group[@"groupImage"]) {
        cell.tapestryImageView.file = group[@"groupImage"];
        [cell.tapestryImageView loadInBackground];
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userTapestries.count;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    /*UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    //Group *group = self.filteredData[indexPath.row];
    //DetailsViewController *detailViewController = [segue destinationViewController];
    //detailViewController.movie = movie; // Passing over movie to next view controller.
    //NSLog(@"Tapping on a movie!"); */
}


@end
