//
//  RTSSLocalNotification.m
//  RTSS
//
//  Created by shengyp on 14/11/3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RTSSLocalNotification.h"

static RTSSLocalNotification*   localNotification = nil;

@interface RTSSLocalNotification(){
    UIApplication* application;
}

@end

@implementation RTSSLocalNotification

- (void)dealloc{
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        application = [UIApplication sharedApplication];
    }
    return self;
}

+ (RTSSLocalNotification*)standardRTSSLocalNotification{
    @synchronized(self){
        if(nil == localNotification){
            localNotification = [RTSSLocalNotification alloc];
        }
    }
    return localNotification;
}

- (void)scheduleAlert:(NSString*)alertBody{
    [self scheduleAlert:alertBody fireDate:[[NSDate date] dateByAddingTimeInterval:1]];
}

- (void)scheduleAlert:(NSString*)alertBody fireDate:(NSDate*)fireDate{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone systemTimeZone];
    localNotification.repeatInterval = 0;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.alertBody = alertBody;
    [application scheduleLocalNotification:localNotification];
    [localNotification release];
}

@end
