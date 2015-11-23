//
//  ELineChartView.m
//  SJB2
//
//  Created by shengyp on 14-6-19.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import "ELineChartView.h"
#import "ELineChart.h"
#import "ELineDataModel.h"
#import "CommonUtils.h"

@interface ELineChartView()

@property (nonatomic, readonly) ELineChart* eLineChart;
@property (nonatomic, retain) NSMutableArray* eLineChartDataArray;

@end

@implementation ELineChartView
@synthesize eLineChart, eLineChartDataArray;

- (void)dealloc
{
	[eLineChart release];
	[eLineChartDataArray release];
	
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self layoutContent];
    }
    return self;
}

- (void)layoutContent
{
	UIView* box1 = [[UIView alloc] initWithFrame:CGRectMake(20, 4.5, 6, 6)];
	[self addSubview:box1];
	[box1 release];
	
	CGRect boxFrame = CGRectMake(box1.frame.origin.x+box1.frame.size.width+5, 0, 30, 15);
	UILabel* box1Label = [[UILabel alloc] initWithFrame:boxFrame];
	box1Label.backgroundColor = [UIColor clearColor];
	box1Label.font = [UIFont systemFontOfSize:10.0];
	[self addSubview:box1Label];
	[box1Label release];
	
	boxFrame = CGRectMake(box1Label.frame.origin.x+box1Label.frame.size.width+5, 4.5, 6, 6);
	UIView* box2 = [[UIView alloc] initWithFrame:boxFrame];
	[self addSubview:box2];
	[box2 release];
	
	boxFrame = CGRectMake(box2.frame.origin.x+box2.frame.size.width+5, 0, 30, 15);
	UILabel* box2Label = [[UILabel alloc] initWithFrame:boxFrame];
	box2Label.backgroundColor = [UIColor clearColor];
	box2Label.font = [UIFont systemFontOfSize:10.0];
	[self addSubview:box2Label];
	[box2Label release];
	
	boxFrame = CGRectMake(box2Label.frame.origin.x+box2Label.frame.size.width+5, 4.5, 6, 6);
	UIView* box3 = [[UIView alloc] initWithFrame:boxFrame];
	[self addSubview:box3];
	[box3 release];
	
	boxFrame = CGRectMake(box3.frame.origin.x+box3.frame.size.width+5, 0, 30, 15);
	UILabel* box3Label = [[UILabel alloc] initWithFrame:boxFrame];
	box3Label.backgroundColor = [UIColor clearColor];
	box3Label.font = [UIFont systemFontOfSize:10.0];
	[self addSubview:box3Label];
	[box3Label release];
	
	eLineChart = [[ELineChart alloc] initWithFrame:CGRectMake(0, 15, self.frame.size.width, self.frame.size.height-15)
										 lineColor:[CommonUtils colorWithHexString:@"#00B6E5"]
										 lineWidth:2
										  dotColor:[UIColor whiteColor]];
	eLineChart.backgroundColor = [UIColor clearColor];
	eLineChart.dataSource = self;
	[self addSubview:eLineChart];
	
	UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
	lineView.backgroundColor = [CommonUtils colorWithHexString:@"#B2B2B2"];
	[self addSubview:lineView];
	[lineView release];
}

- (void)reloadChartData:(NSMutableArray*)dataArray
{
	self.eLineChartDataArray = dataArray;
	
	[eLineChart reloadDataWithAnimation:YES];
}

#pragma mark ELineChartDataSource
- (NSInteger)numberOfPointsInELineChart:(ELineChart *)eLineChart
{
	return [self.eLineChartDataArray count];
}

- (CGFloat)horizentalGapInELineChart:(ELineChart*)eLineChart
{
	return 55.0;
}

- (ELineDataModel*)highestValueELineChart:(ELineChart*)eLineChart
{
	ELineDataModel* maxDataModel = nil;
    CGFloat maxValue = -FLT_MIN;
    for (ELineDataModel* dataModel in self.eLineChartDataArray){
        if (dataModel.value > maxValue){
            maxValue = dataModel.value;
            maxDataModel = dataModel;
        }
    }
    return maxDataModel;
}

- (ELineDataModel*)eLineChart:(ELineChart*)eLineChart valueForIndex:(NSInteger)index
{
	if(index >= [self.eLineChartDataArray count] || index < 0) return nil;
	return [self.eLineChartDataArray objectAtIndex:index];
}

- (UIColor*)eLineChart:(ELineChart*)eLineChart colorForIndex:(NSInteger)index
{
	CGFloat sumValue = 0.0;
	CGFloat indexValue = 0.0;
	NSInteger count = [self.eLineChartDataArray count];
	for (int i = 0; i < count; i ++) {
		ELineDataModel* dataModel = [self.eLineChartDataArray objectAtIndex:i];
		sumValue += dataModel.value;
		if(index == i){
			indexValue = dataModel.value;
		}
	}
	UIColor* dotColor = [UIColor greenColor];
	if(0 == sumValue || 0 == indexValue){
		dotColor = [UIColor orangeColor];
	}else if(indexValue >= sumValue / count * 0.9){
		dotColor = [UIColor yellowColor];
	}else if(indexValue < sumValue / count * 0.4){
		dotColor = [UIColor purpleColor];
	}
	return dotColor;
}

@end
