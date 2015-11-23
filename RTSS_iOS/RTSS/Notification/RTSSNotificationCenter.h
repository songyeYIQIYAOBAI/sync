//
//  SJBNotificationCenter.h
//  SJB2
//
//  Created by shengyp on 14-2-27.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RTSSNotificationType) {
    RTSSNotificationTypeDefault,
    RTSSNotificationTypeUserPortrait,
    RTSSNotificationTypeTransactionCreated,
    RTSSNotificationTypeTransactionJoined,
    RTSSNotificationTypeUserJoined,
    RTSSNotificationTypeMyStatusUpdated,
    RTSSNotificationTypePeerStatusUpdated,
    RTSSNotificationTypeUserStatusUpdated,
    RTSSNotificationTypeTransactionIdle,
    RTSSNotificationTypeSessionInvalid,
    RTSSNotificationTypePeerInfoReady,
    RTSSNotificationTypeChangeAccount,
    RTSSNotificationTypeApplicationChangeLanguage,
    RTSSNotificationTypeBudgetGroupList,
};

@interface RTSSNotificationCenter : NSObject{
	
}

+ (RTSSNotificationCenter*)standardRTSSNotificationCenter;
+ (void)destroy;

- (void)addNotificationWithType:(RTSSNotificationType)type observer:(id)observer selector:(SEL)aSelector object:(id)anObject;
- (void)removeNotificationWithType:(RTSSNotificationType)type observer:(id)observer object:(id)anObject;
- (void)postNotificationWithType:(RTSSNotificationType)type object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

@end
