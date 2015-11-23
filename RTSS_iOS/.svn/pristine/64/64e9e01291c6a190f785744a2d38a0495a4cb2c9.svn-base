//
//  EColumnChart.h
//  IOS7Test
//
//  Created by shengyp on 14-6-20.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EColumnChart;
@class EColumnDataModel;

@protocol EColumnChartDataSource <NSObject>

@required
// 共有几组
- (NSInteger)numberOfSectionsInEColumnChart:(EColumnChart*)eColumnChart;
// 每组里有多少个条目
- (NSInteger)eColumnChart:(EColumnChart*)eColumnChart numberOfRowsInSection:(NSInteger)section;
// 每组之间的间隔
- (CGFloat)eColumnChart:(EColumnChart*)eColumnChart horizontalGapInSection:(NSInteger)section;
// 每个条目中柱状图的宽
- (CGFloat)eColumnChart:(EColumnChart*)eColumnChart widthOfColumnAtIndexPath:(NSIndexPath*)indexPath;
// 每个条目的宽
- (CGFloat)eColumnChart:(EColumnChart*)eColumnChart withOfItemAtIndexPath:(NSIndexPath*)indexPath;
// 每组条目的颜色
- (UIColor*)eColumnChart:(EColumnChart*)eColumnChart colorForColumnAtIndexPath:(NSIndexPath*)indexPath;
// 获取每组中相应条目的最大值
- (CGFloat)eColumnChart:(EColumnChart *)eColumnChart highestValueAtIndexPath:(NSIndexPath*)indexPath;
// 获取指定位置的条目
- (EColumnDataModel*)eColumnChart:(EColumnChart*)eColumnChart valueAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface EColumnChart : UIView

@property(nonatomic, retain) UIColor* scaleLineColor;
@property(nonatomic, retain) UIColor* labelColor;

@property(nonatomic, assign) id<EColumnChartDataSource> dataSource;

- (void)reloadDataWithAnimation:(BOOL)shouldAnimation;

- (void)scrollToLast:(BOOL)animated;

@end

@interface EColumnChartLabel : UILabel

@end
