//
//  UsageAlertListView.h
//  RTSS
//
//  Created by tiger on 14-11-26.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsageAlertListModel.h"

@protocol UsageAlertListViewDelegate <NSObject>

-(void)UsageAlertListViewNotificationClick:(UIButton *)button WithModel:(UsageAlertListModel *)model;

@end

@interface UsageAlertListView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* tableListView;
}

@property(nonatomic, retain)NSMutableArray * dataList;
@property(nonatomic, copy)NSString * headTitle;
@property(nonatomic, assign)id<UsageAlertListViewDelegate> delegate;

@end