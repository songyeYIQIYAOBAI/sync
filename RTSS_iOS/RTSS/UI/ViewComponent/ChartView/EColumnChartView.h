//
//  EColumnChartView.h
//  IOS7Test
//
//  Created by shengyp on 14-6-20.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EColumnChart.h"

@interface LegendItemView : UIView

@property(nonatomic, retain) UIView*        boxView;
@property(nonatomic, retain) UILabel*       nameLabel;

- (void)setNameLabelText:(NSString*)text;

@end

@protocol LegendScrollerViewDataSource <NSObject>

- (NSInteger)numberOfLegendInScrollerView;

- (UIColor*)getLegendColorAtIndex:(NSInteger)index;

- (NSString*)getLegendTextAtIndex:(NSInteger)index;

@end

@interface LegendScrollerView : UIView

@property (nonatomic, assign) id<LegendScrollerViewDataSource> dataSource;

- (void)reloadLegenData;

@end

@interface EColumnChartView : UIView<EColumnChartDataSource, LegendScrollerViewDataSource>

- (void)reloadChartData:(NSMutableArray*)dataArray isHiddenLegend:(BOOL)legend;

- (void)scrollToLast:(BOOL)animated;

@end
