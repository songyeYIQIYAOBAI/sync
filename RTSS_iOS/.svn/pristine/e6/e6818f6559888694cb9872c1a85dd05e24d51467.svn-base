//
//  StaticData.h
//  RTSS
//
//  Created by shengyp on 15-1-19.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ASSET_ITEM_VOICE_LOCAL                  0
#define ASSET_ITEM_VOICE_IDD                    1
#define ASSET_ITEM_SMS                          2
#define ASSET_ITEM_WI_FI                        3
#define ASSET_ITEM_YOUTUBE                      4
#define ASSET_ITEM_SKYPE                        5
#define ASSET_ITEM_VAS                          6
#define ASSET_ITEM_DATA                         7
#define ASSET_ITEM_SPOTIFY                      8
#define ASSET_ITEM_NA                           9

@interface StaticData : NSObject

+ (long long)measureToLong:(int)measure;

+ (NSString*)appIconNameByItemId:(NSString*)itemId;

+ (NSMutableDictionary*)getAssetsRegistry;

//解析获取应用列表返回的数据
+ (NSMutableDictionary*)getAppListData:(NSDictionary*)resDictionary;

//解析应用的月和日数据流量
+ (NSDictionary*)getAppListByMonthData:(NSDictionary*)resDictionary;

//解析获取时间列表返回的数据
+ (NSDictionary*)getDateListData:(NSDictionary*)resDictionary;

@end
