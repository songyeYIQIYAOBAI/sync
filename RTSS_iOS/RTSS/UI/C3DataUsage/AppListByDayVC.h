//
//  AppListByDayVC.h
//  EasyTT
//
//  Created by sheng yinpeng on 13-6-4.
//  Copyright (c) 2013年 lvming. All rights reserved.
//

#import "BasicViewController.h"

@class FlowByDateTableView;
@interface AppListByDayVC : BasicViewController
{
    FlowByDateTableView* dateTableView;
    
    UIImageView* appIconView;
    UILabel* appNameLabel;
    UILabel* monthLabel;
    UILabel* totalFlowLabel;
    
    NSString* appIconString;
    NSString* appNameString;
    NSString* monthString;
    NSString* totalFlowString;
}

@property(nonatomic,retain)NSString* appIconString;
@property(nonatomic,retain)NSString* appNameString;
@property(nonatomic,retain)NSString* monthString;
@property(nonatomic,retain)NSString* totalFlowString;
@property(nonatomic,retain)FlowByDateTableView* dateTableView;

@property(nonatomic,retain)NSDictionary* appItemDic;
@property(nonatomic,retain)NSDictionary* monthItemDic;

@property(nonatomic,retain)NSDictionary* appListByDayResultDic;

@property(nonatomic,assign)NSInteger rowKeySuper;
@property(nonatomic,assign)NSInteger rowKey;

@end
