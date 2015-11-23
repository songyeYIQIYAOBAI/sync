//
//  RTSSAppDefine.h
//  RTSS
//
//  Created by shengyp on 14/10/22.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

// FMDB need import libsqlite3.dylib

// iphone4 尺寸    {320, 480} iphone5 尺寸   {320, 568}     iphone6   尺寸{375,667}    iphone6plus 尺寸{414, 736}
// iphone4 分辨率  {640, 960} iphone5 分辨率  {640, 1136}    iphone6  分辨率{750,1334}  iphone6plus 分辨率{1080,1920}

#ifndef RTSS_RTSSAppDefine_h
#define RTSS_RTSSAppDefine_h

// 输入文本校验
#define ALPHANUMBER_TEXT                  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789\n"
#define ALPHADECIMAL_TEXT                 @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.\n"
#define ALPHA_TEXT                        @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz\n"
#define NUMBER_TEXT                       @"0123456789\n"

// KEY_WINDOW
#define APPLICATION_KEY_WINDOW          [[UIApplication sharedApplication] keyWindow]

// 屏幕尺寸
#define PHONE_UISCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width

#define PHONE_UISCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height

#define PHONE_UISCREEN_IPHONE4          PHONE_UISCREEN_HEIGHT==480.0f

#define PHONE_UISCREEN_IPHONE5          PHONE_UISCREEN_HEIGHT==568.0f

#define PHONE_UISCREEN_IPHONE6          PHONE_UISCREEN_HEIGHT==667.0f

#define PHONE_UISCREEN_IPHONE6PLUS      PHONE_UISCREEN_HEIGHT==736.0f

// 当前系统版本值
#define SYSTEM_VERSION_FLOAT            [[[UIDevice currentDevice] systemVersion] floatValue]

#define SYSTEM_VERSION_IOS6             6.0<=SYSTEM_VERSION_FLOAT

#define SYSTEM_VERSION_IOS7             7.0<=SYSTEM_VERSION_FLOAT

#define SYSTEM_VERSION_IOS8             8.0<=SYSTEM_VERSION_FLOAT

// 流量数据值和单位
#define RTSS_1BYTE_VALUE                1
#define RTSS_1KB_VALUE                  1024
#define RTSS_1MB_VALUE                  (1024*1024)
#define RTSS_1GB_VALUE                  (1024*1024*1024)
#define RTSS_1TB_VALUE                  (1024*1024*1024*1024ll)

#define RTSS_1BYTE_UNIT                 @"B"
#define RTSS_1KB_UNIT                   @"KB"
#define RTSS_1MB_UNIT                   @"MB"
#define RTSS_1GB_UNIT                   @"GB"
#define RTSS_1TB_UNIT                   @"TB"

// 金额数据值和单位
#define RTSS_1PENNY_VALUE               1
#define RTSS_1YUAN_VALUE                100

// 时间数据值和单位
#define RTSS_1SECOND_VALUE              1
#define RTSS_1MINUTE_VALUE              60
#define RTSS_1HOUR_VALUE                (60 * 60)
#define RTSS_1DAY_VALUE                 (60 * 60 * 24)

#define RTSS_1SECOND_UNIT               @"Sec"
#define RTSS_1MINUTE_UNIT               @"Min"
#define RTSS_1HOUR_UNIT                 @"Hour"
#define RTSS_1DAY_UNIT                  @"Day"

// 消息数据值和单位
#define RTSS_1MSG_VALUE                 1

#define RTSS_1MSG_UNIT                  @"Msg"

// 服务相关
#define ACCOUNT_PREPAID_TYPE            1

// 国际化，根据应用当前语言查到语言包中对应数据
#define RTSSLocalizedString(key, comment)       [[[InternationalControl standerControl] getCurrentBundle] localizedStringForKey:(key) value:@"" table:@""]

// 业务数据
#define TRANSFERABLE_ID_RECEIVE_KEY                     @"TRANSFERABLE_ID_RECEIVE"
#define TRANSFERABLE_NAME_RECEIVE_KEY                   @"TRANSFERABLE_NAME_RECEIVE"
#define TRANSFERABLE_UNIT_RECEIVE_KEY                   @"TRANSFERABLE_UNIT_RECEIVE"
#define TRANSFERABLE_SUBSCRIBERID_RECEIVE_KEY           @"TRANSFERABLE_SUBSCRIBERID_RECEIVE"

#define TRANSFERABLE_ID_GIFT_KEY                        @"TRANSFERABLE_ID_GIFT"
#define TRANSFERABLE_NAME_GIFT_KEY                      @"TRANSFERABLE_NAME_GIFT"
#define TRANSFERABLE_UNIT_GIFT_KEY                      @"TRANSFERABLE_UNIT_GIFT"
#define TRANSFERABLE_VALUE_GIFT_KEY                     @"TRANSFERABLE_VALUE_GIFT"

//
#define __MAPP_SERVER_ADDRESS__                         @"https://124.207.3.44:443"
#define __SUPPORT_DISPATCHER__                          NO
#define __X_API_KEY__                                   @"l7xx68621a3d3f184b7f824fe0a34076803a"
#define __PP_URL_GENERATOR__                            @"https://api.ril.com:7443/pg/Payment/pp/payment/recharge"
#define __RTSS_CHANNEL__                                @"90"
#define __TOPUP_PRODUCTID__                             @"RP450"
#define __TOPUP_ACCOUNT_CHAR_NAME__                     @"TOPUPSHARED_IND"
#define __TOPUP_ACCOUNT_CHAR_VALUE__                    @"ALL"
#define __PP_URL_GENERATE_WITHOUT_MAPP__                NO

#define __MAPP_SERVICE_IPADDRESS__  @"Mapp.Service.IPAddress"
#define __MAPP_SERVICE_PORT__  @"Mapp.Service.Port"
#define __MAPP_SERVICE_BASEURL__  @"Mapp.Service.BaseURL"
#define __PUSH_SERVICE_IPADDRESS__  @"Push.Service.IPAddress"
#define __PUSH_SERVICE_PORT__  @"Push.Service.Port"
#define __MDK_AUTH_APPID__  @"MDK.Auth.AppID"


#endif
