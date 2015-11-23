//
//  ETTQueryMonthViewController.h
//  EasyTT
//
//  Created by 蔡杰 on 14-10-22.
//  Copyright (c) 2014年 lvming. All rights reserved.
//



#import "AppBaseTableViewViewController.h"

@class EColumnChartView;
@interface QueryMonthTableHeaderView : UIView

@property(nonatomic, readonly) EColumnChartView* mColumnChartView;

@end


@interface QueryMonthViewController : AppBaseTableViewViewController

@end
