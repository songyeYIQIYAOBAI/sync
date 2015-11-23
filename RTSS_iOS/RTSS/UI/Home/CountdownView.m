//
//  CountdownView.m
//  RTSS
//
//  Created by shengyp on 14/11/4.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "CountdownView.h"
#import "CommonUtils.h"

@interface CountdownView ()

@property(nonatomic, retain) NSTimer*            countDownTimer;
@property(nonatomic, assign) int                 countDownValue;

@end

@implementation CountdownView
@synthesize countDownLabel, promptLabel, countDown,countDownTimer,countDownValue,delegate;

- (void)dealloc
{
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutContentView];
    }
    return self;
}

- (void)layoutContentView
{
    countDownLabel = [CommonUtils labelWithFrame:CGRectMake(self.bounds.size.width-80, 0, 80, 50) text:@"" textColor:[UIColor whiteColor] textFont:[UIFont boldSystemFontOfSize:50] tag:0];
    countDownLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:countDownLabel];
    
    promptLabel = [CommonUtils labelWithFrame:CGRectMake(0, 90, self.bounds.size.width, 40) text:@"" textColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:14] tag:1];
    promptLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:promptLabel];
}

- (void)startCountdown
{
    self.countDownValue = self.countDown;
    countDownLabel.hidden = NO;
    promptLabel.hidden = NO;
    countDownLabel.text = [NSString stringWithFormat:@"%d",self.countDownValue];
    
    [self startTimer];
}

- (void)stopCountdown
{
    countDownLabel.hidden = YES;
    promptLabel.hidden = YES;
    
    [self stopTimer];
}

- (void)startTimer
{
    [self stopTimer];
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    if(nil != self.countDownTimer && [self.countDownTimer isValid]){
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
}

- (void)onTimer
{
    self.countDownValue -= 1;
    if(0 > self.countDownValue){
        [self stopTimer];
        
        if(nil != delegate && [delegate respondsToSelector:@selector(countdownViewFinished:)]){
            [delegate countdownViewFinished:self];
        }
    }else{
        countDownLabel.text = [NSString stringWithFormat:@"%d", self.countDownValue];
    }
}

@end
