//
//  GroupButtonManager.m
//  Tapestry
//
//  Created by Anvitha Kachinthaya on 7/28/21.
//

#import "GroupButtonManager.h"

@implementation GroupButtonManager

- (instancetype) initWithView:(UIView*)view {
    self = [super init];
    if (self) {
        self.viewWithGroups = view;
        self.currentXEdge = 8;
        self.currentYLine = 8;
        self.numberOfRows = 1;
        self.buttonsCurrentlyOnScreen = [NSMutableArray new];
        self.groupsSelected = [NSMutableDictionary new];
    }
    return self;
}

- (void)createButtonforObject:(PFObject*)group withTag:(int)tag {
    GroupButton *groupButton = [[GroupButton alloc] initWithFrame:CGRectMake(self.currentXEdge, self.currentYLine, 30.0, 30.0)];
    groupButton.tag = tag;
    groupButton.groupTag = group.objectId;
    [groupButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if ([group[@"groupName"] length] > 50) {
        [groupButton setTitle:[self createMultilineButtonTextWith:group[@"groupName"]] forState:UIControlStateNormal];
    } else {
        [groupButton setTitle:group[@"groupName"] forState:UIControlStateNormal];
    }
    [groupButton sizeToFit];
    if ((self.currentXEdge + groupButton.frame.size.width + 8) > self.viewWithGroups.frame.size.width) {
        self.currentYLine += 38;
        self.numberOfRows += 1;
        self.currentXEdge = 8;
    }
    groupButton.frame = CGRectMake(self.currentXEdge, self.currentYLine, groupButton.frame.size.width + 6, 30.0);
    self.currentXEdge += groupButton.frame.size.width + 8;
    [groupButton setBackgroundColor:[groupButton getDarkerColor] forState:UIControlStateSelected];
    [self.buttonsCurrentlyOnScreen addObject:groupButton];
    self.groupsSelected[group.objectId] = @0;
    [self.viewWithGroups addSubview:groupButton];
}

- (void)buttonClicked:(GroupButton*)sender {
    if (!sender.isSelected) {
        [sender setSelected:TRUE];
        [self.groupsSelected setValue:@1 forKey:sender.groupTag];
    } else {
        [sender setSelected:FALSE];
        [self.groupsSelected setValue:@0 forKey:sender.groupTag];
    }
}

- (NSMutableArray*)groupsSelectedInView {
    NSMutableArray *objectsToSend = [NSMutableArray new];
    for (id key in self.groupsSelected) {
        id value = [self.groupsSelected objectForKey:key];
        if ([value isEqual:@(1)]) {
            [objectsToSend addObject:key];
        }
    }
    PFUser *user = [PFUser currentUser];
    Group *userStories = [user objectForKey:@"userStories"];
    [objectsToSend addObject:userStories.objectId];
    return objectsToSend;
}

- (void)resetAllButtons {
    for (GroupButton *button in self.buttonsCurrentlyOnScreen) {
        [button setBackgroundColor:button.buttonColor];
        [button setSelected:false];
    }
}

- (void)removeAllButtonsFromSuperview:(UIView *)view {
    for (GroupButton *button in self.buttonsCurrentlyOnScreen) {
        [button removeFromSuperview];
    }
    [self.buttonsCurrentlyOnScreen removeAllObjects];
    self.currentXEdge = 8;
    self.currentYLine = 8;
    self.numberOfRows = 1;
}

- (CGFloat)resizeParentViewToButtons:(UIView*)view {
    int viewHeight = (self.numberOfRows * 38) + 8;
    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, viewHeight)];
    return viewHeight;
    //view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, viewHeight);
}

- (NSString*)createMultilineButtonTextWith:(NSString*)title {
    NSString *thisGroupName = title;
    NSString *stringToFindSpaceIn = [thisGroupName substringFromIndex:(NSInteger) 45]; // Change this number based on the longest length of a group name;
    NSInteger indexToCut = [stringToFindSpaceIn rangeOfString:@" "].location + 45;
    NSString *buttonTitle = [[thisGroupName substringToIndex:indexToCut] stringByAppendingString:@"\n"];
    NSString *completeButtonTitle = [buttonTitle stringByAppendingString:[thisGroupName substringFromIndex:indexToCut]];
    // The above allows a group name to be multi-line.
    return completeButtonTitle;
}

@end
