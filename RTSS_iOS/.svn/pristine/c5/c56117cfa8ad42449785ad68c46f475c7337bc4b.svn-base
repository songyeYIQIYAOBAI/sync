//
//  FindItemView.m
//  SJB2
//
//  Created by shengyp on 14-5-19.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import "FindItemView.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"

@implementation TagButton

@synthesize tagModel;

#pragma mark dealloc
- (void)dealloc {
    self.tagModel = nil;
    
    [super dealloc];
}

@end



@implementation ActionOptionView

@synthesize actionButton,valueLabel,value,actionType,iconImageView;
#pragma mark dealloc
- (void)dealloc {
    self.value = nil;
    [iconImageView release];
    
    [super dealloc];
}

#pragma mark setter
- (void)setValue:(NSString *)val {
    if (value != val) {
        [value release];
        value = [val retain];
    }
    valueLabel.text = value;
}

#pragma mark init
- (id)initWithFrame:(CGRect)frame type:(ActionOptionType)type {
    if (self = [super initWithFrame:frame]) {
        actionType = type;
        [self loadViews];
        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark init views
- (void)loadViews {
    if (actionType == ActionOptionTypePraise || actionType == ActionOptionTypeCollect) {
        iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        iconImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:iconImageView];
    }
    
    if (actionType == ActionOptionTypeComment || actionType == ActionOptionTypePraise) {
        valueLabel = [CommonUtils labelWithFrame:CGRectZero text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[UIFont systemFontOfSize:10.0] tag:0];
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.textAlignment = NSTextAlignmentLeft;
        valueLabel.lineBreakMode = NSLineBreakByWordWrapping;
        valueLabel.numberOfLines = 1;
        valueLabel.adjustsFontSizeToFitWidth = YES;
        valueLabel.minimumScaleFactor = 5.0;
        [self addSubview:valueLabel];
    }
    actionButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:CGRectZero title:nil bgImageNormal:nil bgImageHighlighted:nil bgImageSelected:nil addTarget:nil action:nil tag:actionType];
    actionButton.selected = NO;
    [self addSubview:actionButton];
}

@end



@implementation ActionsPanelView

@synthesize commentView,shareView,praiseView,collectView;

#pragma mark dealloc
- (void)dealloc {
    [commentView release];
    [shareView release];
    [praiseView release];
    [collectView release];
    
    [super dealloc];
}

#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadActionOptions];
    }
    return self;
}

- (void)loadActionOptions {
    //comment
    commentView = [[ActionOptionView alloc] initWithFrame:CGRectZero type:ActionOptionTypeComment];
    commentView.backgroundColor = [UIColor clearColor];
    [self addSubview:commentView];
    
    //share
    shareView = [[ActionOptionView alloc] initWithFrame:CGRectZero type:ActionOptionTypeShare];
    shareView.backgroundColor = [UIColor clearColor];
    [self addSubview:shareView];
    
    //praise
    praiseView = [[ActionOptionView alloc] initWithFrame:CGRectZero type:ActionOptionTypePraise];
    praiseView.backgroundColor = [UIColor clearColor];
    [self addSubview:praiseView];
    
    //collect
    collectView = [[ActionOptionView alloc] initWithFrame:CGRectZero type:ActionOptionTypeCollect];
    collectView.backgroundColor = [UIColor clearColor];
    [self addSubview:collectView];
}

@end



@implementation FindItemView
@synthesize itemIconImageView,itemPicImageView,itemNameLabel,itemDateLabel,itemTitleLabel,itemDescriptionTextView,itemTypeButton;
@synthesize itemTagImageView,itemTagsView,itemSepLineImageView,itemActionsPanelView;

- (void)dealloc
{
	[itemIconImageView release];
	[itemPicImageView release];
	
	[itemNameLabel release];
	[itemDateLabel release];
	[itemTitleLabel release];
	
	[itemDescriptionTextView release];
	
	[itemTypeButton release];
    
    [itemTagImageView release];
    [itemTagsView release];
    [itemSepLineImageView release];
    [itemActionsPanelView release];
	
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self layoutContent:frame];
    }
    return self;
}

- (UILabel*)layoutLabel:(CGRect)aFrame font:(UIFont*)font color:(UIColor*)color
{
    UILabel *templateLabel = [CommonUtils labelWithFrame:aFrame text:nil textColor:color textFont:font tag:0];
    templateLabel.backgroundColor = [UIColor clearColor];
    templateLabel.numberOfLines = 1;
	templateLabel.adjustsFontSizeToFitWidth = YES;
    templateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    templateLabel.textAlignment = NSTextAlignmentLeft;
    return templateLabel;
}

- (UITextView*)layoutTextView:(CGRect)aFrame font:(UIFont*)font textColor:(UIColor*)color
{
	UITextView* textView = [[[UITextView alloc] initWithFrame:aFrame] autorelease];
	textView.backgroundColor = [UIColor clearColor];
	textView.editable = NO;
	textView.font = font;
	textView.textColor = color;
	textView.textAlignment = NSTextAlignmentLeft;
	textView.contentInset = UIEdgeInsetsZero;
	textView.showsHorizontalScrollIndicator = NO;
	textView.showsVerticalScrollIndicator = NO;
	textView.scrollEnabled = NO;
	
	return textView;
}

- (UIButton*)layoutButton:(CGRect)aFrame font:(UIFont*)font textColor:(UIColor*)norColor textLightedColor:(UIColor*)lightedColor
{
    UIButton *button = [CommonUtils buttonWithType:UIButtonTypeCustom frame:aFrame title:nil bgImageNormal:nil bgImageHighlighted:nil bgImageSelected:nil addTarget:nil action:nil tag:0];
	button.titleLabel.font = font;
	[button setTitleColor:norColor 	   forState:UIControlStateNormal];
	[button setTitleColor:lightedColor forState:UIControlStateHighlighted];
	
	return button;
}

- (void)layoutContent:(CGRect)frame
{
	self.backgroundColor = [RTSSAppStyle currentAppStyle].textFieldBgColor;
	
	// 边框 圆角
	self.layer.borderWidth = 0.5;
	self.layer.borderColor = [RTSSAppStyle currentAppStyle].textFieldBorderColor.CGColor;
	self.layer.cornerRadius = 8;
	self.clipsToBounds = YES;
	
	// 发现ICON
	self.itemIconImageView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
	[self addSubview:self.itemIconImageView];
	
	// 发现名字
	self.itemNameLabel = [self layoutLabel:CGRectZero font:[UIFont systemFontOfSize:15.0] color:[RTSSAppStyle currentAppStyle].textMajorColor];
	self.itemNameLabel.backgroundColor = [UIColor clearColor];
	self.itemNameLabel.numberOfLines = 2;
	self.itemNameLabel.adjustsFontSizeToFitWidth = NO;
	[self addSubview:self.itemNameLabel];
	
	// 发现日期
	self.itemDateLabel = [self layoutLabel:CGRectZero font:[UIFont systemFontOfSize:14.0] color:[RTSSAppStyle currentAppStyle].textMajorColor];
	self.itemDateLabel.textAlignment = NSTextAlignmentRight;
	self.itemDateLabel.backgroundColor = [UIColor clearColor];
	[self addSubview:self.itemDateLabel];
	
	// 发现图片
	self.itemPicImageView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
	self.itemPicImageView.contentMode = UIViewContentModeScaleAspectFit;
	[self addSubview:self.itemPicImageView];
	
	// 发现标题
	self.itemTitleLabel = [self layoutLabel:CGRectZero font:[UIFont systemFontOfSize:15.0] color:[RTSSAppStyle currentAppStyle].textMajorColor];
	self.itemTitleLabel.backgroundColor = [UIColor clearColor];
	[self addSubview:self.itemTitleLabel];
	
	// 发现描述
	self.itemDescriptionTextView = [self layoutTextView:CGRectZero font:FindItemDescFont textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor];
	[self addSubview:self.itemDescriptionTextView];
	
	// 发现点击查看详情]
	self.itemTypeButton = [self layoutButton:CGRectZero font:FindItemDescFont
								   textColor:[RTSSAppStyle currentAppStyle].textMajorColor
							textLightedColor:[RTSSAppStyle currentAppStyle].textSubordinateColor];
	[self addSubview:self.itemTypeButton];
    
    // 发现tag icon
    self.itemTagImageView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
    itemTagImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:itemTagImageView];
    
    // 发现tags view
    self.itemTagsView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    itemTagsView.backgroundColor = [UIColor clearColor];
    [self addSubview:itemTagsView];
    
    // 发现sep line
    self.itemSepLineImageView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
    itemSepLineImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:itemSepLineImageView];
    
    // 发现action view
    self.itemActionsPanelView = [[[ActionsPanelView alloc] initWithFrame:CGRectZero] autorelease];
    itemActionsPanelView.backgroundColor = [UIColor clearColor];
    [self addSubview:itemActionsPanelView];
    
}



@end
