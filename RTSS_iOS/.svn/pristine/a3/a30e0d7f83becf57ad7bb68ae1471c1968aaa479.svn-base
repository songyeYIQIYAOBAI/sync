//
//  UserDataConfig.h
//  EasyTT
//
//  Created by shengyp on 14-2-18.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface C3DataConfig : NSObject
{
    NSMutableDictionary* userDataByC3Dic;
    NSMutableDictionary* userDataByC3FileDic;
}

+ (C3DataConfig*)standardC3DataConfig;
+ (void)destroy;

// 设置C3缓存数据
- (void)readUserDataC3;
- (BOOL)saveUserDataC3;

- (void)setUserDataByC3:(NSDictionary*)dataListDic dataKey:(NSString*)dataKey;
- (NSDictionary*)getUserDataByC3WithDataKey:(NSString*)dataKey;

@end
