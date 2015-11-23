//
//  DateListByMonthVC.h
//  EasyTT
//
//  Created by sheng yinpeng on 13-6-4.
//  Copyright (c) 2013年 lvming. All rights reserved.
//

#import "BasicViewController.h"
#import "FlowByAppTableView.h"

@interface DateListByMonthVC : BasicViewController<FlowByAppTableViewDelegate>
{
    UILabel* monthLabel;
    UILabel* totalFlowLabel;
    
    NSString* monthString;
    NSString* totalFlowString;
    
    FlowByAppTableView* appTableView;
}

@property(nonatomic,retain)NSString* monthString;
@property(nonatomic,retain)NSString* totalFlowString;

@property(nonatomic,retain)FlowByAppTableView* appTableView;

@property(nonatomic,retain)NSDictionary* appListDic;
@property(nonatomic,retain)NSDictionary* dateItemDic;

@property(nonatomic,retain)NSDictionary* dateListByMonthResultDic;

@property(nonatomic,assign)NSInteger rowKey;

@end
