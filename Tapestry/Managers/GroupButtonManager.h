//
//  GroupButtonManager.h
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/28/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GroupButton.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

// This manager creates and controls selectable group buttons in a view.

@protocol GroupButtonsDelegate

// TODO: this might be necessary to create the frame of the view after the buttons are all created
@end

@interface GroupButtonManager : NSObject

@property (weak, nonatomic) id<GroupButtonsDelegate> delegate;

@property (nonatomic, strong) UIView* viewWithGroups;
@property (nonatomic, strong) NSMutableArray *buttonsCurrentlyOnScreen;
@property (nonatomic, strong) NSMutableDictionary *groupsSelected;

@property (nonatomic) int currentXEdge;
@property (nonatomic) int currentYLine;
@property (nonatomic) int numberOfRows;

- (instancetype) initWithView:(UIView*)view;
- (void)createButtonforObject:(PFObject*)group withTag:(int)tag;
- (NSMutableArray*) groupsSelectedInView;
- (void) resizeParentViewToButtons:(UIView*)view;

- (void) resetAllButtons;
- (void) removeAllButtonsFromSuperview:(UIView*)view;

@end

NS_ASSUME_NONNULL_END
