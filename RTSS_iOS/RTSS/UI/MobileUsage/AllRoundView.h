//
//  AllRoundView.h
//  RTSS
//
//  Created by 蔡杰Alan on 14-11-28.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllRoundView : UIView

@property(nonatomic,readonly)UILabel *remainLabel;
@property(nonatomic,readonly) UILabel *describeLabel;
@property(nonatomic,readonly) UIView  *bottomView;//line>0 存在
@property(nonatomic,readonly) UILabel *bottomLabel;


-(instancetype)initWithFrame:(CGRect)frame line:(CGFloat)line;

-(void)setRemainingAmount:(NSString *)aRemaining total:(NSString *)aTotal Unit:(NSString *)aUnit Color:(UIColor *)aColor;

-(void)setAllBgViewColor:(UIColor*)aColor;

@end
