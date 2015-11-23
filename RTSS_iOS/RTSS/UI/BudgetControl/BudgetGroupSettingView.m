//
//  BudgetGroupSettingView.m
//  RTSS
//
//  Created by 加富董 on 15/1/28.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BudgetGroupSettingView.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"
#import "PortraitImageView.h"
#import "RTSSAppDefine.h"

#define SET_VIEW_PADDING_X_LEFT 14.0
#define SET_VIEW_PADDING_X_RIGHT 14.0
#define SET_VIEW_SPACE_X 5.0

#define SET_VIEW_ARROW_IMAGE_WIDTH 20.0
#define SET_VIEW_ARROW_IMAGE_HEIGHT 20.0

#define SET_VIEW_PORTRAIT_IMAGE_WIDTH 40.0
#define SET_VIEW_PORTRAIT_IMAGE_HEIGHT 40.0

#define SET_VIEW_PROPERTY_NAME_FONT_SIZE 18.0
#define SET_VIEW_PROPERTY_VALUE_FONT_SIZE 16.0

@implementation BudgetGroupSettingView

@synthesize editable;
@synthesize propertyNameLable;
@synthesize accessoryArrowImageView;
@synthesize seperatorImageView;

#pragma mark dealloc
- (void)dealloc {
    [accessoryArrowImageView release];
    [seperatorImageView release];
    [super dealloc];
}

#pragma mark init
- (id)initWithFrame:(CGRect)frame editable:(BOOL)edit {
    if (self = [super initWithFrame:frame]) {
        self.editable = edit;
    }
    return self;
}

- (void)initViews {
    //property name
    CGRect propertyNameRect = CGRectMake(SET_VIEW_PADDING_X_LEFT, 0.0, CGRectGetWidth(self.frame) - SET_VIEW_PADDING_X_LEFT - SET_VIEW_PADDING_X_RIGHT, (CGRectGetHeight(self.frame) - SEPERATOR_LINE_HEIGHT));
    propertyNameLable = [CommonUtils labelWithFrame:propertyNameRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[UIFont systemFontOfSize:SET_VIEW_PROPERTY_NAME_FONT_SIZE] tag:0];
    propertyNameLable.backgroundColor = [UIColor clearColor];
    propertyNameLable.textAlignment = NSTextAlignmentLeft;
    [self addSubview:propertyNameLable];
    
    //arrow
    if (editable) {
        CGRect arrowRect = CGRectMake(CGRectGetWidth(self.frame) - SET_VIEW_PADDING_X_RIGHT - SET_VIEW_ARROW_IMAGE_WIDTH + 5, (CGRectGetHeight(self.frame) - SET_VIEW_ARROW_IMAGE_HEIGHT - SEPERATOR_LINE_HEIGHT) / 2.0, SET_VIEW_ARROW_IMAGE_WIDTH, SET_VIEW_ARROW_IMAGE_HEIGHT);
        accessoryArrowImageView = [[UIImageView alloc] initWithFrame:arrowRect];
        accessoryArrowImageView.image = [UIImage imageNamed:@"common_next_arrow2"];
        [self addSubview:accessoryArrowImageView];
    }
    
    //seperator
    CGRect sepRect = CGRectMake(0.0, CGRectGetHeight(self.frame) - SEPERATOR_LINE_HEIGHT, CGRectGetWidth(self.frame), SEPERATOR_LINE_HEIGHT);
    seperatorImageView = [[UIImageView alloc] initWithFrame:sepRect];
    seperatorImageView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self addSubview:seperatorImageView];
}

@end




@implementation BudgetGroupSetNameView

@synthesize groupNameLabel;

#pragma mark dealloc
- (void)dealloc {
    [super dealloc];
}

#pragma mark init view
- (id)initWithFrame:(CGRect)frame editable:(BOOL)edit {
    if (self = [super initWithFrame:frame editable:edit]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [super initViews];
    //group name
    CGFloat nameLabelWidth = CGRectGetWidth(self.frame) - SET_VIEW_PADDING_X_LEFT - SET_VIEW_PADDING_X_RIGHT;
    if (self.editable) {
        nameLabelWidth -= (SET_VIEW_ARROW_IMAGE_WIDTH + SET_VIEW_SPACE_X);
    }
    CGRect nameRect = CGRectMake(SET_VIEW_PADDING_X_LEFT, 0.0, nameLabelWidth, CGRectGetHeight(self.frame) - SEPERATOR_LINE_HEIGHT);
    groupNameLabel = [CommonUtils labelWithFrame:nameRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[RTSSAppStyle getRTSSFontWithSize:SET_VIEW_PROPERTY_VALUE_FONT_SIZE] tag:0];
    groupNameLabel.backgroundColor = [UIColor clearColor];
    groupNameLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:groupNameLabel];
}

@end




@implementation BudgetGroupSetPhotoView

@synthesize groupPortraitImageView;

#pragma mark dealloc
- (void)dealloc {
    [groupPortraitImageView release];
    [super dealloc];
}

#pragma mark init view
- (id)initWithFrame:(CGRect)frame editable:(BOOL)edit {
    if (self = [super initWithFrame:frame editable:edit]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [super initViews];
    //group portrait
    CGFloat imageOriginX = CGRectGetWidth(self.frame) - SET_VIEW_PADDING_X_RIGHT - SET_VIEW_PORTRAIT_IMAGE_WIDTH;
    if (self.editable) {
        imageOriginX -= (SET_VIEW_ARROW_IMAGE_WIDTH + SET_VIEW_SPACE_X);
    }
    CGRect imageRect = CGRectMake(imageOriginX, (CGRectGetHeight(self.frame) - SET_VIEW_PORTRAIT_IMAGE_HEIGHT - SEPERATOR_LINE_HEIGHT) / 2.0, SET_VIEW_PORTRAIT_IMAGE_WIDTH, SET_VIEW_PORTRAIT_IMAGE_HEIGHT);
    groupPortraitImageView = [[PortraitImageView alloc] initWithFrame:imageRect image:nil borderColor:[[RTSSAppStyle currentAppStyle] portraitBorderColor] borderWidth:1.0];
    groupPortraitImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:groupPortraitImageView];
}

@end




@implementation BudgetGroupSetTypeView

@synthesize groupTypeLabel;

#pragma mark dealloc
- (void)dealloc {
    [super dealloc];
}

#pragma mark init view
- (id)initWithFrame:(CGRect)frame editable:(BOOL)edit {
    if (self = [super initWithFrame:frame editable:edit]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [super initViews];
    //group type
    CGFloat typeLabelWidth = CGRectGetWidth(self.frame) - SET_VIEW_PADDING_X_LEFT - SET_VIEW_PADDING_X_RIGHT;
    if (self.editable) {
        typeLabelWidth -= (SET_VIEW_ARROW_IMAGE_WIDTH + SET_VIEW_SPACE_X);
    }
    CGRect typeRect = CGRectMake(SET_VIEW_PADDING_X_LEFT, 0.0, typeLabelWidth, CGRectGetHeight(self.frame) - SEPERATOR_LINE_HEIGHT);
    groupTypeLabel = [CommonUtils labelWithFrame:typeRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[RTSSAppStyle getRTSSFontWithSize:SET_VIEW_PROPERTY_VALUE_FONT_SIZE] tag:0];
    groupTypeLabel.backgroundColor = [UIColor clearColor];
    groupTypeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:groupTypeLabel];
}

@end




@implementation BudgetGroupSetResourceView

@synthesize groupResourceLabel;

#pragma mark dealloc
- (void)dealloc {
    [super dealloc];
}

#pragma mark init view
- (id)initWithFrame:(CGRect)frame editable:(BOOL)edit {
    if (self = [super initWithFrame:frame editable:edit]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [super initViews];
    //group resourch
    CGFloat resourceLabelWidth = CGRectGetWidth(self.frame) - SET_VIEW_PADDING_X_LEFT - SET_VIEW_PADDING_X_RIGHT;
    if (self.editable) {
        resourceLabelWidth -= (SET_VIEW_ARROW_IMAGE_WIDTH + SET_VIEW_SPACE_X);
    }
    CGRect budgetRect = CGRectMake(SET_VIEW_PADDING_X_LEFT, 0.0, resourceLabelWidth, CGRectGetHeight(self.frame) - SEPERATOR_LINE_HEIGHT);
    groupResourceLabel = [CommonUtils labelWithFrame:budgetRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[RTSSAppStyle getRTSSFontWithSize:SET_VIEW_PROPERTY_VALUE_FONT_SIZE] tag:0];
    groupResourceLabel.backgroundColor = [UIColor clearColor];
    groupResourceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:groupResourceLabel];
}

@end



@implementation BudgetGroupSetBudgetView

@synthesize groupBudgetLabel;

#pragma mark dealloc
- (void)dealloc {
    [super dealloc];
}

#pragma mark init view
- (id)initWithFrame:(CGRect)frame editable:(BOOL)edit {
    if (self = [super initWithFrame:frame editable:edit]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [super initViews];
    //group budget
    CGFloat budgetLabelWidth = CGRectGetWidth(self.frame) - SET_VIEW_PADDING_X_LEFT - SET_VIEW_PADDING_X_RIGHT;
    if (self.editable) {
        budgetLabelWidth -= (SET_VIEW_ARROW_IMAGE_WIDTH + SET_VIEW_SPACE_X);
    }
    CGRect budgetRect = CGRectMake(SET_VIEW_PADDING_X_LEFT, 0.0, budgetLabelWidth, CGRectGetHeight(self.frame) - SEPERATOR_LINE_HEIGHT);
    groupBudgetLabel = [CommonUtils labelWithFrame:budgetRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[RTSSAppStyle getRTSSFontWithSize:SET_VIEW_PROPERTY_VALUE_FONT_SIZE] tag:0];
    groupBudgetLabel.backgroundColor = [UIColor clearColor];
    groupBudgetLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:groupBudgetLabel];
}


@end