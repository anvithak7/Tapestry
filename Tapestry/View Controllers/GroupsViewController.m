//
//  GroupsViewController.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/19/21.
//

#import "GroupsViewController.h"
#import "TapestryGridCell.h"
#import "TapestriesHeaderReusableView.h"
#import "Group.h"

@interface GroupsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UICollectionViewDragDelegate, UICollectionViewDropDelegate>
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
    self.collectionView.dragDelegate = self;
    self.collectionView.dropDelegate = self;
    self.collectionView.dragInteractionEnabled = true;
    //[self.collectionView registerClass:<#(nullable Class)#> forCellWithReuseIdentifier:<#(nonnull NSString *)#>]
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
            [self.collectionView reloadData];
            [self.refreshControl endRefreshing];
        }
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1; //TODO: change this later!!!
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        TapestriesHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TapestriesHeader" forIndexPath:indexPath];
        //NSString *title = [[NSString alloc]initWithFormat:@"Recipe Group #%i", indexPath.section + 1];
        //headerView.title.text = title;
        //UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
        //headerView.backgroundImage.image = headerImage;
        reusableview = headerView;
    }
 
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        reusableview = footerview;
    }
        
    return reusableview;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TapestryGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TapestryGridCell" forIndexPath:indexPath];
    Group *group = self.userTapestries[indexPath.item];
    cell.tapestryImageView.image = nil; // Clear out the previous one before presenting the new one.
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


- (nonnull NSArray<UIDragItem *> *)collectionView:(nonnull UICollectionView *)collectionView itemsForBeginningDragSession:(nonnull id<UIDragSession>)session atIndexPath:(nonnull NSIndexPath *)indexPath {
    //TapestryGridCell *cell = self.collectionView.visibleCells[indexPath.row];
    Group *group = self.userTapestries[indexPath.item];
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithItem:group typeIdentifier:@"DragDrop"];
    [itemProvider registerDataRepresentationForTypeIdentifier:@"DragDrop"
                                                   visibility:NSItemProviderRepresentationVisibilityAll loadHandler:^NSProgress * _Nullable(void (^ _Nonnull completionHandler)(NSData * _Nullable, NSError * _Nullable)) {
        return nil;
    }];
     UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    dragItem.localObject = group;
    return @[dragItem];
}

- (UICollectionViewDropProposal *)collectionView:(UICollectionView *)collectionView dropSessionDidUpdate:(id<UIDropSession>)session withDestinationIndexPath:(NSIndexPath *)destinationIndexPath {
    UICollectionViewDropProposal *proposal = [UICollectionViewDropProposal init];
    if ([collectionView hasActiveDrag]) {
        return [proposal initWithDropOperation:UIDropOperationMove intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
    }
    return [proposal initWithDropOperation:UIDropOperationForbidden];
}

- (void)collectionView:(UICollectionView *)collectionView performDropWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator {
    //NSIndexPath *newIndexPath = coordinator.destinationIndexPath;
}

@end
