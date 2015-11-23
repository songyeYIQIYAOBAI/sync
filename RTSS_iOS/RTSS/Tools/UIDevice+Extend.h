//
//  UIDevice+Extend.h
//  SJB
//
//  Created by sheng yinpeng on 13-9-2.
//  Copyright (c) 2013年 sheng yinpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEVICE_INFO_UNIQUEIDENTIFIER_KEY            @"uniqueIdentifier"
#define DEVICE_INFO_PLATFORM_KEY                    @"platform"
#define DEVICE_INFO_SYSTEM_VERSION_KEY              @"version"

@interface UIDevice (Extend)

- (NSDictionary*)getDeviceInfo;

@end
