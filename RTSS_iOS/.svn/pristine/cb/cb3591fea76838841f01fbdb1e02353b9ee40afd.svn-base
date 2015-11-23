//
//  PushNotification.m
//  RTSS
//
//  Created by shengyp on 15-4-14.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "PushNotification.h"
#import "Session.h"
#import "Customer.h"
#import "Settings.h"
#import "CommonUtils.h"
#import "Messages.h"
@interface PushNotification()<MappActorDelegate>

@property (nonatomic, retain) NSString* deviceTokenString;

@end

@implementation PushNotification
@synthesize deviceTokenString;

- (void)dealloc
{
    [deviceTokenString release];
    
    [super dealloc];
}

- (void)registerForRemoteNotification:(UIApplication *)application
{
    
    BOOL pushSwitch = [[Settings standardSettings] getPushSwitch];
    if (pushSwitch) {
        [self openRegisterForRemoteNotification:application];
    } else {
        [self closeRegisterForRemoteNotification:application];
    }
    /*
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
        if([application respondsToSelector:@selector(registerUserNotificationSettings:)]){
            UIUserNotificationSettings* userNotifiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
            [application registerUserNotificationSettings:userNotifiSettings];
            
            [application registerForRemoteNotifications];
        }
#endif
    }else{
        if([application respondsToSelector:@selector(registerForRemoteNotificationTypes:)]){
            UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound;
            [application registerForRemoteNotificationTypes:types];
        }
    }
     */
}

- (void)openRegisterForRemoteNotification:(UIApplication *)application
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
        if([application respondsToSelector:@selector(registerUserNotificationSettings:)]){
            UIUserNotificationSettings* userNotifiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
            [application registerUserNotificationSettings:userNotifiSettings];
            
            [application registerForRemoteNotifications];
        }
#endif
    }else{
        if([application respondsToSelector:@selector(registerForRemoteNotificationTypes:)]){
            UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound;
            [application registerForRemoteNotificationTypes:types];
        }
    }
}

- (void)closeRegisterForRemoteNotification:(UIApplication *)application
{
    UIRemoteNotificationType type = [application enabledRemoteNotificationTypes];
    if (type != UIRemoteNotificationTypeNone)
    {
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
            if([application respondsToSelector:@selector(registerUserNotificationSettings:)]){
                UIUserNotificationSettings* userNotifiSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeNone categories:nil];
                [application registerUserNotificationSettings:userNotifiSettings];
                
                [application registerForRemoteNotifications];
            }
#endif
        }else{
            if([application respondsToSelector:@selector(registerForRemoteNotificationTypes:)]){
                UIRemoteNotificationType types = UIRemoteNotificationTypeNone;
                [application registerForRemoteNotificationTypes:types];
            }
        }
    }
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"PushNotification: didRegisterUserNotificationSettings: %@", notificationSettings.description);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"PushNotification: didRegisterForRemoteNotificationsWithDeviceToken: %@", deviceToken.description);
    if(nil != deviceToken){
        self.deviceTokenString = [CommonUtils formatDeviceToken:deviceToken];
        NSString* deviceTokenDefault  = [[Settings standardSettings] getDeviceToken];
        if([CommonUtils objectIsValid:self.deviceTokenString] && NO == [self.deviceTokenString isEqualToString:deviceTokenDefault]){
            [[Messages sharedMessages] pushBindWithCustomerId:[Session sharedSession].mMyCustomer.mId andToken:self.deviceTokenString andDeviceInfo:nil andDelegate:self];
        }
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"PushNotification: didFailToRegisterForRemoteNotificationsWithError: %@", error.description);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"PushNotification: didReceiveRemoteNotification: %@", userInfo.description);
    /*
     {
     "aps": {
     "alert" : "You got a new message!" ,
     "badge" : 5,
     "sound" : "beep.wav"
     },
     "acme1" : "bar",
     "acme2" : 42
     }
     */
    application.applicationIconBadgeNumber = 0;
    
    if(nil != userInfo){
        // 获取服务器Messages信息并合并到数据库
        [[Messages sharedMessages] messagesWithDelegate:self];
        // 判断应用程序当前的运行状态
        if (application.applicationState == UIApplicationStateActive) {
            // 程序在前台
            
        } else if (application.applicationState == UIApplicationStateBackground){
            // 程序在后台
            
        } else {
            
        }
    }
}

- (void)pushBindFinished:(NSInteger)status
{
    if (status == MappActorFinishStatusOK) {
        //保存 self.tokenString
        [[Settings standardSettings] setDeviceToken:self.deviceTokenString];
    }
}

@end
