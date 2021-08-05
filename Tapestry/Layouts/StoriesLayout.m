//
//  StoriesLayout.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/21/21.
//

#import "StoriesLayout.h"

@implementation StoriesLayout


- (void)prepareLayout {
    self.numberOfColumns = 2;
    self.cellPadding = 2;
    self.extraHeightInCell = 63;
    self.cache = [NSMutableArray new];
    NSMutableArray *xOffsets = [NSMutableArray new];
    NSMutableArray *yOffsets = [NSMutableArray new];
    self.contentHeight = 0;
    self.contentWidth = self.collectionView.frame.size.width - (self.collectionView.contentInset.left + self.collectionView.contentInset.right);
    /*if ([self.cache count] != 0) {
        return;
    } */
    self.columnWidth = self.contentWidth / self.numberOfColumns;
    for (int i = 0; i < (int) roundf(self.numberOfColumns); i++) {
        [xOffsets addObject: [NSNumber numberWithFloat:(CGFloat) i * self.columnWidth]];
        [yOffsets addObject:[NSNumber numberWithFloat:self.collectionView.contentInset.top]];
    }
    //For header that didn't work:[self.cache addObject:[self layoutAttributesForSupplementaryViewOfKind:@"TapestryHeaderforDates" atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]];
    int column = 0;
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        self.textHeight = [self.delegate heightForText:self.collectionView atIndexPath:indexPath] + self.extraHeightInCell;
        CGFloat cellHeight = self.textHeight + 2 * self.cellPadding;
        CGRect itemFrame = CGRectMake([xOffsets[column] floatValue], [yOffsets[column] floatValue], self.columnWidth, cellHeight);
        CGRect insetFrame = CGRectInset(itemFrame, self.cellPadding, self.cellPadding);
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attribute.frame = insetFrame;
        [self.cache addObject:attribute];
        self.contentHeight = MAX(self.contentHeight, CGRectGetMaxY(itemFrame));
        yOffsets[column] = [NSNumber numberWithFloat:[[yOffsets objectAtIndex:column] floatValue] + cellHeight];
        if (column < (self.numberOfColumns - 1)) {
            column ++;
        } else {
            column = 0;
        }
    }
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.contentWidth, self.contentHeight);
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *attribute in self.cache) {
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            [attributes addObject:attribute];
        }
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.cache[indexPath.item];
}

/* For header that didn't work:
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"TapestryHeaderforDates" withIndexPath:indexPath];
    attribute.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, 50);
    return attribute;
} */

/*
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    
} */

@end
