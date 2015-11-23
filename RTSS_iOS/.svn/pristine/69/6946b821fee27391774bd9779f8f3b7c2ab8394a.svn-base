//
//  VersionUpdate.h
//  RTSS
//
//  Created by shengyp on 15-4-26.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VersionUpdateInfo){
    VersionUpdateInfoDefault=1,               //已经是新版本
    VersionUpdateInfoNeedUpdate=2,            //需要更新
    VersionUpdateInfoForceUpdate=3,           //强制更新
};

@interface VersionUpdate : NSObject

@property (nonatomic, assign) BOOL      checkVersionUpdating;

- (void)versionUpdateWithActivityIndicator:(BOOL)isActivityIndicator;

- (void)versionUpdateWithActivityIndicator:(BOOL)isActivityIndicator alert:(BOOL)isAlert;

@end
