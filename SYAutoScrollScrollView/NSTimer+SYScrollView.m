//
//  NSTimer+SYScrollView.m
//  animationDemo
//
//  Created by Dragon on 15/9/15.
//  Copyright (c) 2015年 SY. All rights reserved.
//

#import "NSTimer+SYScrollView.h"

@implementation NSTimer (SYScrollView)

//暂停
- (void)pauseTimer{
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate distantFuture]];
}

//重新开始
- (void)resumeTimer{
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimerInterval:(NSTimeInterval)interval{
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
