//
//  GroupsViewController.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/19/21.
//

#import "GroupsViewController.h"
#import "TapestryViewController.h"
#import "EditProfileViewController.h"
#import "TapestryGridCell.h"
#import "TapestriesHeaderReusableView.h"
#import "Group.h"

@interface GroupsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
// Add <UICollectionViewDragDelegate, UICollectionViewDropDelegate> for drag and drop functionality
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
    //self.collectionView.dragDelegate = self;
    //self.collectionView.dropDelegate = self;
    //self.collectionView.dragInteractionEnabled = true;
    // The above three lines are for drag and drop.
    
    //self.searchBar.delegate = self;
    // We're setting the sizes of the items.
    // The width of the collectionView will change according to the size of the phone.
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
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

- (void)viewDidAppear:(BOOL)animated {
    [self getTapestries];
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
    [group fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(error == nil) {
            cell.group = group;
        }
    }];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userTapestries.count;
}

- (IBAction)onTapProfile:(id)sender {
    [self performSegueWithIdentifier:@"editProfile" sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"openTapestry"]) {
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        Group *group = self.userTapestries[indexPath.row];
        TapestryViewController *tapestryViewController = [segue destinationViewController];
        tapestryViewController.group = group; // Passing over group to next view controller.
    }
    if ([segue.identifier isEqual:@"editProfile"]) {
        EditProfileViewController *editProfileViewController = [segue destinationViewController];
        editProfileViewController.user = PFUser.currentUser;
    }
}



/* The below functions are from my attempt to translate Swift to Objective C
 Here are some of the links I was reading (for future reference):
 https://medium.com/hackernoon/how-to-drag-drop-uicollectionview-cells-by-utilizing-dropdelegate-and-dragdelegate-6e3512327202
 https://hackernoon.com/drag-it-drop-it-in-collection-table-ios-11-6bd28795b313
 https://developer.apple.com/forums/thread/95969
 https://www.techotopia.com/index.php/An_iOS_Collection_View_Drag_and_Drop_Tutorial
 Also looked at: https://github.com/rgipd/uicollectionview-reorder-error/blob/0a0fc1644aec040b40d70219f6555e406df79de2/TestCollectionView/TestCollectionViewController.m
 Not sure if they're doing what I want exactly though but for help in translating to Objective C.
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
    NSIndexPath *sourceIndexPath = coordinator.items.firstObject.sourceIndexPath;
    NSIndexPath *newIndexPath = coordinator.destinationIndexPath;
    
    NSLog(@"performDropWithCoordinator");
    NSLog(@"  from: %@ - %@", @(sourceIndexPath.section), @(sourceIndexPath.row));
    NSLog(@"    to: %@ - %@", @(newIndexPath.section), @(newIndexPath.row));
    NSLog(@" ");
    
    [self moveFrom:sourceIndexPath to:newIndexPath];
}

- (void) moveFrom:(NSIndexPath *)sourceIndexPath to:(NSIndexPath *)destinationIndexPath
{
    //
    // Update the dictArray with the user reorder action
    //
    [self.collectionView performBatchUpdates:^{

        [self.collectionView deleteItemsAtIndexPaths:@[ sourceIndexPath ]];
        [self.collectionView insertItemsAtIndexPaths:@[ destinationIndexPath ]];
        
        NSDictionary *tmpSource = self.userTapestries[sourceIndexPath.item];
        [self.userTapestries removeObjectAtIndex:sourceIndexPath.item];
        [self.userTapestries insertObject:tmpSource atIndex:destinationIndexPath.item];

    } completion:^(BOOL finished) {

        // Do nothing
        
    }];
}
 */


@end
