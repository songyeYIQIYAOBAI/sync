//
//  AppDelegate.h
//  RTSS
//
//  Created by shengyp on 14/10/21.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"

typedef NS_ENUM(NSInteger, RTSSViewControllerType){
    RTSSViewControllerTypeHome,
    RTSSViewControllerTypeLogin,
    RTSSViewControllerTypeLoading
};

@class CMMotionManager;
@class HomeViewController;
@class RTSSLocation;
@class PushNotification;
@class VersionUpdate;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, retain) UIWindow*                     window;
@property (nonatomic, retain) UINavigationController*       navigationRootController;

@property (nonatomic, retain) RTSSLocation*                 rtssLocation;
@property (nonatomic, retain) NSDictionary*                 configDictionary;

@property (nonatomic, retain) PushNotification*             pushNotification;
@property (nonatomic, retain) VersionUpdate*                versionUpdate;

// 应用代理
+ (AppDelegate*)shareAppDelegate;
// 运动管理者（重力计）
+ (CMMotionManager*)sharedMotionManager;

// 视图启动
- (void)startRTSSViewControllerType:(RTSSViewControllerType)type;
- (void)startRTSSViewControllerType:(RTSSViewControllerType)type functionType:(BasicViewControllerFunctionType)functionType;

// 检查更新
- (void)appVersionUpdate:(BOOL)isActivityIndicator alert:(BOOL)isAlert;

// 远程通知开关
- (void)registerForRemoteNotification;
@end

