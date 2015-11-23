//
//  UserDataConfig.m
//  EasyTT
//
//  Created by shengyp on 14-2-18.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "C3DataConfig.h"
#import "FileUtils.h"

#define USERDATA_C3_PATH [FileUtils getDocumentDirectoryByFile:@"userdata_c3.plist"]
#define USERDATA_C3_FILE_NAME @"userdata_c3"

static C3DataConfig* userDataConfig = nil;

@implementation C3DataConfig

- (void)dealloc
{
    [userDataByC3Dic release];
    [userDataByC3FileDic release];
    
    [super dealloc];
}

- (id)init
{
    if(self = [super init]){
        userDataByC3Dic = [[NSMutableDictionary alloc] initWithCapacity:0];
        userDataByC3FileDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

+ (C3DataConfig*)standardC3DataConfig
{
    @synchronized(self){
        if(nil == userDataConfig){
            userDataConfig = [[C3DataConfig alloc] init];
        }
    }
    return userDataConfig;
}

+ (void)destroy
{
    @synchronized(self){
        if(nil != userDataConfig){
            [userDataConfig release];
            userDataConfig = nil;
        }
    }
}

- (BOOL)saveUserDataC3
{
    if(nil != userDataByC3Dic && [[userDataByC3Dic allKeys] count] > 0){
        return [userDataByC3Dic writeToFile:USERDATA_C3_PATH atomically:YES];
    }
    return NO;
}

- (void)readUserDataC3
{
    NSDictionary* tempDic = [FileUtils openPlistFileByDictionary:USERDATA_C3_FILE_NAME];
    if(nil != tempDic){
        [userDataByC3FileDic setDictionary:tempDic];
    }
}

- (void)setUserDataByC3:(NSDictionary*)dataListDic dataKey:(NSString*)dataKey
{
    if(nil != dataListDic && nil != dataKey){
        [userDataByC3Dic setObject:dataListDic forKey:dataKey];
    }
}

- (NSDictionary*)getUserDataByC3WithDataKey:(NSString*)dataKey
{
    if(nil != dataKey){
        return [userDataByC3FileDic objectForKey:dataKey];
    }
    return nil;
}

@end
