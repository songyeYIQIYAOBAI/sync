//
//  BudgetManageViewController.h
//  RTSS
//
//  Created by 加富董 on 15/1/18.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BasicViewController.h"
#import "BudgetViewController.h"

@class BudgetGroup;

@interface BudgetManageViewController : BasicViewController

@property (nonatomic, assign) GroupType groupType;
@property (nonatomic, retain) BudgetGroup *curGroup;

@end
