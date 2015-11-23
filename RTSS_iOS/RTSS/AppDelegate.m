//
//  AppDelegate.m
//  RTSS
//
//  Created by shengyp on 14/10/21.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "LoadingViewController.h"
#import "RTSSAppStyle.h"
#import "RTSSLocation.h"
#import "RuleManager.h"
#import "FileUtils.h"
#import "StaticData.h"
#import "PushNotification.h"
#import "VersionUpdate.h"

#import "AlertController.h"
#import <CoreMotion/CoreMotion.h>

int                         appVersionCode = 0;

NSString*                   xApiKey = nil;
NSString*                   ppUrlGenerator = nil;
NSString*                   rtssChannel = nil;
NSString*                   topupProduct = nil;
NSString*                   topupAccountCharName = nil;
NSString*                   topupAccountCharValue = nil;

BOOL                        dispatcher = NO;
BOOL                        ppUrlGenerateWithoutMapp = NO;

static CMMotionManager*     motionManager = nil;

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window, navigationRootController;
@synthesize rtssLocation, configDictionary, pushNotification, versionUpdate;

- (void)dealloc {
    [rtssLocation release];
    [configDictionary release];
    [pushNotification release];
    [versionUpdate release];
    
    [super dealloc];
}

#pragma mark interface
+ (AppDelegate*)shareAppDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

+ (CMMotionManager*)sharedMotionManager{
    @synchronized(self){
        if(nil == motionManager){
            motionManager = [[CMMotionManager alloc] init];
        }
    }
    return motionManager;
}

- (void)appVersionUpdate:(BOOL)isActivityIndicator alert:(BOOL)isAlert
{
    if(nil != self.versionUpdate){
        [self.versionUpdate versionUpdateWithActivityIndicator:isActivityIndicator alert:isAlert];
    }
}

- (void)startRTSSViewControllerType:(RTSSViewControllerType)type{
    [self startRTSSViewControllerType:type functionType:BasicViewControllerFunctionTypeDefault];
}

- (void)startRTSSViewControllerType:(RTSSViewControllerType)type functionType:(BasicViewControllerFunctionType)functionType{
    if(nil != self.navigationRootController){
        [self.navigationRootController popToRootViewControllerAnimated:NO];
        [self.navigationRootController.view removeFromSuperview];
    }
    
    UIViewController* viewController = nil;
    switch (type) {
        case RTSSViewControllerTypeHome:{
            HomeViewController* homeVC = [[HomeViewController alloc] init];
            viewController = homeVC;
            break;
        }
        case RTSSViewControllerTypeLogin:{
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.functionType = functionType;
            viewController = loginVC;
            break;
        }
        case RTSSViewControllerTypeLoading:{
            LoadingViewController* loadingVC = [[LoadingViewController alloc] init];
            viewController = loadingVC;
            break;
        }
        default:
            break;
    }
    
    if(nil != viewController){
        UINavigationController * navigationController = [[RTSSAppStyle currentAppStyle] getRTSSNavigationController:viewController];
        self.navigationRootController = navigationController;
        self.window.rootViewController = navigationController;
        self.window.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
        [self.window makeKeyAndVisible];
        [viewController release];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    appVersionCode                  = APPLICATION_VERSION_CODE;
    
    xApiKey                         = __X_API_KEY__;
    ppUrlGenerator                  = __PP_URL_GENERATOR__;
    rtssChannel                     = __RTSS_CHANNEL__;
    topupProduct                    = __TOPUP_PRODUCTID__;
    topupAccountCharName            = __TOPUP_ACCOUNT_CHAR_NAME__;
    topupAccountCharValue           = __TOPUP_ACCOUNT_CHAR_VALUE__;
    
    dispatcher                      = __SUPPORT_DISPATCHER__;
    ppUrlGenerateWithoutMapp        = __PP_URL_GENERATE_WITHOUT_MAPP__;
    
    
    // Override point for customization after application launch.
    self.window = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    
    // 加载资源
    [StaticData getAssetsRegistry];
    
    // 启用定位服务
    self.rtssLocation = [[[RTSSLocation alloc] init] autorelease];
    self.rtssLocation.updatingLocationFinishedStopLocation = YES;
    self.rtssLocation.updatingLocationFinishedCloseLocation = YES;
    [self.rtssLocation startUpdatingLocation];
    
    // 加载配置文件
    self.configDictionary = [FileUtils openPlistFileByDictionary:@"Config"];
    
    // 注册远程通知
    self.pushNotification = [[[PushNotification alloc] init] autorelease];
    [self.pushNotification registerForRemoteNotification:application];
    
    // 版本更新
    self.versionUpdate  = [[[VersionUpdate alloc] init] autorelease];
    
    // 载入等待页面
    [self startRTSSViewControllerType:RTSSViewControllerTypeLoading];
    
    // Session失效
    [[RTSSNotificationCenter standardRTSSNotificationCenter] addNotificationWithType:RTSSNotificationTypeSessionInvalid observer:self selector:@selector(sessionInvalid:) object:nil];
    
    return YES;
}

// 重新注册远程通知
- (void)registerForRemoteNotification
{
    [self.pushNotification registerForRemoteNotification:[UIApplication sharedApplication]];
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [self.pushNotification application:application didRegisterUserNotificationSettings:notificationSettings];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [self.pushNotification application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [self.pushNotification application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [self.pushNotification application:application didReceiveRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark SessionInvalid
- (void)sessionInvalid:(NSNotification *)notification{
    AlertController* alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"ErroMessage_Session_Timeout", nil) delegate:self tag:BasicViewControllerAlertTagSessionInvalid cancelButtonTitle:NSLocalizedString(@"UIButton_Confirm_String", nil) otherButtonTitles:nil,nil];
    [alert showInViewController:self.navigationRootController];
    [alert release];
}

- (void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (alertController.tag) {
        case BasicViewControllerAlertTagSessionInvalid:{
            [self startRTSSViewControllerType:RTSSViewControllerTypeLoading];
        }
        default:
            break;
    }
}

@end
