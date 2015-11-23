//
//  EColumnChartView.m
//  IOS7Test
//
//  Created by shengyp on 14-6-20.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "EColumnChartView.h"
#import "EColumnDataModel.h"
#import "DateUtils.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"
#import "UsageModel.h"

#define LEGEND_ITEM_NAME_LABEL_FONT         [RTSSAppStyle getRTSSFontWithSize:10.0f] 
#define LEGEND_ITEM_NAME_LABEL_WIDTH        40
#define LEGEND_ITEM_NAME_LABEL_SPACE        5

@implementation LegendItemView
@synthesize boxView, nameLabel;

- (void)dealloc
{
    [boxView release];
    [nameLabel release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.boxView = [[[UIView alloc] initWithFrame:CGRectMake(0, (self.bounds.size.height-6)/2, 6, 6)] autorelease];
        [self addSubview:self.boxView];
        
        self.nameLabel = [CommonUtils labelWithFrame:CGRectMake(CGRectGetMaxX(self.boxView.frame)+5, 0, LEGEND_ITEM_NAME_LABEL_WIDTH, self.bounds.size.height) text:@"" textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:LEGEND_ITEM_NAME_LABEL_FONT tag:10];
        [self addSubview:self.nameLabel];
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, CGRectGetMaxX(self.nameLabel.frame), self.bounds.size.height);
    }
    return self;
}

- (void)setNameLabelText:(NSString*)text
{
    if([CommonUtils objectIsValid:text]){
        self.nameLabel.text = text;
        
        CGSize labelSize = [CommonUtils calculateTextSize:text constrainedSize:CGSizeMake(MAXFLOAT, self.bounds.size.height) textFont:LEGEND_ITEM_NAME_LABEL_FONT lineBreakMode:NSLineBreakByWordWrapping];
        
        if(labelSize.width > LEGEND_ITEM_NAME_LABEL_WIDTH){
            CGRect labelRect = self.nameLabel.frame;
            labelRect.size.width = labelSize.width+5;
            self.nameLabel.frame = labelRect;
            
            CGRect rect = self.frame;
            rect.size.width = CGRectGetMaxX(self.nameLabel.frame);
            self.frame = rect;
        }
    }
}

@end

@interface LegendScrollerView()

@property(nonatomic, retain)UIScrollView*    legendScrollView;
@property(nonatomic, retain)UIView*          legendScrollContextView;

@end

@implementation LegendScrollerView
@synthesize dataSource,legendScrollView,legendScrollContextView;

- (void)dealloc
{
    [legendScrollView release];
    [legendScrollContextView release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        self.legendScrollView = scrollView;
        [self addSubview:self.legendScrollView];
        [scrollView release];
        
        UIView* contextView = [[UIView alloc] initWithFrame:self.bounds];
        contextView.backgroundColor = [UIColor clearColor];
        self.legendScrollContextView = contextView;
       [self.legendScrollView addSubview:self.legendScrollContextView];
        [contextView release];
        
    }
    return self;
}

- (void)reloadLegenData
{
    if(nil == dataSource ||
       NO == [dataSource respondsToSelector:@selector(numberOfLegendInScrollerView)] ||
       NO == [dataSource respondsToSelector:@selector(getLegendColorAtIndex:)] ||
       NO == [dataSource respondsToSelector:@selector(getLegendTextAtIndex:)]){
        return;
    }
    
    if(nil != self.legendScrollContextView){
        [[self.legendScrollContextView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    CGFloat itemHeight          = self.bounds.size.height;
    NSInteger count             = [self.dataSource numberOfLegendInScrollerView];
    
    CGFloat contextViewWith = 0;
    for (int i = 0; i < count; i ++) {
        LegendItemView* itemView = [[LegendItemView alloc] initWithFrame:CGRectMake(contextViewWith, 0, 0, itemHeight)];
        itemView.boxView.backgroundColor = [dataSource getLegendColorAtIndex:i];
        [itemView setNameLabelText:[dataSource getLegendTextAtIndex:i]];
        [self.legendScrollContextView addSubview:itemView];
        
        contextViewWith += itemView.frame.size.width;
        
        [itemView release];
    }
    
    CGRect contextViewRect = self.legendScrollContextView.frame;
    contextViewRect.size.width = contextViewWith;
    if(contextViewWith < self.bounds.size.width){
        contextViewRect.origin.x = self.bounds.size.width-contextViewWith;
    }else{
        contextViewRect.origin.x = 0;
    }
    self.legendScrollContextView.frame = contextViewRect;
    
    self.legendScrollView.contentSize = self.legendScrollContextView.bounds.size;
}

@end


@interface EColumnChartView()

@property(nonatomic, readonly) EColumnChart*            eColumnChart;
@property(nonatomic, readonly) LegendScrollerView*      legendScrollerView;
@property(nonatomic, retain) NSMutableArray*            columnChartArray;

@end

@implementation EColumnChartView
@synthesize eColumnChart,legendScrollerView,columnChartArray;

- (void)dealloc
{
	[eColumnChart release];
    [legendScrollerView release];
	[columnChartArray release];
	
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
        
        legendScrollerView = [[LegendScrollerView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 15)];
        legendScrollerView.backgroundColor = [UIColor clearColor];
        legendScrollerView.dataSource = self;
        [self addSubview:legendScrollerView];
		
		eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(0, 25, frame.size.width, frame.size.height-25)];
		eColumnChart.backgroundColor = [UIColor clearColor];
        eColumnChart.scaleLineColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
        eColumnChart.labelColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
		eColumnChart.dataSource = self;
		[self addSubview:eColumnChart];
    }
    return self;
}

- (void)reloadChartData:(NSMutableArray*)dataArray isHiddenLegend:(BOOL)legend
{
	self.columnChartArray = dataArray;
    if(!legend){
        [legendScrollerView reloadLegenData];
    }
	[eColumnChart reloadDataWithAnimation:YES];
}

- (void)scrollToLast:(BOOL)animated
{
    [eColumnChart scrollToLast:animated];
}

#pragma mark LegendScrollerViewDataSource
- (NSInteger)numberOfLegendInScrollerView
{
    NSInteger number = 0;
    if([CommonUtils objectIsValid:self.columnChartArray]){
        number = [[self.columnChartArray objectAtIndex:0] count];
    }
    return number;
}

- (UIColor*)getLegendColorAtIndex:(NSInteger)index
{
    return [RTSSAppStyle getFreeResourceColorWithIndex:index];
}

- (NSString*)getLegendTextAtIndex:(NSInteger)index
{
    EColumnDataModel* itemModel = [[self.columnChartArray objectAtIndex:0] objectAtIndex:index];
    NSString *name = itemModel.name;
    NSString *unit = [UsageModel unitByMessureId:itemModel.messureId];
    return  [unit length]>0?[NSString stringWithFormat:@"%@(%@)",name,unit]:name;

}

#pragma mark EColumnChartDataSource
- (NSInteger)numberOfSectionsInEColumnChart:(EColumnChart*)eColumnChart
{
    return [self.columnChartArray count];
}

- (NSInteger)eColumnChart:(EColumnChart*)eColumnChart numberOfRowsInSection:(NSInteger)section
{
    return [[self.columnChartArray objectAtIndex:section] count];
}

- (CGFloat)eColumnChart:(EColumnChart*)eColumnChart horizontalGapInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)eColumnChart:(EColumnChart*)eColumnChart widthOfColumnAtIndexPath:(NSIndexPath*)indexPath
{
    return 8;
}

- (CGFloat)eColumnChart:(EColumnChart*)eColumnChart withOfItemAtIndexPath:(NSIndexPath*)indexPath
{
    return 16;
}

- (UIColor*)eColumnChart:(EColumnChart*)eColumnChart colorForColumnAtIndexPath:(NSIndexPath*)indexPath
{
    return [RTSSAppStyle getFreeResourceColorWithIndex:indexPath.row];
}

- (CGFloat)eColumnChart:(EColumnChart *)eColumnChart highestValueAtIndexPath:(NSIndexPath*)indexPath
{
    EColumnDataModel* itemModel = [[self.columnChartArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return itemModel.maxValue;
}

- (EColumnDataModel*)eColumnChart:(EColumnChart*)eColumnChart valueAtIndexPath:(NSIndexPath*)indexPath
{
    return [[self.columnChartArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

@end
