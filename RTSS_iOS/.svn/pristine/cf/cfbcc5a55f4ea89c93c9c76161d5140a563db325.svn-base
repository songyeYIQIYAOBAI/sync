//
//  StaticData.m
//  RTSS
//
//  Created by shengyp on 15-1-19.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "StaticData.h"
#import "RTSSAppDefine.h"
#import "CommonUtils.h"

static NSMutableDictionary* appIconDic = nil;
static NSMutableDictionary* assetsRegistry = nil;

@implementation StaticData

//流量单位转long(byte)
+ (long long)measureToLong:(int)measure
{
    long long longValue = 1;
    if(0 == measure){//B
        longValue = RTSS_1BYTE_VALUE;
    }else if(1 == measure){//KB
        longValue = RTSS_1KB_VALUE;
    }else if(2 == measure){//MB
        longValue = RTSS_1MB_VALUE;
    }else if(3 == measure){//GB
        longValue = RTSS_1GB_VALUE;
    }else if(4 == measure){//TB
        longValue = RTSS_1TB_VALUE;
    }
    return longValue;
}

+ (void)initAppIconDic
{
    if(nil == appIconDic){
        appIconDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                      @"app_windows_live_messenger.png",            @"1",
                      @"app_yahoo_messenger.png",                   @"2",
                      @"app_yahoo.png",                             @"3",
                      @"app_yahoo_mail.png",                        @"4",
                      @"app_yahoo_finance.png",                     @"5",
                      @"app_yahoo_fantasy_basketball.png",          @"6",
                      @"app_qq.png",                                @"7",
                      @"app_qzone.png",                             @"8",
                      @"app_skype.png",                             @"9",
                      @"app_youku.png",                             @"10",
                      @"app_chrome.png",                            @"11",
                      @"app_google_map.png",                        @"12",
                      @"app_world_of_warcraft.png",                 @"13",
                      @"app_expedia_hotels_flights.png",            @"14",
                      @"app_liumino.png",                           @"15",
                      @"app_flashlight.png",                        @"16",
                      @"app_disney_storytime.png",                  @"17",
                      @"app_internet.png",                          @"18",
                      @"app_internet.png",                          @"19",
                      @"app_internet.png",                          @"20",
                      @"app_gre.png",                               @"21",
                      @"app_internet.png",                          @"22",
                      @"app_cat_piano.png",                         @"23",
                      @"app_bbc_news.png",                          @"24",
                      @"app_starbucks.png",                         @"25",
                      @"app_internet.png",                          @"26",
                      @"app_internet.png",                          @"27",
                      @"app_internet.png",                          @"28",
                      @"app_youtube.png",                           @"29",
                      @"app_qq_music.png",                          @"30",
                      @"app_evernote.png",                          @"31",
                      @"app_internet.png",                          @"32",
                      @"app_coachs_eye.png",                        @"33",
                      @"app_spotify.png",                           @"34",
                      @"app_napster.png",                           @"35",
                      @"app_windows_media_player.png",              @"36", nil];
    }
}

+ (NSString*)appIconNameByItemId:(NSString*)itemId
{
    if(nil == appIconDic){
        [StaticData initAppIconDic];
    }
    
    NSString* appIconName = @"internet.png";
    NSString* appIconNameTemp = [appIconDic objectForKey:itemId];
    if(nil != appIconNameTemp){
        appIconName = appIconNameTemp;
    }
    return appIconName;
}

+ (void)initAssetsRegistry
{
    if(nil == assetsRegistry){
        assetsRegistry = [[NSMutableDictionary alloc] initWithCapacity:10*5+2];
        
        {
            //1
            [assetsRegistry setValue:@"slider_green_left_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_MINTRACK_NAME_%d", ASSET_ITEM_VOICE_LOCAL]];
            [assetsRegistry setValue:@"slider_green_right_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_RESTTRACK_NAME_%d", ASSET_ITEM_VOICE_LOCAL]];
            [assetsRegistry setValue:@"slider_green_thumb.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_THUMB_NAME_%d", ASSET_ITEM_VOICE_LOCAL]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Name_Voice", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_NAME_%d", ASSET_ITEM_VOICE_LOCAL]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Unit_Voice", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_MEASURE_NAME_%d", ASSET_ITEM_VOICE_LOCAL]];
        }
        
        {
            //2
            [assetsRegistry setValue:@"slider_blue_left_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_MINTRACK_NAME_%d", ASSET_ITEM_VOICE_IDD]];
            [assetsRegistry setValue:@"slider_blue_right_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_RESTTRACK_NAME_%d", ASSET_ITEM_VOICE_IDD]];
            [assetsRegistry setValue:@"slider_blue_thumb.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_THUMB_NAME_%d", ASSET_ITEM_VOICE_IDD]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Name_Idd", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_NAME_%d", ASSET_ITEM_VOICE_IDD]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Unit_Idd", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_MEASURE_NAME_%d", ASSET_ITEM_VOICE_IDD]];
        }

        {
            //3
            [assetsRegistry setValue:@"slider_yellow_left_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_MINTRACK_NAME_%d", ASSET_ITEM_SMS]];
            [assetsRegistry setValue:@"slider_yellow_right_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_RESTTRACK_NAME_%d", ASSET_ITEM_SMS]];
            [assetsRegistry setValue:@"slider_yellow_thumb.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_THUMB_NAME_%d", ASSET_ITEM_SMS]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Name_SMS", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_NAME_%d", ASSET_ITEM_SMS]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Unit_SMS", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_MEASURE_NAME_%d", ASSET_ITEM_SMS]]; //短信条数
            
        }
        
        {
            //4
            [assetsRegistry setValue:@"slider_cyan_left_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_MINTRACK_NAME_%d", ASSET_ITEM_WI_FI]];
            [assetsRegistry setValue:@"slider_cyan_right_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_RESTTRACK_NAME_%d", ASSET_ITEM_WI_FI]];
            [assetsRegistry setValue:@"slider_cyan_thumb.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_THUMB_NAME_%d", ASSET_ITEM_WI_FI]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Name_WIFI", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_NAME_%d", ASSET_ITEM_WI_FI]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Unit_WIFI", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_MEASURE_NAME_%d", ASSET_ITEM_WI_FI]];
        }
        
        {
            //5
            [assetsRegistry setValue:@"slider_brown_left_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_MINTRACK_NAME_%d", ASSET_ITEM_YOUTUBE]];
            [assetsRegistry setValue:@"slider_brown_right_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_RESTTRACK_NAME_%d", ASSET_ITEM_YOUTUBE]];
            [assetsRegistry setValue:@"slider_brown_thumb.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_THUMB_NAME_%d", ASSET_ITEM_YOUTUBE]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Name_YouTube", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_NAME_%d", ASSET_ITEM_YOUTUBE]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Unit_YouTube", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_MEASURE_NAME_%d", ASSET_ITEM_YOUTUBE]];
        }
        
        {
            //6
            [assetsRegistry setValue:@"slider_red_left_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_MINTRACK_NAME_%d", ASSET_ITEM_SKYPE]];
            [assetsRegistry setValue:@"slider_red_right_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_RESTTRACK_NAME_%d", ASSET_ITEM_SKYPE]];
            [assetsRegistry setValue:@"slider_red_thumb.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_THUMB_NAME_%d", ASSET_ITEM_SKYPE]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Name_Skype", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_NAME_%d", ASSET_ITEM_SKYPE]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Unit_Skype", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_MEASURE_NAME_%d", ASSET_ITEM_SKYPE]];
        }
        
        {
            //7
            [assetsRegistry setValue:@"slider_purple_left_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_MINTRACK_NAME_%d", ASSET_ITEM_VAS]];
            [assetsRegistry setValue:@"slider_purple_right_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_RESTTRACK_NAME_%d", ASSET_ITEM_VAS]];
            [assetsRegistry setValue:@"slider_purple_thumb.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_THUMB_NAME_%d", ASSET_ITEM_VAS]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Name_Vas", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_NAME_%d", ASSET_ITEM_VAS]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Unit_Vas", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_MEASURE_NAME_%d", ASSET_ITEM_VAS]];
        }
        
        {
            //8
            [assetsRegistry setValue:@"slider_orange_left_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_MINTRACK_NAME_%d", ASSET_ITEM_DATA]];
            [assetsRegistry setValue:@"slider_orange_right_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_RESTTRACK_NAME_%d", ASSET_ITEM_DATA]];
            [assetsRegistry setValue:@"slider_orange_thumb.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_THUMB_NAME_%d", ASSET_ITEM_DATA]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Name_Data", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_NAME_%d", ASSET_ITEM_DATA]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Unit_Data", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_MEASURE_NAME_%d", ASSET_ITEM_DATA]];
        }
        
        {
            //9
            [assetsRegistry setValue:@"slider_orange_left_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_MINTRACK_NAME_%d", ASSET_ITEM_SPOTIFY]];
            [assetsRegistry setValue:@"slider_orange_right_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_RESTTRACK_NAME_%d", ASSET_ITEM_SPOTIFY]];
            [assetsRegistry setValue:@"slider_orange_thumb.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_THUMB_NAME_%d", ASSET_ITEM_SPOTIFY]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Name_Data", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_NAME_%d", ASSET_ITEM_SPOTIFY]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Unit_Data", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_MEASURE_NAME_%d", ASSET_ITEM_SPOTIFY]];
        }
        
        {
            //10
            [assetsRegistry setValue:@"slider_orange_left_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_MINTRACK_NAME_%d", ASSET_ITEM_NA]];
            [assetsRegistry setValue:@"slider_orange_right_track.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_RESTTRACK_NAME_%d", ASSET_ITEM_NA]];
            [assetsRegistry setValue:@"slider_orange_thumb.png"
                              forKey:[NSString stringWithFormat:@"SLIDER_THUMB_NAME_%d", ASSET_ITEM_NA]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Name_Data", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_NAME_%d", ASSET_ITEM_NA]];
            [assetsRegistry setValue:NSLocalizedString(@"Business_Service_Unit_Data", nil)
                              forKey:[NSString stringWithFormat:@"ITEM_MEASURE_NAME_%d", ASSET_ITEM_NA]];
        }
    }
}

+ (NSMutableDictionary*)getAssetsRegistry
{
    if(nil == assetsRegistry){
        [StaticData initAssetsRegistry];
    }
    
    return assetsRegistry;
}

//解析获取应用列表返回的数据
+ (NSMutableDictionary*)getAppListData:(NSDictionary*)resDictionary
{
    NSMutableDictionary* resultDic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    
    if(nil != resDictionary){
        NSMutableArray* appArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSArray* volumeList = [resDictionary objectForKey:@"volumeList"];
        
        long long totalFlow = 0;
        for (int i = 0; i < [volumeList count]; i ++) {
            
            NSMutableDictionary* appDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            
            NSDictionary* itemDic = [volumeList objectAtIndex:i];
            if(nil != itemDic){
                NSString* itemId = [itemDic objectForKey:@"itemId"];
                if(nil == itemId){
                    itemId = @"";
                }
                NSString* itemName = [itemDic objectForKey:@"itemName"];
                if(nil == itemName){
                    itemName = @"未知";
                }
                NSObject* objectAmount = [itemDic objectForKey:@"usedAmount"];
                long usedAmount = 0;
                if(nil != objectAmount){
                    usedAmount = [[itemDic objectForKey:@"usedAmount"] longValue];
                }
                NSObject* objectMeasure = [itemDic objectForKey:@"usedAmountMeasure"];
                int usedAmountMeasure = 0;
                if(nil != objectMeasure){
                    usedAmountMeasure = [[itemDic objectForKey:@"usedAmountMeasure"] intValue];
                }
                
                //单位long
                long long longUnitValue = [StaticData measureToLong:usedAmountMeasure];
                //一个应用的流量值long
                long long longAppValue = usedAmount*longUnitValue;
                
                //构造新的数据
                NSString* appFlow = [CommonUtils formatDataWithByte:longAppValue decimals:2 unitEnable:YES];
                [appDic setObject:itemId forKey:@"itemId"];
                [appDic setObject:itemName forKey:@"itemName"];
                [appDic setObject:[NSNumber numberWithLong:usedAmount] forKey:@"usedAmount"];
                [appDic setObject:[NSNumber numberWithInt:usedAmountMeasure] forKey:@"usedAmountMeasure"];
                [appDic setObject:[StaticData appIconNameByItemId:itemId] forKey:@"AppIcon"];
                [appDic setObject:appFlow forKey:@"AppFlow"];
                [appDic setObject:[NSNumber numberWithLongLong:longAppValue] forKey:@"AppFlowReal"];
                [appArray addObject:appDic];
                //计算应用总量
                totalFlow+= longAppValue;
            }
            
            [appDic release];
        }
        
        [resultDic setObject:appArray forKey:@"AppList"];
        [resultDic setObject:[NSNumber numberWithLongLong:totalFlow] forKey:@"AppTotal"];
        [appArray release];
    }
    
    return resultDic;
}

//解析应用的月和日数据流量
+ (NSDictionary*)getAppListByMonthData:(NSDictionary*)resDictionary
{
    NSMutableDictionary* resultDic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    
    if(nil != resDictionary){
        NSMutableArray* appListByMonthArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSArray* appVolumeList = [resDictionary objectForKey:@"appVolumeList"];
        
        long totalFlow = 0;
        for (int i = 0; i < [appVolumeList count]; i ++) {
            NSMutableDictionary* oneMonthDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            NSDictionary* itemDic = [appVolumeList objectAtIndex:i];
            if(nil != itemDic){
                NSString* periodDate = [itemDic objectForKey:@"periodDate"];
                if(nil == periodDate){
                    periodDate = @"";
                }
                NSString* periodName = [itemDic objectForKey:@"periodName"];
                if(nil == periodName){
                    periodName = @"";
                }
                NSObject* objectAmount = [itemDic objectForKey:@"usedAmount"];
                long usedAmount = 0;
                if(nil != objectAmount){
                    usedAmount = [[itemDic objectForKey:@"usedAmount"] longValue];
                }
                NSObject* objectMeasure = [itemDic objectForKey:@"usedAmountMeasure"];
                int usedAmountMeasure = 0;
                if(nil != objectMeasure){
                    usedAmountMeasure = [[itemDic objectForKey:@"usedAmountMeasure"] intValue];
                }
                
                //单位long long
                long long longUnitValue = [StaticData measureToLong:usedAmountMeasure];
                //一个月的流量值long
                long long longMonthValue = usedAmount*longUnitValue;
                
                //构造新的数据
                NSString* oneMonthFlow = [CommonUtils formatDataWithByte:longMonthValue decimals:2 unitEnable:YES];
                [oneMonthDic setObject:periodDate forKey:@"periodDate"];
                [oneMonthDic setObject:periodName forKey:@"periodName"];
                [oneMonthDic setObject:[NSNumber numberWithLong:usedAmount] forKey:@"usedAmount"];
                [oneMonthDic setObject:[NSNumber numberWithInt:usedAmountMeasure] forKey:@"usedAmountMeasure"];
                [oneMonthDic setObject:periodName forKey:@"itemName"];
                [oneMonthDic setObject:oneMonthFlow forKey:@"AppFlow"];
                [oneMonthDic setObject:[NSNumber numberWithLongLong:longMonthValue] forKey:@"AppFlowReal"];
                [appListByMonthArray addObject:oneMonthDic];
                
                //计算总量
                totalFlow+=longMonthValue;
            }
            [oneMonthDic release];
        }
        NSString* firstString = @"未知";
        NSString* lastString = @"未知";
        if([appListByMonthArray count] > 0){
            NSMutableDictionary* first = [appListByMonthArray objectAtIndex:0];
            NSMutableDictionary* last = [appListByMonthArray lastObject];
            firstString = [first objectForKey:@"periodName"];
            lastString = [last objectForKey:@"periodName"];
        }
        NSString* monthIntervalString = [[NSString alloc] initWithFormat:@"%@-%@",firstString,lastString];
        [resultDic setObject:appListByMonthArray forKey:@"DateList"];
        [resultDic setObject:monthIntervalString forKey:@"DateInterval"];
        [resultDic setObject:[NSNumber numberWithLong:totalFlow] forKey:@"DateTotal"];
        [appListByMonthArray release];
        [monthIntervalString release];
    }
    
    return resultDic;
}

//解析获取时间列表返回的数据
+ (NSDictionary*)getDateListData:(NSDictionary*)resDictionary
{
    NSMutableDictionary* resultDic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    
    if(nil != resDictionary){
        NSMutableArray* dateArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSArray* volumeList = [resDictionary objectForKey:@"volumeList"];
        
        long long totalFlow = 0;
        for (int i = 0; i < [volumeList count]; i ++) {
            NSMutableDictionary* dateDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            NSDictionary* itemDic = [volumeList objectAtIndex:i];
            if(nil != itemDic){
                NSString* itemId = [itemDic objectForKey:@"itemId"];
                if(nil == itemId){
                    itemId = @"";
                }
                NSString* itemName = [itemDic objectForKey:@"itemName"];
                if(nil == itemName){
                    itemName = @"未知";
                }
                NSObject* objectAmount = [itemDic objectForKey:@"usedAmount"];
                long usedAmount = 0;
                if(nil != objectAmount){
                    usedAmount = [[itemDic objectForKey:@"usedAmount"] longValue];
                }
                NSObject* objectMeasure = [itemDic objectForKey:@"usedAmountMeasure"];
                int usedAmountMeasure = 0;
                if(nil != objectMeasure){
                    usedAmountMeasure = [[itemDic objectForKey:@"usedAmountMeasure"] intValue];
                }
                
                //单位long
                long long longUnitValue = [StaticData measureToLong:usedAmountMeasure];
                //一个应用的流量值long
                long long longAppValue = usedAmount*longUnitValue;
                
                //构造新的数据
                NSString* dateFlow = [CommonUtils formatDataWithByte:longAppValue decimals:2 unitEnable:YES];
                [dateDic setObject:itemId forKey:@"itemId"];
                [dateDic setObject:itemName forKey:@"itemName"];
                [dateDic setObject:[NSNumber numberWithLong:usedAmount] forKey:@"usedAmount"];
                [dateDic setObject:[NSNumber numberWithInt:usedAmountMeasure] forKey:@"usedAmountMeasure"];
                [dateDic setObject:dateFlow forKey:@"AppFlow"];
                [dateDic setObject:[NSNumber numberWithLongLong:longAppValue] forKey:@"AppFlowReal"];
                [dateArray addObject:dateDic];
                //计算应用总量
                totalFlow+= longAppValue;
            }
            [dateDic release];
        }
        [resultDic setObject:dateArray forKey:@"DateList"];
        [resultDic setObject:[NSNumber numberWithLongLong:totalFlow] forKey:@"DateTotal"];
        [dateArray release];
    }
    
    return resultDic;
}

@end
