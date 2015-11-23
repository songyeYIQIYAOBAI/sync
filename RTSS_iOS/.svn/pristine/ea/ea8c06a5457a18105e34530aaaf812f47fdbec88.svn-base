//
//  EPieChartView.h
//  IOS7Test
//
//  Created by shengyp on 14-6-25.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPieChart.h"

@interface EPieChartTopView : UIImageView
{
	UILabel* topLabel;
	UILabel* topValueLabel;
}

- (void)setTopLabelText:(NSString*)topText;
- (void)setTopValueLabelText:(NSString*)topValueText;

@end

@interface EPieChartBottomView : UIView
{
	UILabel* bottomLabel;
	UILabel* bottomValueLabel;
	UILabel* bottomSubValueLabel;
}

@property(nonatomic, readonly)UIButton* bottomButton;

- (void)setBottomLabelText:(NSString*)bottomText;
- (void)setBottomValueText:(NSString*)bottomValueText;
- (void)setBottomSubValueText:(NSString *)bottomSubValueText;

@end

@class EPieChartView;
@class QueryAccStatResponse;

@protocol EPieChartViewDelegate <NSObject>

@optional
- (void)selectedChartDetail:(EPieChartView*)pieChartView index:(NSInteger)index;

@end

@interface EPieChartView : UIView<EPieChartDataSource,EPieChartDelegate>
{
	EPieChart* ePieChartView;
	
	NSInteger selectedIndex;
}

@property(nonatomic, assign) id<EPieChartViewDelegate> delegate;

@property(nonatomic, retain)EPieChartTopView* chartTop;
@property(nonatomic, retain)EPieChartBottomView* chartBottom;

- (void)reloadChartData:(NSMutableArray*)dataArray;

- (NSArray*)getDetailItemListAtIndex:(NSInteger)index;
- (EPieDataModel*)getPieItemValueAtIndex:(NSInteger)index;

@end
