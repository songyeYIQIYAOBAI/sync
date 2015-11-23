//
//  SlideOptionsView.m
//  RTSS
//
//  Created by 加富董 on 14/11/26.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "SlideOptionsView.h"
#import "CommonUtils.h"
#import "RTSSAppDefine.h"
#import "RTSSAppStyle.h"

#define OPTION_TITLE_FONT_SIZE 16.0
#define VIEW_PADDING_X 14.0
#define OPTION_WRAP_SPACE_X 5.0
#define OPTION_SPACE_X 10.0
#define SLIDE_INDICATOR_HEIGHT 3.0
#define SLIDE_INDICATOR_CORNER_RADIUS 1.0
#define OPTION_MOVE_ANIMATION_DURATION 0.2

#define OPTION_VIEW_BASE_TAG 100


@interface OptionView () {

}

@property (nonatomic,retain) NSString *optionTitle;

@end

@implementation OptionView

@synthesize optionButton;
@synthesize optionTitle;
@synthesize optionIndex;

#pragma mark dealloc
- (void)dealloc {
    [optionTitle release];
    [super dealloc];
}

#pragma mark init
- (id)initWithFrame:(CGRect)frame optionTitle:(NSString *)title index:(int)index {
    if (self = [super initWithFrame:frame]) {
        self.optionTitle = title;
        self.optionIndex = index;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    //这里为增大button的点击范围，暂不痛过减小width的方式来添加边距。而是设定edge的方式
//    CGRect buttonFrame = CGRectMake(OPTION_WRAP_SPACE_X, 0.f, CGRectGetWidth(self.frame) - OPTION_WRAP_SPACE_X * 2.0, CGRectGetHeight(self.frame));
    CGRect buttonFrame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    optionButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:buttonFrame title:self.optionTitle bgImageNormal:nil bgImageHighlighted:nil bgImageSelected:nil addTarget:nil action:nil tag:optionIndex + OPTION_VIEW_BASE_TAG];
    [optionButton setTitleEdgeInsets:UIEdgeInsetsMake(0.f, OPTION_WRAP_SPACE_X, 0.f, OPTION_WRAP_SPACE_X)];
    optionButton.titleLabel.font = [UIFont systemFontOfSize:OPTION_TITLE_FONT_SIZE];
    [optionButton setTitleColor:[[RTSSAppStyle currentAppStyle] textMajorGreenColor] forState:UIControlStateSelected];
    [optionButton setTitleColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] forState:UIControlStateNormal];
    [self addSubview:optionButton];
}

#pragma mark reset
- (void)resetSelectedStatus {
    self.optionButton.selected = NO;
}

@end



@interface SlideOptionsView () {
    UIView *optionsView;
    UIView *indicatorView;
    //当前选中的索引
    int currentSelectedIndex;
    //与其联动的页面的宽度
    CGFloat gangedPageWidth;
    //标记包含的所有option view是否都能够完全显示
    CGFloat optionsTotalWidth;
    BOOL allCanDisplay;
}


@end

@implementation SlideOptionsView

@synthesize optionTitlesArr;
@synthesize optionViewsArray;
@synthesize indicatorOrginsArray;
@synthesize delegate;

#pragma mark dealloc
- (void)dealloc {
    [optionTitlesArr release];
    [optionViewsArray release];
    [indicatorOrginsArray release];
    [optionsView release];
    [indicatorView release];
    [super dealloc];
}

#pragma mark init view
- (id)initWithFrame:(CGRect)frame optionTiltes:(NSArray *)optionTitles gangedPageWidth:(CGFloat)pageWidth {
    if (self = [super initWithFrame:frame]) {
        optionTitlesArr = [optionTitles retain];
        currentSelectedIndex = 0;
        gangedPageWidth = pageWidth;
        if ([CommonUtils objectIsValid:optionTitlesArr]) {
            [self loadView];
        }
    }
    return self;
}

- (void)loadView {
    [self loadOptionsView];
    [self loadSlideIndicatorView];
}

- (void)loadOptionsView {
    optionsView =[[UIView alloc] initWithFrame:CGRectZero];
    optionsView.backgroundColor = [UIColor clearColor];
    [self addSubview:optionsView];
    
    //create options
    optionsTotalWidth = CGRectGetWidth(self.frame);
    optionViewsArray = [[NSMutableArray alloc] initWithCapacity:0];
    CGFloat formerOptionViewX = VIEW_PADDING_X;
    for (int i = 0; i < [optionTitlesArr count]; i ++) {
        NSString *title = [optionTitlesArr objectAtIndex:i];
        CGFloat textWidth = [CommonUtils calculateTextSize:title constrainedSize:CGSizeMake(CGFLOAT_MAX, OPTION_TITLE_FONT_SIZE) textFontSize:OPTION_TITLE_FONT_SIZE lineBreakMode:NSLineBreakByWordWrapping].width;
        CGFloat optionViewWidth = textWidth + OPTION_WRAP_SPACE_X * 2.0;
        CGRect optionViewRect = CGRectMake(formerOptionViewX, 0.f, optionViewWidth, CGRectGetHeight(self.frame) - SLIDE_INDICATOR_HEIGHT);
        OptionView *optionView = [[OptionView alloc] initWithFrame:optionViewRect optionTitle:title index:i];
        optionView.backgroundColor = [UIColor clearColor];
        [optionView.optionButton addTarget:self action:@selector(optionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [optionsView addSubview:optionView];
        [optionViewsArray addObject:optionView];
        [optionView release];
        formerOptionViewX = CGRectGetMaxX(optionViewRect) + OPTION_SPACE_X;
        //设置默认选中状态
        if (i == 0) {
            optionView.optionButton.selected = YES;
        } else {
            optionView.optionButton.selected = NO;
        }
        //option 宽度总和
        if (i == [optionTitlesArr count] - 1) {
            optionsTotalWidth = CGRectGetMaxX(optionViewRect) + VIEW_PADDING_X;
            NSLog(@"last option frame str====%@",NSStringFromCGRect(optionView.frame));
        }
    }
    
    //reset frame
    CGFloat finalWidth = optionsTotalWidth > CGRectGetWidth(self.frame) ? optionsTotalWidth : CGRectGetWidth(self.frame);
    allCanDisplay = optionsTotalWidth > CGRectGetWidth(self.frame) ? NO : YES;
    CGRect frame = CGRectMake(0., 0., finalWidth, CGRectGetHeight(self.frame) - SLIDE_INDICATOR_HEIGHT);
    optionsView.frame = frame;
    
    //origins
    CGFloat indicatorOriginX = VIEW_PADDING_X;
    indicatorOrginsArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < [optionTitlesArr count]; i ++) {
        if (i < [optionViewsArray count]) {
            OptionView *optionView = [optionViewsArray objectAtIndex:i];
            CGPoint origin = CGPointZero;
            if (allCanDisplay == NO) {
                if (i > 0) {
                    indicatorOriginX += [self convertOptionViewWidhtToIndicatorView:optionView];
                }
                origin = CGPointMake(indicatorOriginX, CGRectGetMaxY(optionView.frame));
            } else {
                origin = CGPointMake(optionView.frame.origin.x, CGRectGetMaxY(optionView.frame));
            }
            [indicatorOrginsArray addObject:[NSValue valueWithCGPoint:origin]];

        }
    }
}

- (void)loadSlideIndicatorView {
    OptionView *currentSelOptionView = [optionViewsArray objectAtIndex:currentSelectedIndex];
    if (currentSelOptionView) {
        CGRect frame = currentSelOptionView.frame;
        CGRect indicatorFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMaxY(frame), CGRectGetWidth(frame), SLIDE_INDICATOR_HEIGHT);
        indicatorView = [[UIView alloc] initWithFrame:indicatorFrame];
        indicatorView.backgroundColor = [[RTSSAppStyle currentAppStyle] commonGreenButtonNormalColor];
        indicatorView.layer.cornerRadius = SLIDE_INDICATOR_CORNER_RADIUS;
        indicatorView.layer.masksToBounds = YES;
        [self addSubview:indicatorView];
    }
}


- (CGFloat)convertOptionViewWidhtToIndicatorView:(OptionView *)optionView {
    CGFloat additonalDistance = 0.0;
    if (optionView) {
        int optionIndex = optionView.optionIndex;
        if (optionIndex > 0) {
            OptionView *firstOptionView = [optionViewsArray objectAtIndex:0];
            OptionView *formerOptionView = [optionViewsArray objectAtIndex:optionIndex - 1];
            OptionView *lastOptionView = [optionViewsArray lastObject];
            CGFloat moveDistance = CGRectGetWidth(self.frame) - CGRectGetWidth(lastOptionView.frame) - VIEW_PADDING_X * 2.0;
            CGFloat optionsWidth = optionsTotalWidth - CGRectGetWidth(lastOptionView.frame) - CGRectGetMinX(firstOptionView.frame) - VIEW_PADDING_X;
            CGFloat perDistance = moveDistance * 1.0 / optionsWidth;
            additonalDistance = perDistance * (CGRectGetWidth(formerOptionView.frame) + OPTION_SPACE_X);
        }
    }
    return additonalDistance;
}

#pragma mark move
- (void)moveToIndex:(int)destIndex callBack:(BOOL)needCallBack {
    if (destIndex != currentSelectedIndex) {
        currentSelectedIndex = destIndex;
        //option view
        OptionView *destOptionView = [optionViewsArray objectAtIndex:destIndex];
        //reset selected status
        [self resetOptionSelectedStatus];
        destOptionView.optionButton.selected = YES;
        //检查是否需要动态移动option view 和 indicator view
        CGRect indicatorFrame = CGRectZero;
        CGRect optionsViewFrame = CGRectZero;
        //indicator view
        CGPoint origin = [[indicatorOrginsArray objectAtIndex:destIndex] CGPointValue];
        indicatorFrame = CGRectMake(origin.x, origin.y, CGRectGetWidth(destOptionView.frame), SLIDE_INDICATOR_HEIGHT);
        if (!allCanDisplay) {
            //options view
            CGFloat optionsViewOffsetX = - (CGRectGetMinX(destOptionView.frame) - origin.x);
            optionsViewFrame = optionsView.frame;
            optionsViewFrame.origin.x = optionsViewOffsetX;
        } else {
            optionsViewFrame = optionsView.frame;
        }
        //animation
        [UIView animateWithDuration:OPTION_MOVE_ANIMATION_DURATION animations:^ {
            optionsView.frame = optionsViewFrame;
            indicatorView.frame = indicatorFrame;
        } completion:^ (BOOL finished) {
            
        }];
        if (needCallBack) {
            //回调
            if (delegate && [delegate respondsToSelector:@selector(slideOptionsView:didSelectOptionAtIndex:)]) {
                [delegate slideOptionsView:self didSelectOptionAtIndex:destIndex];
            }
        }
    }
}

#pragma mark option button clicked
- (void)optionButtonClicked:(UIButton *)optionButton {
    int optionIndex = (int)optionButton.tag - OPTION_VIEW_BASE_TAG;
    //滑动前后索引位置一样，则忽略本次滑动
    if (optionIndex == currentSelectedIndex) {
        return;
    }
    //移动
    [self moveToIndex:optionIndex callBack:YES];
    
}

- (void)resetOptionSelectedStatus {
    [optionViewsArray makeObjectsPerformSelector:@selector(resetSelectedStatus)];
}

@end
