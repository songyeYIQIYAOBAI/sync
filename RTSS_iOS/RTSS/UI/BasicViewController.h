//
//  BasicViewController.h
//  RTSS
//
//  Created by shengyp on 14/10/21.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTSSAppDefine.h"
#import "RTSSAppStyle.h"
#import "RTSSNotificationCenter.h"

#import "Toast+UIView.h"
#import "CommonUtils.h"
#import "AlertController.h"

#import "define.h"

typedef NS_ENUM(NSInteger, BasicViewControllerAlertTag) {
    BasicViewControllerAlertTagSessionInvalid = 7000,
    BasicViewControllerAlertTagTransactionIdle,
    BasicViewControllerAlertTagTransactionIdleByGift,
    BasicViewControllerAlertTagTransactionIdleByReceive,
    BasicViewControllerAlertTagRadarPickerBack
};

typedef NS_ENUM(NSInteger, VerifyFormDataType) {
    VerifyFormDataTypeVerifyUserID,
    VerifyFormDataTypeActication,
    VerifyFormDataTypeChangePw,
    VerifyFormDataTypeRequestOTP,
    VerifyFormDataTypeForgotUserID,
    VerifyFormDataTypeForgotOTP,    
};

typedef NS_ENUM(NSInteger, BasicViewControllerFunctionType) {
    BasicViewControllerFunctionTypeDefault=-1,
    BasicViewControllerFunctionTypeLogout,
};

@interface BasicViewController : UIViewController{
    UIView*             navigationBarView;
}

@property(nonatomic, retain)UIButton* navigationBackButton;
@property(nonatomic, readonly)UIImageView* navigationSeparatorView;

- (void)loadData;

- (void)backBarButtonAction:(UIButton*)barButtonItem;

- (BOOL)setApplicationLanguage:(NSString *)languageName;

- (void)applicationChangeLanguage:(NSNotification*)notification;

- (UIView*)addNavigationBarView:(NSString*)title bgColor:(UIColor*)bgColor separator:(BOOL)separator;

@end
