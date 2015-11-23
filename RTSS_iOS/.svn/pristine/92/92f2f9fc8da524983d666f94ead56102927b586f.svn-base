//
//  CircleProgressView.h
//  IOS7Test
//
//  Created by shengyp on 14-9-1.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllRoundView.h"
@interface CircleProgressView : UIView

@property(nonatomic, readonly) CAShapeLayer* circleShapeLayer;
@property(nonatomic, readonly) CAShapeLayer* circleProgressLayer;

@property(nonatomic, readonly) UIButton* circleButton;

@property(nonatomic, assign, setter = setLineWidth:) CGFloat lineWidth;
@property(nonatomic, retain, setter = setTrackColor:) UIColor* trackColor;
@property(nonatomic, retain, setter = setProgressColor:) UIColor* progressColor;

@property(nonatomic, assign, setter = setProgress:) CGFloat progress;

@property(nonatomic,retain,readonly)  AllRoundView *allroundView;

//初始化函数
- (id)initWithFrame:(CGRect)frame line:(CGFloat)aLine;

- (void)setProgress:(CGFloat)aProgress duration:(CGFloat)aDuration animated:(BOOL)animated;

-(void)setRemainingAmount:(NSString *)aRemaining total:(NSString *)aTotal Unit:(NSString *)aUnit Color:(UIColor *)aColor;

@end
