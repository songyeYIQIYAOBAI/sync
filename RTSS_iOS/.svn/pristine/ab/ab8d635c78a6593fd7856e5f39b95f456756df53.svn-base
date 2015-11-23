//
//  EPieChartView.m
//  IOS7Test
//
//  Created by shengyp on 14-6-25.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "EPieChartView.h"
#import "EPieDataModel.h"
#import "CommonUtils.h"

@implementation EPieChartTopView

- (void)dealloc
{
    [super dealloc];
}

- (UILabel*)layoutTopLabel:(CGRect)frame
{
	UILabel* label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.numberOfLines = 1;
	label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	label.textAlignment = NSTextAlignmentCenter;
	label.font = [UIFont systemFontOfSize:14.0];
	
	return label;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.image = [UIImage imageNamed:@"sjb_pie_chat_top.png"];
		
        topLabel = [self layoutTopLabel:CGRectMake(0, self.bounds.size.height/2.0-25, self.bounds.size.width, 25)];
		topLabel.textColor = [CommonUtils colorWithHexString:@"#FFFFFF"];
		topLabel.font = [UIFont systemFontOfSize:16.0];
		[self addSubview:topLabel];
		
		topValueLabel = [self layoutTopLabel:CGRectMake(0, self.bounds.size.height/2.0, self.bounds.size.width, 25)];
		topValueLabel.textColor = [CommonUtils colorWithHexString:@"#FFFFFF"];
		topValueLabel.font = [UIFont systemFontOfSize:18.0];
		[self addSubview:topValueLabel];
    }
    return self;
}

- (void)setTopLabelText:(NSString*)topText
{
	topLabel.text = topText;
}

- (void)setTopValueLabelText:(NSString*)topValueText
{
	topValueLabel.text = topValueText;
}

@end

@implementation EPieChartBottomView
@synthesize bottomButton;

- (void)dealloc
{
	[bottomButton release];
	
    [super dealloc];
}

- (UILabel*)layoutBottomLabel:(CGRect)frame
{
	UILabel* label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.numberOfLines = 1;
	label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	label.textAlignment = NSTextAlignmentLeft;
	label.font = [UIFont systemFontOfSize:14.0];
	
	return label;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 69.5)];
		[bottomButton setBackgroundImage:[UIImage imageNamed:@"sjb_pie_chat_content.png"] forState:UIControlStateNormal];
		[self addSubview:bottomButton];
		
        bottomLabel = [self layoutBottomLabel:CGRectMake(10, 8, bottomButton.bounds.size.width-85-10, 69.5-8)];
		bottomLabel.backgroundColor = [UIColor clearColor];
		bottomLabel.textColor = [CommonUtils colorWithHexString:@"#FFFFFF"];
		bottomLabel.font = [UIFont systemFontOfSize:16.0];
		[bottomButton addSubview:bottomLabel];
		
		bottomValueLabel = [self layoutBottomLabel:CGRectMake(bottomButton.bounds.size.width-85, 8, 70, 69.5-8)];
		bottomValueLabel.backgroundColor = [UIColor clearColor];
		bottomValueLabel.textColor = [CommonUtils colorWithHexString:@"#FFFFFF"];
		bottomValueLabel.textAlignment = NSTextAlignmentRight;
		[bottomButton addSubview:bottomValueLabel];
		
		bottomSubValueLabel = [self layoutBottomLabel:CGRectMake(0, self.bounds.size.height-30, self.bounds.size.width, 20)];
		bottomSubValueLabel.backgroundColor = [UIColor clearColor];
		bottomSubValueLabel.textColor = [CommonUtils colorWithHexString:@"#FFFFFF"];
		bottomSubValueLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:bottomSubValueLabel];
		
		UIImageView* arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(bottomButton.bounds.size.width-23, 8+(bottomButton.bounds.size.height-8-23.5)/2.0, 19, 23.5)];
		arrowView.image = [UIImage imageNamed:@"sjb_find_item_arrow_d.png"];
		arrowView.highlightedImage = [UIImage imageNamed:@"sjb_find_item_arrow_a.png"];
		[bottomButton addSubview:arrowView];
		[arrowView release];
    }
    return self;
}

- (void)setBottomLabelText:(NSString*)bottomText
{
	bottomLabel.text = bottomText;
}

- (void)setBottomValueText:(NSString*)bottomValueText
{
	bottomValueLabel.text = bottomValueText;
}

- (void)setBottomSubValueText:(NSString*)bottomSubValueText
{
	bottomSubValueLabel.text = bottomSubValueText;
}

@end


@interface EPieChartView()

@property(nonatomic, retain)NSMutableArray* pieChartDatasArray;

@end

@implementation EPieChartView
@synthesize chartTop,chartBottom,delegate;
@synthesize pieChartDatasArray;

- (void)dealloc
{
	[chartTop release];
	[chartBottom release];
	
	[ePieChartView release];
	[pieChartDatasArray release];
	
	self.delegate = nil;
	
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		selectedIndex = -1;
        // Initialization code
		ePieChartView = [[EPieChart alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 250.0) isRotated:YES];
		ePieChartView.backgroundColor = [UIColor clearColor];
		ePieChartView.dataSource = self;
		ePieChartView.delegate = self;
		[self addSubview:ePieChartView];
		
		self.chartTop = [[[EPieChartTopView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)] autorelease];
		self.chartTop.center = CGPointMake(ePieChartView.bounds.size.width/2.0, ePieChartView.bounds.size.height/2.0);
		[self addSubview:self.chartTop];
		[self.chartTop setTopLabelText:@""];
		[self.chartTop setTopValueLabelText:@""];
		
		self.chartBottom = [[[EPieChartBottomView alloc] initWithFrame:CGRectMake(8, 280, 304, 100)] autorelease];
		[self.chartBottom.bottomButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.chartBottom];
		[self.chartBottom setBottomLabelText:@""];
		[self.chartBottom setBottomValueText:@""];
		[self.chartBottom setBottomSubValueText:@""];
    }
    return self;
}

- (void)buttonAction:(UIButton*)button
{
	if(nil != delegate && [delegate respondsToSelector:@selector(selectedChartDetail:index:)]){
		[delegate selectedChartDetail:self index:selectedIndex];
	}
}

- (NSArray*)getDetailItemListAtIndex:(NSInteger)index
{
	if(index >= 0 && index < [self.pieChartDatasArray count]){
		EPieDataModel* dataModel = [self.pieChartDatasArray objectAtIndex:index];
		return dataModel.detailArray;
	}
	return nil;
}

- (EPieDataModel*)getPieItemValueAtIndex:(NSInteger)index
{
	if(index >= 0 && index < [self.pieChartDatasArray count]){
		return [self.pieChartDatasArray objectAtIndex:index];
	}
	return nil;
}

- (void)reloadChartData:(NSMutableArray*)dataArray
{
	self.pieChartDatasArray = dataArray;
	
	CGFloat totalFee = 0.0;
	for (EPieDataModel* dataModel in dataArray) {
		totalFee += dataModel.realValue;
	}
	
	CGFloat minValue = totalFee * 3 / 100;
	CGFloat delta = 0.0;
	CGFloat sumOfBiger = 0.0;
	for (EPieDataModel* dataModel in dataArray) {
		if(dataModel.realValue < minValue){
			delta += minValue - dataModel.realValue;
			dataModel.value = minValue;
		}else if(dataModel.realValue > minValue){
			sumOfBiger += dataModel.realValue;
			dataModel.value = dataModel.realValue;
		}else{
			dataModel.value = dataModel.realValue;
		}
	}
	
	for (EPieDataModel* dataModel in dataArray) {
		if(dataModel.realValue > minValue){
			dataModel.value -= dataModel.realValue * delta / sumOfBiger;
		}
	}
	
	[ePieChartView reloadChart];
}

- (NSInteger)numberOfSlicesInEPieChart:(EPieChart*)pieChart
{
	return [self.pieChartDatasArray count];
}

- (EPieDataModel*)pieChart:(EPieChart*)pieChart valueForSliceAtIndex:(NSInteger)index
{
	return [self.pieChartDatasArray objectAtIndex:index];
}

- (UIColor*)pieChart:(EPieChart*)pieChart colorForSliceAtIndex:(NSInteger)index
{	
	int value = index % 6;
	if(0 == value){
		return [CommonUtils colorWithHexString:@"#00bde6"];
	}else if(1 == value){
		return [CommonUtils colorWithHexString:@"#a376f9"];
	}else if(2 == value){
		return [CommonUtils colorWithHexString:@"#ff9600"];
	}else if(3 == value){
		return [CommonUtils colorWithHexString:@"#c5d41a"];
	}else if(4 == value){
		return [CommonUtils colorWithHexString:@"#ffe600"];
	}else if(5 == value){
		return [CommonUtils colorWithHexString:@"#cfa972"];
	}else{
		return [CommonUtils colorWithHexString:@"#00bde6"];
	}
}

- (void)selectedPieChart:(EPieChart*)pieChart index:(NSInteger)index percent:(CGFloat)per
{
	selectedIndex = index;

	EPieDataModel* dataModel = [self.pieChartDatasArray objectAtIndex:index];
	[self.chartBottom setBottomLabelText:dataModel.label];
	[self.chartBottom setBottomValueText:dataModel.valueString];
}

- (void)pieChart:(EPieChart*)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
	self.chartBottom.bottomButton.enabled = YES;
}

- (void)pieChart:(EPieChart*)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
	self.chartBottom.bottomButton.enabled = NO;
}

@end
