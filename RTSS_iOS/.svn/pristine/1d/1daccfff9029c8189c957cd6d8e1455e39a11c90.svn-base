//
//  UIDevice+Extend.m
//  SJB
//
//  Created by sheng yinpeng on 13-9-2.
//  Copyright (c) 2013年 sheng yinpeng. All rights reserved.
//

#import "UIDevice+Extend.h"
#import "UserDefaults.h"

#define USERDEFAULTS_UUID_KEY                   @"USERDEFAULTS_UUID"

@implementation UIDevice (Extend)

- (NSString*)universallyUniqueIdentifier
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString* uuidString = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    CFRelease(uuidRef);
    return [uuidString autorelease];
}

- (NSString*)getUUID
{
    NSMutableString* uuidString = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    if(nil == [[UserDefaults standardUserDefaults] getObjectForKey:USERDEFAULTS_UUID_KEY]){
        [uuidString setString:[self universallyUniqueIdentifier]];
    }else{
        [uuidString setString:[[UserDefaults standardUserDefaults] getObjectForKey:USERDEFAULTS_UUID_KEY]];
    }
    return uuidString;
}

- (NSDictionary*)getDeviceInfo
{
    NSMutableDictionary* deviceInfoDic = [[[NSMutableDictionary alloc] initWithCapacity:3] autorelease];
    [deviceInfoDic setObject:[self getUUID] forKey:DEVICE_INFO_UNIQUEIDENTIFIER_KEY];
    [deviceInfoDic setObject:@"iOS" forKey:DEVICE_INFO_PLATFORM_KEY];
    [deviceInfoDic setObject:self.systemVersion forKey:DEVICE_INFO_SYSTEM_VERSION_KEY];
    
    return deviceInfoDic;
}

@end
