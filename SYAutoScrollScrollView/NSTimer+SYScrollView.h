//
//  NSTimer+SYScrollView.h
//  animationDemo
//
//  Created by Dragon on 15/9/15.
//  Copyright (c) 2015年 SY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (SYScrollView)

//暂停
- (void)pauseTimer;

//重新开始
- (void)resumeTimer;

- (void)resumeTimerAfterTimerInterval:(NSTimeInterval)interval;

@end
