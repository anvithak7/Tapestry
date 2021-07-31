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
     // remainder of your constructor
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
    groupButton.backgroundColor = [UIColor lightGrayColor]; //TODO: CHANGE THIS COLOR
    [groupButton setBackgroundColor:[UIColor redColor] forState:UIControlStateSelected]; // TODO: change this color;
    [self.buttonsCurrentlyOnScreen addObject:groupButton];
    self.groupsSelected[group.objectId] = @0;
    [self.viewWithGroups addSubview:groupButton];
}

- (void)buttonClicked:(GroupButton*)sender {
    // A way to set the selected vs unselected state of a button
    //int tag = (int) sender.tag;
    if (!sender.isSelected) {
        [sender setSelected:TRUE];
        [self.groupsSelected setValue:@1 forKey:sender.groupTag];
        /*if (tag == 0) {
            [sender setBackgroundColor:[UIColor redColor]];
        } else if (tag == 1) {
            [sender setBackgroundColor:[UIColor blueColor]];
        } else if (tag == 2) {
            [sender setBackgroundColor:[UIColor greenColor]];
        } */
    } else {
        [sender setSelected:FALSE];
        [self.groupsSelected setValue:@0 forKey:sender.groupTag];
        [sender setBackgroundColor:[UIColor lightGrayColor]]; // TODO: set back to default color
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
        [button setBackgroundColor:[UIColor lightGrayColor]]; //TODO: change default background color
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
}

- (void) resizeParentViewToButtons:(UIView*)view {
    int viewHeight = (self.numberOfRows * 38) + 8;
    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, viewHeight)];
    //view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, viewHeight);
}

- (NSString*) createMultilineButtonTextWith:(NSString*)title {
    NSString *thisGroupName = title;
    NSString *stringToFindSpaceIn = [thisGroupName substringFromIndex:(NSInteger) 45]; // Change this number based on the longest length of a group name;
    NSInteger indexToCut = [stringToFindSpaceIn rangeOfString:@" "].location + 45;
    NSString *buttonTitle = [[thisGroupName substringToIndex:indexToCut] stringByAppendingString:@"\n"];
    NSString *completeButtonTitle = [buttonTitle stringByAppendingString:[thisGroupName substringFromIndex:indexToCut]];
    // The above allows a group name to be multi-line.
    return completeButtonTitle;
}

@end
