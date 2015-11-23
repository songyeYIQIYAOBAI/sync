//
//  RTSSLocalNotification.h
//  RTSS
//
//  Created by shengyp on 14/11/3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTSSLocalNotification : NSObject

+ (RTSSLocalNotification*)standardRTSSLocalNotification;

- (void)scheduleAlert:(NSString*)alertBody;

- (void)scheduleAlert:(NSString*)alertBody fireDate:(NSDate*)fireDate;

@end
