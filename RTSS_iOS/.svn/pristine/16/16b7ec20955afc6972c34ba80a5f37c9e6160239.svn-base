//
//  MobileUsageVC.h
//  EasyTT
//
//  Created by sheng yinpeng on 13-1-7.
//  Copyright (c) 2013年 lvming. All rights reserved.
//

#import "BasicViewController.h"
#import "FlowDateSearchVC.h"
#import "FlowByAppTableView.h"
#import "FlowByDateTableView.h"

typedef NS_ENUM(NSInteger, MoblieListType){
    AppListType=0,
    DateListType=1,
};

@interface MobileUsageVC : BasicViewController<FlowDateSearchDelegate,FlowByAppTableViewDelegate,FlowByDateTableViewDelegate>
{    
    UIButton* appListButton;
    UIButton* dateListButton;
    UILabel* totalValueLabel;
    
    NSInteger currentType;
    
    FlowByAppTableView* appTableView;
    FlowByDateTableView* dateTableView;
    
    NSDate* startDate;
    NSDate* endDate;
}
@property(nonatomic,retain)NSDate* startDate;
@property(nonatomic,retain)NSDate* endDate;

@property(nonatomic,retain)FlowByAppTableView* appTableView;
@property(nonatomic,retain)FlowByDateTableView* dateTableView;

@property(nonatomic,retain)NSArray* usageDataArray;
@property(nonatomic,retain)UIButton* appListButton;
@property(nonatomic,retain)UIButton* dateListButton;
@property(nonatomic,retain)UILabel* totalValueLabel;

@property(nonatomic,retain)NSDictionary* appListResultDic;
@property(nonatomic,retain)NSDictionary* dateListResultDic;

@property(nonatomic,retain)NSDictionary* appListDic;
@property(nonatomic,retain)NSDictionary* dateListDic;

@end
