//
//  RTSSAppStyle.h
//  RTSS
//
//  Created by shengyp on 14/10/27.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SEPERATOR_LINE_HEIGHT           1.0

@interface RTSSAppStyle : NSObject

#pragma mark ---公用的颜色和字体---
// ---导航背景颜色---
@property(nonatomic, retain) UIColor*               navigationBarColor;
// ---导航标题字体---
@property(nonatomic, retain) UIFont*                navigationTitleFont;
// ---页面背景颜色---
@property(nonatomic, retain) UIColor*               viewControllerBgColor;
// ---瓶子水颜色---
@property(nonatomic, retain) UIColor*               pouringWatterColor;
// ---分割线颜色---
@property(nonatomic, retain) UIColor*               separatorColor;
// ---主按钮颜色---
@property(nonatomic, retain) UIColor*               buttonMajorColor;
// ---主文本颜色---
@property(nonatomic, retain) UIColor*               textMajorColor;
// ---赋文本颜色---
@property(nonatomic, retain) UIColor*               textSubordinateColor;
// ---文本蓝颜色---
@property(nonatomic, retain) UIColor*               textBlueColor;
// ---文本绿颜色---
@property(nonatomic, retain) UIColor*               textGreenColor;
// ---输入框背景颜色---
@property(nonatomic, retain) UIColor*               textFieldBgColor;
// ---输入框边框颜色---
@property(nonatomic, retain) UIColor*               textFieldBorderColor;
// ---输入框默认字体颜色---
@property(nonatomic, retain) UIColor*               textFieldPlaceholderColor;
// ---输入框默认字体---
@property(nonatomic, retain) UIFont*                textFieldPlaceholderFont;
// ---头像的边框颜色---
@property(nonatomic, retain) UIColor*               portraitBorderColor;
// ---头像的边框颜色---
@property(nonatomic, retain) UIColor*               portraitBgColor;
// ---用户输入组合框的错误信息提示字体颜色---
@property(nonatomic, retain) UIColor*               userInfoComponentErrorColor;
// ---用户输入组合框的背景颜色---
@property(nonatomic, retain) UIColor*               userInfoComponentBgColor;
// ---首页圆点指示器颜色(选中)---
@property(nonatomic, retain) UIColor*               currentPageIndicatorTintColor;
// ---首页圆点指示器颜色(未选中)---
@property(nonatomic, retain) UIColor*               pageIndicatorTintColor;
// ---条目未选中背景颜色---
@property(nonatomic, retain) UIColor*               cellUnSelectedColor;
// ---条目选中背景颜色---
@property(nonatomic, retain) UIColor*               cellSelectedColor;

#pragma mark ---HomeViewController---
@property(nonatomic, retain) UIColor*               homeViewResourcePanelColor;

#pragma mark ---RadarPickerViewController---
// ---雷达波扩散的颜色---
@property(nonatomic, retain) UIColor*               radarColor;
// ---雷达选中头像的边框颜色---
@property(nonatomic, retain) UIColor*               radarSelectedItemColor;
// ---雷达未选中头像的边框颜色---
@property(nonatomic, retain) UIColor*               radarUnSelectedItemColor;
// ---雷达头像背景颜色---
@property(nonatomic, retain) UIColor*               radarPortraitBgColor;

#pragma mark ---LoginViewController---
// ---登陆头像的边框颜色---
@property(nonatomic, retain) UIColor*               loginPortraitBgColor;

#pragma mark ---PersonCenterViewController---
// ---个人中心的条目颜色---
@property(nonatomic, retain) UIColor*               personCenterCellBgColor;

@property(nonatomic, retain) UIColor*               textMajorGreenColor;
@property(nonatomic, retain) UIColor*               messageNeverReadTextColor;

@property(nonatomic, retain) UIColor*               transactionFromMeTextColor;
@property(nonatomic, retain) UIColor*               transactionFromOtherTextColor;

@property(nonatomic, retain) UIColor*               turboBoostUnfoldBgColor;
@property(nonatomic, retain) UIColor*               turboBoostBoderColor;
@property(nonatomic, retain) UIColor*               turboBoostButtonBgGrayColor;
@property(nonatomic, retain) UIColor*               turboBoostButtonBgGreenColor;

@property(nonatomic, retain) UIColor*               budgetControlButtonStrokeColor;

@property(nonatomic, retain) UIColor*               walletTitleOrgangeColor;
@property(nonatomic, retain) UIColor*               walletTitleBlueColor;

@property(nonatomic, retain) UIColor*               commonGreenButtonNormalColor;
@property(nonatomic, retain) UIColor*               commonGreenButtonHighlightColor;

@property(nonatomic, retain) UIColor*               separationBgColor;

+ (RTSSAppStyle *)currentAppStyle;
// 获取导航
- (UINavigationController*)getRTSSNavigationController:(UIViewController *)rootViewController;
// 获取字体
+ (UIFont*)getRTSSFontWithSize:(CGFloat)fontSize;
// 获取资源颜色
+ (UIColor*)getFreeResourceColorWithIndex:(NSInteger)index;
// 获取主要绿色
+ (UIButton*)getMajorGreenButton:(CGRect)frame target:(id)target action:(SEL)action title:(NSString*)title;
// 获取颜色按钮
+ (UIButton*)getMajorButton:(CGRect)frame target:(id)target action:(SEL)action title:(NSString *)title bgNormal:(UIColor*)normal bgHighlighted:(UIColor*)highlighted;
// 获取Balance资源
- (NSDictionary*)getServiceSourceWithServiceType:(NSString*)serviceType;

@end
