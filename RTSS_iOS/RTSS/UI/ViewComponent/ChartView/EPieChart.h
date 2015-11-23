//
//  EPieChart.h
//  IOS7Test
//
//  Created by shengyp on 14-6-24.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EPieDataModel;
@class EPieChart;

@protocol EPieChartDataSource <NSObject>

@required
- (NSInteger)numberOfSlicesInEPieChart:(EPieChart*)pieChart;

- (EPieDataModel*)pieChart:(EPieChart*)pieChart valueForSliceAtIndex:(NSInteger)index;

- (UIColor*)pieChart:(EPieChart*)pieChart colorForSliceAtIndex:(NSInteger)index;

@end

@protocol EPieChartDelegate <NSObject>

@optional
- (void)pieChart:(EPieChart*)pieChart willSelectSliceAtIndex:(NSUInteger)index;

- (void)pieChart:(EPieChart*)pieChart didSelectSliceAtIndex:(NSUInteger)index;

- (void)pieChart:(EPieChart*)pieChart willDeselectSliceAtIndex:(NSUInteger)index;

- (void)pieChart:(EPieChart*)pieChart didDeselectSliceAtIndex:(NSUInteger)index;

- (void)selectedPieChart:(EPieChart*)pieChart index:(NSInteger)index percent:(CGFloat)per;

@end

@interface EPieChart : UIView

@property(nonatomic, assign) id<EPieChartDataSource> dataSource;
@property(nonatomic, assign) id<EPieChartDelegate> delegate;

- (id)initWithFrame:(CGRect)frame isRotated:(BOOL)rotated;

- (void)reloadChart;

@end
