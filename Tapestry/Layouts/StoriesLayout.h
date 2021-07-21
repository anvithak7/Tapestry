//
//  StoriesLayout.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/21/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol StoriesLayoutDelegate

- (CGFloat) heightForText: (UICollectionView*) collectionView atIndexPath:(NSIndexPath*)indexPath;

@end

@interface StoriesLayout : UICollectionViewLayout
@property (weak, nonatomic) id<StoriesLayoutDelegate> delegate;
@property (nonatomic) CGFloat numberOfColumns;
@property (nonatomic) CGFloat cellPadding;
@property (nonatomic) CGFloat contentHeight;
@property (nonatomic) CGFloat contentWidth;
@property (nonatomic) CGFloat columnHeight;
@property (nonatomic) CGFloat columnWidth;
@property (nonatomic) CGFloat textHeight;
@property (nonatomic) CGFloat itemHeight;
@property (nonatomic) CGRect itemFrame;
@property (nonatomic) CGRect insetFrame;
@property (nonatomic) CGSize contentSize;
@property (nonatomic, strong) NSMutableArray *xOffsets;
@property (nonatomic, strong) NSMutableArray *yOffsets;
@property (nonatomic, strong) NSMutableArray *cache;

@end

NS_ASSUME_NONNULL_END
