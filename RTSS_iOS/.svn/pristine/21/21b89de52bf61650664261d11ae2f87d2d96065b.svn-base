//
//  BudgetDetailView.m
//  RTSS
//
//  Created by 加富董 on 15/2/4.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BudgetDetailView.h"
#import "CommonUtils.h"
#import "RTSSAppDefine.h"
#import "RTSSAppStyle.h"

#define BUDGET_DETAIL_VIEW_PADDING_X_LEFT 14.0
#define BUDGET_DETAIL_VIEW_PADDING_X_RIGHT 14.0
#define BUDGET_DETAIL_VIEW_SPACE_X 5.0

#define BUDGET_DETAIL_VIEW_ARROW_IMAGE_WIDTH 20.0
#define BUDGET_DETAIL_VIEW_ARROW_IMAGE_HEIGHT 20.0

#define BUDGET_DETAIL_VIEW_BAR_WIDTH 20.0
#define BUDGET_DETAIL_VIEW_BAR_HEIGHT 20.0

#define BUDGET_DETAIL_VIEW_PROPERTY_NAME_FONT_SIZE 18.0
#define BUDGET_DETAIL_VIEW_PROPERTY_VALUE_FONT_SIZE 16.0


@interface BudgetDetailView () {

}
@end

@implementation BudgetDetailView

@synthesize fieldNameLabel;
@synthesize arrowImageView;
@synthesize seperatorLineImageView;
@synthesize showArrow;

#pragma mark dealloc
- (void)dealloc {
    [arrowImageView release];
    [seperatorLineImageView release];
    [super dealloc];
}

#pragma mark init
- (id)initWithFrame:(CGRect)frame showArrow:(BOOL)arrow {
    if (self = [super initWithFrame:frame]) {
        self.showArrow = arrow;
        [self initViews];
    }
    return self;
}

#pragma mark loadViews
- (void)initViews {
    //field name
    CGRect fieldRect = CGRectMake(BUDGET_DETAIL_VIEW_PADDING_X_LEFT, 0.0, CGRectGetWidth(self.frame) - BUDGET_DETAIL_VIEW_PADDING_X_LEFT - BUDGET_DETAIL_VIEW_PADDING_X_RIGHT, CGRectGetHeight(self.frame) - SEPERATOR_LINE_HEIGHT);
    fieldNameLabel = [CommonUtils labelWithFrame:fieldRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[UIFont systemFontOfSize:BUDGET_DETAIL_VIEW_PROPERTY_NAME_FONT_SIZE] tag:0];
    fieldNameLabel.textAlignment = NSTextAlignmentLeft;
    fieldNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:fieldNameLabel];
    
    //arrow
    if (self.showArrow) {
        CGRect arrowRect = CGRectMake(CGRectGetWidth(self.frame) - BUDGET_DETAIL_VIEW_PADDING_X_RIGHT - BUDGET_DETAIL_VIEW_ARROW_IMAGE_WIDTH + 5.0, (CGRectGetHeight(self.frame) - BUDGET_DETAIL_VIEW_ARROW_IMAGE_HEIGHT - SEPERATOR_LINE_HEIGHT) / 2.0, BUDGET_DETAIL_VIEW_ARROW_IMAGE_WIDTH, BUDGET_DETAIL_VIEW_ARROW_IMAGE_HEIGHT);
        arrowImageView = [[UIImageView alloc] initWithFrame:arrowRect];
        arrowImageView.image = [UIImage imageNamed:@"common_next_arrow2"];
        [self addSubview:arrowImageView];
    }
    
    //seperator
    CGRect sepRect = CGRectMake(0.0, CGRectGetHeight(self.frame) - SEPERATOR_LINE_HEIGHT, PHONE_UISCREEN_WIDTH, SEPERATOR_LINE_HEIGHT);
    seperatorLineImageView = [[UIImageView alloc] initWithFrame:sepRect];
    seperatorLineImageView.image = [UIImage imageNamed:@"common_separator_line"];
    [self addSubview:seperatorLineImageView];
}

@end


@interface BudgetDetailBudgetView () {

}

@end

@implementation BudgetDetailBudgetView

@synthesize budgetValueLabel;

#pragma mark dealloc
- (void)dealloc {
    [super dealloc];
}

#pragma mark init
- (id)initWithFrame:(CGRect)frame showArrow:(BOOL)arrow {
    if (self = [super initWithFrame:frame showArrow:arrow]) {
        [self initViews];
    }
    return self;
}

#pragma mark loadViews
- (void)initViews {
    [super initViews];
    //value label
    CGFloat labelWidth = CGRectGetWidth(self.frame) - BUDGET_DETAIL_VIEW_PADDING_X_LEFT - BUDGET_DETAIL_VIEW_PADDING_X_RIGHT;
    if (self.showArrow) {
        labelWidth -= (BUDGET_DETAIL_VIEW_ARROW_IMAGE_WIDTH + BUDGET_DETAIL_VIEW_SPACE_X);
    }
    CGRect valueRect = CGRectMake(BUDGET_DETAIL_VIEW_PADDING_X_LEFT, 0.0, labelWidth, CGRectGetHeight(self.frame) - SEPERATOR_LINE_HEIGHT);
    budgetValueLabel = [CommonUtils labelWithFrame:valueRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[UIFont systemFontOfSize:BUDGET_DETAIL_VIEW_PROPERTY_VALUE_FONT_SIZE] tag:0];
    budgetValueLabel.textAlignment = NSTextAlignmentRight;
    budgetValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:budgetValueLabel];
}

@end



@interface BudgetDetailNotifyView () {

}

@end

@implementation BudgetDetailNotifyView

@synthesize budgetNotifyLabel;

#pragma mark dealloc
- (void)dealloc {
    [super dealloc];
}

#pragma mark init
- (id)initWithFrame:(CGRect)frame showArrow:(BOOL)arrow {
    if (self = [super initWithFrame:frame showArrow:arrow]) {
        [self initViews];
    }
    return self;
}

#pragma mark loadViews
- (void)initViews {
    [super initViews];
    //notify label
    CGFloat labelWidth = CGRectGetWidth(self.frame) - BUDGET_DETAIL_VIEW_PADDING_X_LEFT - BUDGET_DETAIL_VIEW_PADDING_X_RIGHT;
    if (self.showArrow) {
        labelWidth -= (BUDGET_DETAIL_VIEW_ARROW_IMAGE_WIDTH + BUDGET_DETAIL_VIEW_SPACE_X);
    }
    CGRect notifyRect = CGRectMake(BUDGET_DETAIL_VIEW_PADDING_X_LEFT, 0.0, labelWidth, CGRectGetHeight(self.frame) - SEPERATOR_LINE_HEIGHT);
    budgetNotifyLabel = [CommonUtils labelWithFrame:notifyRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[RTSSAppStyle getRTSSFontWithSize:BUDGET_DETAIL_VIEW_PROPERTY_VALUE_FONT_SIZE] tag:0];
    budgetNotifyLabel.textAlignment = NSTextAlignmentRight;
    budgetNotifyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:budgetNotifyLabel];
}


@end

@interface BudgetDetailBarView () {
    
}

@end


@implementation BudgetDetailBarView

@synthesize budgetBarButton;

#pragma mark dealloc
- (void)dealloc {
    [super dealloc];
}

#pragma mark init
- (id)initWithFrame:(CGRect)frame showArrow:(BOOL)arrow {
    if (self = [super initWithFrame:frame showArrow:arrow]) {
        [self initViews];
    }
    return self;
}

#pragma mark loadViews
- (void)initViews {
    [super initViews];
    //bar
    CGFloat barOffsetX = CGRectGetWidth(self.frame) - BUDGET_DETAIL_VIEW_PADDING_X_RIGHT - BUDGET_DETAIL_VIEW_BAR_WIDTH;
    if (self.showArrow) {
        barOffsetX -= (BUDGET_DETAIL_VIEW_ARROW_IMAGE_WIDTH + BUDGET_DETAIL_VIEW_SPACE_X);
    }
    CGRect barRect = CGRectMake(barOffsetX, (CGRectGetHeight(self.frame) - BUDGET_DETAIL_VIEW_BAR_HEIGHT - SEPERATOR_LINE_HEIGHT) / 2.0, BUDGET_DETAIL_VIEW_BAR_WIDTH, BUDGET_DETAIL_VIEW_BAR_HEIGHT);
    budgetBarButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:barRect title:nil imageNormal:[UIImage imageNamed:@"common_checked_d"] imageHighlighted:[UIImage imageNamed:@"common_checked_a"] imageSelected:[UIImage imageNamed:@"common_checked_a"] addTarget:nil action:nil tag:0];
    budgetBarButton.selected = NO;
    [self addSubview:budgetBarButton];
}

@end