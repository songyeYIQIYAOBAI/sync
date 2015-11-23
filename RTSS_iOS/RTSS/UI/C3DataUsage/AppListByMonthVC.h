//
//  AppListByMonthVC.h
//  EasyTT
//
//  Created by sheng yinpeng on 13-6-4.
//  Copyright (c) 2013年 lvming. All rights reserved.
//

#import "BasicViewController.h"
#import "FlowByDateTableView.h"

@interface AppListByMonthVC : BasicViewController<FlowByDateTableViewDelegate>
{
    FlowByDateTableView* dateTableView;
    
    UIImageView* appIconView;
    UILabel* appNameLabel;
    UILabel* monthIntervalLabel;
    UILabel* totalFlowLabel;
    
    NSString* appIconString;
    NSString* appNameString;
    NSString* monthIntervalString;
    NSString* totalFlowString;
}

@property(nonatomic,retain)NSString* appIconString;
@property(nonatomic,retain)NSString* appNameString;
@property(nonatomic,retain)NSString* monthIntervalString;
@property(nonatomic,retain)NSString* totalFlowString;
@property(nonatomic,retain)FlowByDateTableView* dateTableView;

@property(nonatomic,retain)NSDictionary* appItemDic;

@property(nonatomic,retain)NSDictionary* monthListDic;

@property(nonatomic,retain)NSDate* startDate;
@property(nonatomic,retain)NSDate* endDate;

@property(nonatomic,retain)NSDictionary* appListByMonthResultDic;

@property(nonatomic,assign)NSInteger rowKey;

@end
