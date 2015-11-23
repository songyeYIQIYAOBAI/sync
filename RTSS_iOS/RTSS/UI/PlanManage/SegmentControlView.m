//
//  SegmentControlView.m
//  RTSS
//
//  Created by 加富董 on 14/11/13.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "SegmentControlView.h"
#import "CommonUtils.h"

@interface SegmentControlView () {
    //control button
    UIButton *leftButton;
    UIButton *rightButton;
    
    //control bg color
    UIColor *normalBgColor;
    UIColor *selectedBgColor;
    
    //text color
    UIColor *normalTextColor;
    UIColor *selectedTextColor;
    
    //border color
    UIColor *borderColor;
    
}

@end

@implementation SegmentControlView

@synthesize currentSelectedIndex;
@synthesize delegate;

#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame
            firstSegmentTitle:(NSString *)firstTitle
           secondSegmentTitle:(NSString *)secondTitle
              normalTextColor:(UIColor *)nomTextColor
            selectedTextColor:(UIColor *)selTextColor
         normalControlBgColor:(UIColor *)nomBgColor
       selectedControlBgColor:(UIColor *)selBgColor
                  borderColor:(UIColor *)bdColor
         defaultSelectedIndex:(NSInteger)selIndex {
    if (self = [super initWithFrame:frame]) {
        normalBgColor = nomBgColor;
        selectedBgColor = selBgColor;
        
        normalTextColor = nomTextColor;
        selectedTextColor = selTextColor;
        borderColor = bdColor;
        
        //border color
        if (borderColor) {
            self.layer.borderWidth = 0.5f;
            self.layer.borderColor = borderColor.CGColor;
            self.layer.cornerRadius = 6.f;
            self.layer.masksToBounds = YES;
        }
        
        CGFloat controlWidth = CGRectGetWidth(frame) / 2.f;
        CGFloat controlHeight = CGRectGetHeight(frame);
    
        //left control
        CGRect leftFrame = CGRectMake(0.f, 0.f, controlWidth, controlHeight);
        leftButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:leftFrame title:firstTitle colorNormal:normalBgColor colorHighlighted:selectedBgColor colorSelected:selectedBgColor addTarget:self action:@selector(selectSegment:) tag:SegmentControlIndexFirst];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [self addSubview:leftButton];
        
        //right control
        CGRect rightFrame = CGRectMake(CGRectGetWidth(leftButton.frame), 0.f, controlWidth, controlHeight);
        rightButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:rightFrame title:secondTitle colorNormal:normalBgColor colorHighlighted:selectedBgColor colorSelected:selectedBgColor addTarget:self action:@selector(selectSegment:) tag:SegmentControlIndexSecond];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [self addSubview:rightButton];
        
        //text color
        if (normalTextColor) {
            [leftButton setTitleColor:normalTextColor forState:UIControlStateNormal];
            [rightButton setTitleColor:normalTextColor forState:UIControlStateNormal];
        }
        
        if (selectedTextColor) {
            [leftButton setTitleColor:selectedTextColor forState:UIControlStateSelected];
            [rightButton setTitleColor:selectedTextColor forState:UIControlStateSelected];
        }
        
        //set selected
        if (selIndex == 0) {
            currentSelectedIndex = SegmentControlIndexFirst;
            [self updateControlStyleBySelectedIndex:SegmentControlIndexFirst];
        } else {
            currentSelectedIndex = SegmentControlIndexSecond;
            [self updateControlStyleBySelectedIndex:SegmentControlIndexSecond];
        }
    }
    return self;
}

- (void)updateControlStyleBySelectedIndex:(SegmentControlIndex)index {
    currentSelectedIndex = index;
    if (index == SegmentControlIndexFirst) {
        leftButton.selected = YES;
        rightButton.selected = NO;
    } else {
        leftButton.selected = NO;
        rightButton.selected = YES;
    }
}

#pragma mark button clicked
- (void)selectSegment:(UIButton *)control {
    SegmentControlIndex index = control.tag;
    [self updateControlStyleBySelectedIndex:index];
    if (delegate && [delegate conformsToProtocol:@protocol(SegmentControlViewDelegate)] && [delegate respondsToSelector:@selector(segmentControlView:didSelectedSegmentAtIndex:)]) {
        [delegate segmentControlView:self didSelectedSegmentAtIndex:currentSelectedIndex];
    }
}

#pragma mark dealloc
- (void)dealloc {
    [super dealloc];
}

@end
