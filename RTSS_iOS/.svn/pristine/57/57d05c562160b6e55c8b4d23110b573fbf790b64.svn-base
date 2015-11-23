//
//  CountdownView.h
//  RTSS
//
//  Created by shengyp on 14/11/4.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COUNTDOWNVIEW_TRANSFER_TIMEOUT              30

@protocol CountdownViewDelegate;

@interface CountdownView : UIView

@property(nonatomic, readonly) UILabel*                 countDownLabel;
@property(nonatomic, readonly) UILabel*                 promptLabel;
@property(nonatomic, assign) int                        countDown;
@property(nonatomic, assign) id<CountdownViewDelegate>  delegate;

- (void)startCountdown;

- (void)stopCountdown;

@end

@protocol CountdownViewDelegate <NSObject>

@optional
- (void)countdownViewFinished:(CountdownView*)view;

@end
