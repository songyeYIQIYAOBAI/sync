//
//  Settings.h
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

+ (Settings*)standardSettings;

// 设置Device Token
- (BOOL)setDeviceToken:(NSString*)deviceToken;
- (NSString*)getDeviceToken;
- (BOOL)removeDeviceToken;

// 设置自动登录开关
- (BOOL)setAutoLoginSwitch:(BOOL)on;
- (BOOL)getAutoLoginSwith;
- (BOOL)removeAutoLoginSwitch;

// 设置用户默认的Transfer量值
- (BOOL)setTransferValue:(long long)value key:(NSString*)keyString;
- (long long)getTransferValueByKey:(NSString*)keyString;
- (BOOL)removeTransferValueByKey:(NSString*)keyString;

// 设置校准时间
- (BOOL)setCalibrateDate:(NSDate*)date;
- (NSDate*)getCalibrateDate;
- (BOOL)removeCalibrateDate;


// 设置远程推送开关
- (BOOL)setPushSwitch:(BOOL)pushSwitchStatus;
- (BOOL)getPushSwitch;

//设置Subscriber
-(BOOL)setCustomerSubscriberId:(NSString*)subscriberId;
- (NSString*)getCustomerSubscriberId;
- (BOOL)removeCustomerSubscriberId;
@end
