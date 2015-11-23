//
//  DateFootprintBaseView.h
//  RTSS
//
//  Created by 蔡杰Alan on 15-3-4.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateFootprintDelegate.h"

#import "DateUtils.h"
#import "RTSSAppStyle.h"
#import "UILabel+LabelTextColor.h"
#import "CommonUtils.h"
#import "RTSSAppDefine.h"
typedef NS_ENUM(NSInteger, DateType) {
    DateTypeDay,
    DateTypeMonth,
    DateTypeYear
};

@protocol DateFootprintDelegate;
@class DateButton;
@interface DateFootprintBaseView : UIView

@property(nonatomic,retain,readonly)UILabel *dateLabel;
@property(nonatomic,retain,readonly)DateButton *leftButton;
@property(nonatomic,retain,readonly)DateButton *rightButton;



@property(nonatomic,assign)id<DateFootprintDelegate>delegate;


//默认从当月开始--
@property(nonatomic,assign)NSInteger   dateInterval;

-(void)updateCurrentDate;





@end
