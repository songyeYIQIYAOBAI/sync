//
//  RTSSUserDataDB.h
//  RTSS
//
//  Created by shengyp on 14/11/3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet;
@class Message;
@class Subscriber;
@class EventItem;

@interface RTSSUserDataDB : NSObject

+ (RTSSUserDataDB*)standardRTSSUserDataDB;

#pragma mark ==========数据库变更==========
- (BOOL)rtssDBChanges;

- (BOOL)insert:(NSString*)sql args:(NSArray*)args;
- (FMResultSet*)query:(NSString*)sql args:(NSArray*)args;
- (BOOL)update:(NSString*)sql args:(NSArray*)args;
- (BOOL)remove:(NSString*)sql args:(NSArray*)args;

@end
