//
//  StoriesLayout.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/21/21.
//

#import "StoriesLayout.h"

@implementation StoriesLayout


- (void) prepareLayout {
    self.numberOfColumns = 2;
    self.cellPadding = 2;
    self.cache = [NSMutableArray new];
    self.xOffsets = [NSMutableArray new];
    self.yOffsets = [NSMutableArray new];
    self.contentHeight = 0;
    self.contentWidth = self.collectionView.frame.size.width - (self.collectionView.contentInset.left + self.collectionView.contentInset.right);
    /*if ([self.cache count] != 0) {
        return;
    } */
    NSLog(@"Starting to prepare layout");
    self.columnWidth = self.contentWidth / self.numberOfColumns;
    for (int i = 0; i < (int) roundf(self.numberOfColumns); i++) {
        [self.xOffsets addObject: [NSNumber numberWithFloat:(CGFloat) i * self.columnWidth]];
        NSLog(@"Added x offset: %@", [NSNumber numberWithFloat:(CGFloat) i * self.columnWidth]);
        [self.yOffsets addObject:[NSNumber numberWithInt:0]];
        NSLog(@"Added y offset: %@", [NSNumber numberWithInt:0]);
    }
    NSLog(@"Added all offsets");
    int column = 0;
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        NSLog(@"Returned by delegate function: %f", [self.delegate heightForText:self.collectionView atIndexPath:indexPath]);
        self.textHeight = [self.delegate heightForText:self.collectionView atIndexPath:indexPath] + 250;
        CGFloat cellHeight = self.textHeight + 2 * self.cellPadding;
        self.itemFrame = CGRectMake([self.xOffsets[column] floatValue], [self.yOffsets[column] floatValue], self.columnWidth, cellHeight);
        self.insetFrame = CGRectInset(self.itemFrame, self.cellPadding, self.cellPadding);
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attribute.frame = self.insetFrame;
        [self.cache addObject:attribute];
        self.contentHeight = MAX(self.contentHeight, CGRectGetMaxY(self.itemFrame));
        self.yOffsets[column] = [NSNumber numberWithFloat:[[self.yOffsets objectAtIndex:column] floatValue] + cellHeight];
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

@end
