//
//  EColumnChart.m
//  IOS7Test
//
//  Created by shengyp on 14-6-20.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "EColumnChart.h"
#import "EColumn.h"
#import "EColumnDataModel.h"

static const CGFloat EColumn_Highest_Scale = 1.15;
static const CGFloat EColumn_Bottom_Margin = 20.0;
static const CGFloat EColumn_Left_Margin = 5.0;
static const CGFloat EColumn_Right_Margin = 5.0;

@interface EColumnChart()

@property (nonatomic, retain) UIView* eColumnChartView;
@property (nonatomic, retain) UIScrollView* eColumnChartScrollView;

@end

@implementation EColumnChart
@synthesize eColumnChartView,eColumnChartScrollView,scaleLineColor,labelColor;
@synthesize dataSource;

- (void)dealloc
{
    [labelColor release];
    [scaleLineColor release];
	[eColumnChartView release];
	[eColumnChartScrollView release];
	
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self layoutContent];
    }
    return self;
}

- (void)layoutContent
{
	UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
	scrollView.backgroundColor = [UIColor clearColor];
	scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	self.eColumnChartScrollView = scrollView;
	[scrollView release];
	
	[self addSubview:self.eColumnChartScrollView];
}

- (CGFloat)getEColumnContentHeight
{
	return CGRectGetHeight(self.bounds)-EColumn_Bottom_Margin;
}

- (void)reloadDataWithAnimation:(BOOL)shouldAnimation
{
	if(nil == dataSource ||
       NO == [dataSource respondsToSelector:@selector(numberOfSectionsInEColumnChart:)] ||
       NO == [dataSource respondsToSelector:@selector(eColumnChart:numberOfRowsInSection:)] ||
       NO == [dataSource respondsToSelector:@selector(eColumnChart:horizontalGapInSection:)] ||
       NO == [dataSource respondsToSelector:@selector(eColumnChart:widthOfColumnAtIndexPath:)] ||
       NO == [dataSource respondsToSelector:@selector(eColumnChart:withOfItemAtIndexPath:)] ||
       NO == [dataSource respondsToSelector:@selector(eColumnChart:colorForColumnAtIndexPath:)] ||
       NO == [dataSource respondsToSelector:@selector(eColumnChart:valueAtIndexPath:)] ||
       NO == [dataSource respondsToSelector:@selector(eColumnChart:highestValueAtIndexPath:)]) {
        return;
    }
	
	if(nil != self.eColumnChartView){
		[self.eColumnChartView removeFromSuperview];
		self.eColumnChartView = nil;
	}
	
	if(nil == self.eColumnChartView){
		self.eColumnChartView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		self.eColumnChartView.backgroundColor = [UIColor clearColor];
		[self.eColumnChartScrollView addSubview:self.eColumnChartView];
	}
    
    CGFloat chartViewWidth      = EColumn_Left_Margin;
    CGFloat itemHeight          = [self getEColumnContentHeight];
   
    NSInteger sections = [dataSource numberOfSectionsInEColumnChart:self];
    for (int i = 0; i < sections; i ++) {
        CGFloat sectionGap = [dataSource eColumnChart:self horizontalGapInSection:i];
        NSInteger rows = [dataSource eColumnChart:self numberOfRowsInSection:i];
    
        // 底部小竖线
        UIView* vLine0 = [[UIView alloc] initWithFrame:CGRectMake(chartViewWidth, itemHeight, 0.5, 5)];
        vLine0.backgroundColor = self.scaleLineColor;
        [self.eColumnChartView addSubview:vLine0];
        [vLine0 release];
        
        // 分组
        CGFloat bottomX             = 0;
        CGFloat bottomWidth         = 0;
        for (int j = 0; j < rows; j ++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            
            EColumnDataModel* dataModel = [dataSource eColumnChart:self valueAtIndexPath:indexPath];
            UIColor* barColor           = [dataSource eColumnChart:self colorForColumnAtIndexPath:indexPath];
            CGFloat columnWith          = [dataSource eColumnChart:self widthOfColumnAtIndexPath:indexPath];
            CGFloat itemWidth           = [dataSource eColumnChart:self withOfItemAtIndexPath:indexPath];
            CGFloat highestValue        = [dataSource eColumnChart:self highestValueAtIndexPath:indexPath];
            CGFloat highestValueScale   = highestValue*EColumn_Highest_Scale;
            bottomWidth                += itemWidth;
            
            // ==
            CGRect itemFrame = CGRectMake(chartViewWidth+(itemWidth-columnWith)/2, 0, columnWith, itemHeight);
            EColumn* item = [[EColumn alloc] initWithFrame:itemFrame];
            item.backgroundColor = [UIColor clearColor];
            if(0 == highestValueScale)  highestValueScale = 1.0;
            item.grade = dataModel.value / highestValueScale;
            item.barColor = barColor;
            [self.eColumnChartView addSubview:item];
            [item release];
            
            // ==
            int topHeight = (1-dataModel.value/highestValueScale)* itemHeight;
            CGRect topLabelFrame = CGRectMake(chartViewWidth, topHeight-15, itemWidth, 15);
            EColumnChartLabel* topValueLabel = [[EColumnChartLabel alloc] initWithFrame:topLabelFrame];
            topValueLabel.backgroundColor = [UIColor clearColor];
            topValueLabel.textColor = barColor;
            topValueLabel.text = dataModel.valueString;
            [self.eColumnChartView addSubview:topValueLabel];
            [topValueLabel release];
            
            // 底部的标签
            if(0 == j){
                bottomX = chartViewWidth;
            }
            if(j == rows - 1){
                CGRect bottomLabelFrame = CGRectMake(bottomX, itemHeight, bottomWidth, 20);
                EColumnChartLabel* bottomValueLabel = [[EColumnChartLabel alloc] initWithFrame:bottomLabelFrame];
                bottomValueLabel.backgroundColor = [UIColor clearColor];
                bottomValueLabel.textColor = self.labelColor;
                bottomValueLabel.text = dataModel.label;
                [self.eColumnChartView addSubview:bottomValueLabel];
                [bottomValueLabel release];
            }

            chartViewWidth += itemWidth;
        }
        
        // 底部小竖线
        UIView* vLine1 = [[UIView alloc] initWithFrame:CGRectMake(chartViewWidth, itemHeight, 0.5, 5)];
        vLine1.backgroundColor = self.scaleLineColor;
        [self.eColumnChartView addSubview:vLine1];
        [vLine1 release];
        
        if(i != sections-1){
            chartViewWidth += sectionGap;
        }
    }
    
    chartViewWidth += EColumn_Right_Margin;
    
    // 底部的横线
    UIView* bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, itemHeight, chartViewWidth, 0.5)];
    bottomLine.backgroundColor = self.scaleLineColor;
    [self.eColumnChartView addSubview:bottomLine];
    [bottomLine release];
    
    // ==
    self.eColumnChartView.frame = CGRectMake(0, 0, chartViewWidth, self.bounds.size.height);
    self.eColumnChartScrollView.contentSize = self.eColumnChartView.bounds.size;
}

- (void)scrollToLast:(BOOL)animated
{
    CGPoint offsetPoint = CGPointZero;
    if(self.eColumnChartScrollView.contentSize.width > self.eColumnChartScrollView.bounds.size.width){
        offsetPoint = CGPointMake(self.eColumnChartScrollView.contentSize.width-self.eColumnChartScrollView.bounds.size.width, 0);
    }
    [self.eColumnChartScrollView setContentOffset:offsetPoint animated:animated];
}

@end

@implementation EColumnChartLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.userInteractionEnabled = YES;
        self.adjustsFontSizeToFitWidth = YES;
		self.backgroundColor = [UIColor clearColor];
		self.numberOfLines = 1;
        self.lineBreakMode = NSLineBreakByCharWrapping;
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:10.0f];
        self.textColor = [UIColor whiteColor];
        self.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    }
    return self;
}

@end
