//
//  VersionUpdate.m
//  RTSS
//
//  Created by shengyp on 15-4-26.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "VersionUpdate.h"
#import "RTSSAppDefine.h"
#import "Toast+UIView.h"
#import "AppDelegate.h"
#import "AlertController.h"

#import "CommonUtils.h"

#import "User.h"

@interface VersionUpdate() <MappActorDelegate>

@property (nonatomic, assign) BOOL                      activityIndicator;
@property (nonatomic, assign) BOOL                      alert;

@property (nonatomic, retain) User*                     versionUpdateUser;
@property (nonatomic, retain) NSDictionary*             versionInfo;

@end

@implementation VersionUpdate
@synthesize activityIndicator, alert, versionInfo, versionUpdateUser, checkVersionUpdating;

- (void)dealloc
{
    [versionUpdateUser release];
    [versionInfo release];
    
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.checkVersionUpdating = NO;
        versionUpdateUser = [[User alloc] init];
    }
    return self;
}

- (void)versionUpdateWithActivityIndicator:(BOOL)isActivityIndicator
{
    [self versionUpdateWithActivityIndicator:isActivityIndicator alert:YES];
}

- (void)versionUpdateWithActivityIndicator:(BOOL)isActivityIndicator alert:(BOOL)isAlert
{
    self.activityIndicator      = isActivityIndicator;
    self.alert                  = isAlert;
    
    if (YES == self.activityIndicator) {
        [APPLICATION_KEY_WINDOW makeToastActivity];
    }

    if(NO == self.checkVersionUpdating){
        self.checkVersionUpdating = YES;
        // TODO
//        [versionUpdateUser checkVersionWithDelegate:self];
    }
}

- (void)versionUpdateDownload
{
    if ([CommonUtils objectIsValid:self.versionInfo] && [CommonUtils objectIsValid:[self.versionInfo objectForKey:@"updateUrl"]]) {
        NSURL* url = [NSURL URLWithString:[self.versionInfo objectForKey:@"updateUrl"]];
        if (nil != url && [[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)versionUpdateHandle:(VersionUpdateInfo)versionStatus
{
    UIViewController* alertViewController = [AppDelegate shareAppDelegate].window.rootViewController;
    
    switch (versionStatus) {
        case VersionUpdateInfoDefault:{
            if(YES == self.alert && nil != alertViewController){
                NSString* message = NSLocalizedString(@"VersionUpdate_Last_Version_Message", nil);
                AlertController* alertTemp = [[AlertController alloc] initWithTitle:nil
                                                                            message:message
                                                                           delegate:nil
                                                                                tag:VersionUpdateInfoDefault
                                                                  cancelButtonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil)
                                                                  otherButtonTitles:nil,nil];
                [alertTemp showInViewController:alertViewController];
                [alertTemp release];
            }
            break;
        }
        case VersionUpdateInfoNeedUpdate:{
            if(nil != alertViewController){
                AlertController* alertTemp = [[AlertController alloc] initWithTitle:nil
                                                                            message:[self.versionInfo objectForKey:@"description"]
                                                                           delegate:self
                                                                                tag:VersionUpdateInfoNeedUpdate
                                                                  cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil)
                                                                  otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
                [alertTemp showInViewController:alertViewController];
                [alertTemp release];
            }
            break;
        }
        case VersionUpdateInfoForceUpdate:{
            if(nil != alertViewController){
                AlertController* alertTemp = [[AlertController alloc] initWithTitle:nil
                                                                            message:[self.versionInfo objectForKey:@"description"]
                                                                           delegate:self
                                                                                tag:VersionUpdateInfoForceUpdate
                                                                  cancelButtonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil)
                                                                  otherButtonTitles:nil,nil];
                [alertTemp showInViewController:alertViewController];
                [alertTemp release];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark AlertControllerDelegate
- (void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (alertController.tag) {
        case VersionUpdateInfoNeedUpdate:{
            if(alertController.firstOtherButtonIndex == buttonIndex){
                [self versionUpdateDownload];
            }
            break;
        }
        case VersionUpdateInfoForceUpdate:{
            if(alertController.cancelButtonIndex == buttonIndex){
                [self versionUpdateDownload];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark MappActorDelegate
- (void)checkVersionFinished:(NSInteger)status andInfo:(NSDictionary *)info
{
    self.checkVersionUpdating = NO;
    self.versionInfo = info;
    
    if(YES == self.activityIndicator){
        [APPLICATION_KEY_WINDOW hideToastActivity];
    }
    
    if (MappActorFinishStatusOK == status) {
        if (APPLICATION_VERSION_CODE == [[info objectForKey:@"lastVersion"] intValue]) {
            [self versionUpdateHandle:VersionUpdateInfoDefault];
        }else if(APPLICATION_VERSION_CODE < [[info objectForKey:@"lastVersion"] intValue]){
            [self versionUpdateHandle:[[info objectForKey:@"action"] integerValue]];
        }
    }
}

@end
