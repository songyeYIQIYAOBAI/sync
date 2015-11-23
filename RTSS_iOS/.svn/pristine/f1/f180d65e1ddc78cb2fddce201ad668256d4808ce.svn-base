//
//  ELineChart.m
//  SJB2
//
//  Created by shengyp on 14-6-19.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import "ELineChart.h"
#import "ELine.h"

@interface ELineChart()

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, retain) UIColor* lineColor;
@property (nonatomic, retain) UIColor* dotColor;
@property (nonatomic, retain) UIColor* dotBorderColor;

@property (nonatomic, retain)ELine* eLine;
@property (nonatomic, retain)UIScrollView* eLineChartScrollView;

@end

@implementation ELineChart
@synthesize lineWidth,lineColor,dotColor,dotBorderColor,dataSource,eLineChartScrollView,eLine;

- (void)dealloc
{
	[lineColor release];
	[dotColor release];
	[dotBorderColor release];
	
	[eLine release];
	[eLineChartScrollView release];
	
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

- (id)initWithFrame:(CGRect)frame lineColor:(UIColor*)aLineColor lineWidth:(CGFloat)aLineWidth dotColor:(UIColor*)aDotColor
{
	self = [self initWithFrame:frame];
	if(self){
		self.lineColor = aLineColor;
		self.lineWidth = aLineWidth;
		self.dotColor = aDotColor;
	}
	return self;
}

- (void)layoutContent
{
	UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
	scrollView.backgroundColor = [UIColor clearColor];
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	self.eLineChartScrollView = scrollView;
	[scrollView release];
	
	[self addSubview:self.eLineChartScrollView];
}

- (void)reloadDataWithAnimation:(BOOL)shouldAnimation
{
	if(nil == dataSource ||
       NO == [dataSource respondsToSelector:@selector(numberOfPointsInELineChart:)] ||
       NO == [dataSource respondsToSelector:@selector(horizentalGapInELineChart:)]){
           return;
    }
    
    if(nil != self.eLine){
        [self.eLine removeFromSuperview];
        self.eLine = nil;
    }

    self.eLine = [[[ELine alloc] initWithFrame:CGRectZero lineColor:self.lineColor lineWidth:self.lineWidth dotColor:self.dotColor] autorelease];
    self.eLine.dataSource = self;
    [self.eLineChartScrollView addSubview:self.eLine];
	
	CGFloat width = [dataSource horizentalGapInELineChart:self]*[dataSource numberOfPointsInELineChart:self];
	self.eLineChartScrollView.contentSize = CGSizeMake(width, self.bounds.size.height);
	self.eLine.frame = CGRectMake(0, 0, width, self.bounds.size.height);
	[self.eLine reloadDataWithAnimation:shouldAnimation];
}

#pragma mark ELineDataSource
- (NSInteger)numberOfPointsInELine:(ELine*)eLine
{
	return [dataSource numberOfPointsInELineChart:self];
}

- (CGFloat)horizentalGapInELine:(ELine*)eLine
{
	return [dataSource horizentalGapInELineChart:self];
}

- (ELineDataModel*)highestValueInELine:(ELine*)eLine
{
	return [dataSource highestValueELineChart:self];
}

- (ELineDataModel*)eLine:(ELine*)eLine valueForIndex:(NSInteger)index
{
	return [dataSource eLineChart:self valueForIndex:index];
}

- (UIColor*)eLine:(ELine*)eLine colorForIndex:(NSInteger)index
{
	return [dataSource eLineChart:self colorForIndex:index];
}

@end
