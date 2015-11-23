//
//  SJBNotificationCenter.m
//  SJB2
//
//  Created by shengyp on 14-2-27.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import "RTSSNotificationCenter.h"
#import "NotificationDefine.h"

static RTSSNotificationCenter* mNotificationCenter = nil;

@implementation RTSSNotificationCenter

- (void)dealloc{
    [super dealloc];
}

- (id)init{
    self = [super init];
    if (self) {

    }
    return self;
}

+ (RTSSNotificationCenter*)standardRTSSNotificationCenter{
	@synchronized([RTSSNotificationCenter class]){
		if(nil == mNotificationCenter){
			mNotificationCenter = [[RTSSNotificationCenter alloc] init];
		}
	}
	return mNotificationCenter;
}

+ (void)destroy{
    @synchronized ([RTSSNotificationCenter class]) {
        if(nil != mNotificationCenter){
            [mNotificationCenter release];
            mNotificationCenter = nil;
        }
    }
}

- (NSString*)getObserverNameWithType:(RTSSNotificationType)type{
    // 添加相应通知的宏定义常量字符串，请在NotificationDefine.h中添加
    NSString* notificationName = @"";
    switch (type) {
        case RTSSNotificationTypeUserPortrait:{
            notificationName = NOTIFICATION_USER_PORTRAIT;
            break;
        }
        case RTSSNotificationTypeTransactionCreated: {
            notificationName = NOTIFICATION_TRANSACTION_CREATED;
            break;
        }
        case RTSSNotificationTypeTransactionJoined: {
            notificationName = NOTIFICATION_TRANSACTION_JOINED;
            break;
        }
        case RTSSNotificationTypeUserJoined: {
            notificationName = NOTIFICATION_USER_JOINED;
            break;
        }
        case RTSSNotificationTypeMyStatusUpdated: {
            notificationName = NOTIFICATION_MYSTATUS_UPDATED;
            break;
        }
        case RTSSNotificationTypePeerStatusUpdated: {
            notificationName = NOTIFICATION_PEERSTATUS_UPDATED;
            break;
        }
        case RTSSNotificationTypeUserStatusUpdated: {
            notificationName = NOTIFICATION_USERSTATUS_UPDATED;
            break;
        }
        case RTSSNotificationTypeTransactionIdle: {
            notificationName = NOTIFICATION_TRANSACTION_IDLE;
            break;
        }
        case RTSSNotificationTypeSessionInvalid: {
            notificationName = NOTIFICATION_SESSION_INVALID;
            break;
        }
        case RTSSNotificationTypeChangeAccount:{
            notificationName = NOTIFICATION_CHANGE_ACCOUNT;
            break;
        }
        case RTSSNotificationTypePeerInfoReady: {
            notificationName = NOTIFICATION_PEERINFO_READY;
            break;
        }
        case RTSSNotificationTypeApplicationChangeLanguage:{
            notificationName = NOTIFICATION_APP_CHANGE_LANGUAGE;
            break;
        }
        case RTSSNotificationTypeBudgetGroupList:{
            notificationName = NOTIFICATION_BUDGET_GROUP_LIST;
            break;
        }
        default:
            notificationName = NOTIFICATION_DEFAULT;
            break;
    }
    return notificationName;
}

- (void)addNotificationWithType:(RTSSNotificationType)type observer:(id)observer selector:(SEL)aSelector object:(id)anObject;{
	[self addNotification:observer selector:aSelector name:[self getObserverNameWithType:type] object:anObject];
}

- (void)removeNotificationWithType:(RTSSNotificationType)type observer:(id)observer object:(id)anObject{
	[self removeNotification:observer name:[self getObserverNameWithType:type] object:anObject];
}

- (void)postNotificationWithType:(RTSSNotificationType)type object:(id)anObject userInfo:(NSDictionary*)aUserInfo{
	[self postNotification:[self getObserverNameWithType:type] object:anObject userInfo:aUserInfo];
}

- (void)addNotification:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject{
	[[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:aName object:anObject];
}

- (void)removeNotification:(id)observer name:(NSString *)aName object:(id)anObject{
	[[NSNotificationCenter defaultCenter] removeObserver:observer name:aName object:anObject];
}

- (void)postNotification:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo{
	NSNotification* notification = [NSNotification notificationWithName:aName object:anObject userInfo:aUserInfo];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
