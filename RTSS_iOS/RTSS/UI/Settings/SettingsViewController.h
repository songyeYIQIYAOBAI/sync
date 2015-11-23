//
//  SettingsViewController.h
//  RTSS
//
//  Created by shengyp on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BasicViewController.h"

typedef NS_ENUM(NSInteger, SettingsViewControllerVersionUpateAlertTag){
    SettingsViewControllerVersionUpateAlertTagNoNeedUpdate = 100,//不需要更新
    SettingsViewControllerVersionUpateAlertTagNeedUpdate,//需要更新
    SettingsViewControllerVersionUpateAlertTagForcedUpdate,//强制更新
};

@interface SettingsViewController : BasicViewController

@end
