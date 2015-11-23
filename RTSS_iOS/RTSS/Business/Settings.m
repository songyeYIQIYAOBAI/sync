//
//  Settings.m
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "Settings.h"
#import "UserDefaults.h"

#define USERCONFIG_DEVICES_TOKEN_KEY                                    @"USERCONFIG_DEVICES_TOKEN"
#define USERCONFIG_AUTOLOGIN_SWITCH_KEY                                 @"USERCONFIG_AUTOLOGIN_SWITCH"
#define USERCONFIG_CALIBRATE_DATE_KEY                                   @"USERCONFIG_CALIBRATE_DATE"
#define USERCONFIG_PUSH_SWITCH_KEY                                      @"USERCONFIG_PUSH_SWITCH"
#define USERCONFIG_SUBSCRIBER_ID_KEY                                    @"USERCONFIG_SUBSCRIBER_ID"

static Settings*  settings = nil;

@interface Settings()
{
    UserDefaults* userDefaults;
}

@end

@implementation Settings

- (void)dealloc
{
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        userDefaults = [UserDefaults standardUserDefaults];
    }
    return self;
}

+ (Settings*)standardSettings{
    @synchronized(self){
        if(nil == settings){
            settings = [[Settings alloc] init];
        }
    }
    return settings;
}

#pragma mark 设置Device Token
- (BOOL)setDeviceToken:(NSString*)deviceToken
{
    return [userDefaults setObject:deviceToken forKey:USERCONFIG_DEVICES_TOKEN_KEY];
}

- (NSString*)getDeviceToken
{
    return [userDefaults getObjectForKey:USERCONFIG_DEVICES_TOKEN_KEY];
}

- (BOOL)removeDeviceToken
{
    return [userDefaults removeObjectForKey:USERCONFIG_DEVICES_TOKEN_KEY];
}

#pragma mark 设置自动登录开关
- (BOOL)setAutoLoginSwitch:(BOOL)on
{
   return [userDefaults setObject:[NSNumber numberWithBool:on] forKey:USERCONFIG_AUTOLOGIN_SWITCH_KEY];
}

- (BOOL)getAutoLoginSwith
{
    return [[userDefaults getObjectForKey:USERCONFIG_AUTOLOGIN_SWITCH_KEY] boolValue];
}

- (BOOL)removeAutoLoginSwitch
{
    return [userDefaults removeObjectForKey:USERCONFIG_AUTOLOGIN_SWITCH_KEY];
}

#pragma mark 设置用户默认的Transfer量值
- (BOOL)setTransferValue:(long long)value key:(NSString*)keyString
{
    return [userDefaults setObject:[NSNumber numberWithLongLong:value] forKey:keyString];
}

- (long long)getTransferValueByKey:(NSString*)keyString
{
    return [[userDefaults getObjectForKey:keyString] longLongValue];
}

- (BOOL)removeTransferValueByKey:(NSString*)keyString
{
    return [userDefaults removeObjectForKey:keyString];
}

#pragma mark 设置校准时间
- (BOOL)setCalibrateDate:(NSDate*)date
{
    return [userDefaults setObject:date forKey:USERCONFIG_CALIBRATE_DATE_KEY];
}

- (NSDate*)getCalibrateDate
{
    return [userDefaults getObjectForKey:USERCONFIG_CALIBRATE_DATE_KEY];
}

- (BOOL)removeCalibrateDate
{
    return [userDefaults removeObjectForKey:USERCONFIG_CALIBRATE_DATE_KEY];
}





#pragma mark 设置远程推送开关
- (BOOL)setPushSwitch:(BOOL)pushSwitchStatus
{
    return [userDefaults setObject:[NSNumber numberWithBool:pushSwitchStatus] forKey:USERCONFIG_PUSH_SWITCH_KEY];
}

- (BOOL)getPushSwitch
{
    return [[userDefaults getObjectForKey:USERCONFIG_PUSH_SWITCH_KEY] boolValue];
}


#pragma mark 设置Subscriber
- (BOOL)setCustomerSubscriberId:(NSString*)subscriberId
{
    return [userDefaults setObject:subscriberId forKey:USERCONFIG_SUBSCRIBER_ID_KEY];
}

- (NSString*)getCustomerSubscriberId
{
    return [userDefaults getObjectForKey:USERCONFIG_SUBSCRIBER_ID_KEY];
}

- (BOOL)removeCustomerSubscriberId
{
    return [userDefaults removeObjectForKey:USERCONFIG_SUBSCRIBER_ID_KEY];
}


@end
