//
//  BudgetDetailViewController.h
//  RTSS
//
//  Created by 加富董 on 15/2/3.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BasicViewController.h"
#import "BudgetGroup.h"

@class Subscriber;
@class MemberBudget;

@interface BudgetDetailViewController : BasicViewController

@property (nonatomic, assign) BOOL editable;
@property (nonatomic, retain) Subscriber *currentMember;
@property (nonatomic, retain) BudgetGroup *currentGroup;
@property (nonatomic, retain) MemberBudget *currentBudget;

@end
