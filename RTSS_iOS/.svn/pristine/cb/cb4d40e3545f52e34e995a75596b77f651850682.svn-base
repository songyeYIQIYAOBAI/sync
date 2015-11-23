//
//  Events.h
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EventItem.h"

#define EVENT_INFO_KEY @"info"
#define EVENT_DATA_KEY @"data"

@interface Events : NSObject

//获取全局唯一单利对象
+ (Events *)sharedEvents;

//按照type类型（可以通过｜运算同时设置多类型）查询指定用户（phoneNumber）的交易记录
- (NSDictionary*)events:(NSArray*)type about:(NSString*)phoneNumber;

- (void)addEvent:(EventItem*)event;

@end
