//
//  BudgetVicinityViewController.h
//  RTSS
//
//  Created by 加富董 on 15/2/7.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BasicViewController.h"
#import "BudgetViewController.h"

@class BudgetGroup;

@class BudgetVicinityViewController;

@protocol BudgetVicinityViewControllerDelegate <NSObject>

@optional

- (void)budgetVicinityViewController:(BudgetVicinityViewController *)vicinity didClickedConfirmButtonWithMembersData:(NSMutableArray *)membersArray;

@end


@interface BudgetVicinityViewController : BasicViewController

@property (nonatomic, assign) GroupType groupType;
@property (nonatomic, assign) id <BudgetVicinityViewControllerDelegate> delegate;
@property (nonatomic, retain) BudgetGroup *currentGroup;

@end
