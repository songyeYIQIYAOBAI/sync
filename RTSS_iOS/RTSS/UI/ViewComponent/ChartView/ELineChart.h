//
//  ELineChart.h
//  SJB2
//
//  Created by shengyp on 14-6-19.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELine.h"

@class ELineChart;
@class ELineDataModel;

@protocol ELineChartDataSource <NSObject>
@required

- (NSInteger)numberOfPointsInELineChart:(ELineChart *)eLineChart;

- (CGFloat)horizentalGapInELineChart:(ELineChart*)eLineChart;

- (ELineDataModel*)highestValueELineChart:(ELineChart*)eLineChart;

- (ELineDataModel*)eLineChart:(ELineChart*)eLineChart valueForIndex:(NSInteger)index;

- (UIColor*)eLineChart:(ELineChart*)eLineChart colorForIndex:(NSInteger)index;

@end

@interface ELineChart : UIView<ELineDataSource>

@property (nonatomic, assign) id<ELineChartDataSource> dataSource;

- (id)initWithFrame:(CGRect)frame lineColor:(UIColor*)aLineColor lineWidth:(CGFloat)aLineWidth dotColor:(UIColor*)aDotColor;

- (void)reloadDataWithAnimation:(BOOL)shouldAnimation;

@end
