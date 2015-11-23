//
//  UserDefaults.h
//  RTSS
//
//  Created by shengyp on 14/10/24.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

/**
 * App 用户配置信息，统一用这个配置文件保存，获取，删除
 *
 */

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject{
    NSUserDefaults* userDefaults;
}

+ (UserDefaults*)standardUserDefaults;
+ (void)destroy;

- (NSData*)archiveDataWithObject:(id)object;
- (id)unarchiveObjectWithData:(NSData*)data;

// 设置 获取 移除数据归档 根据KEY
- (BOOL)setArchiveDataWithObject:(id)object forKey:(NSString*)key;
- (id)getUnarchiveObjcetWithKey:(NSString*)key;
- (BOOL)removeArchiveDataForKey:(NSString*)key;

// 设置 获取 移除数据对象 根据KEY
- (BOOL)setObject:(id)value forKey:(NSString*)key cipher:(BOOL)isCipher;
- (NSString*)getObjectForKey:(NSString*)key cipher:(BOOL)isCipher;

// 设置 获取 移除数据值 根据KEY
- (BOOL)setValue:(NSString*)value forKey:(NSString*)key cipher:(BOOL)isCipher;
- (NSString*)getValueForKey:(NSString*)key cipher:(BOOL)isCipher;

// 设置 获取 移除对象 根据KEY
- (BOOL)setObject:(id)value forKey:(NSString *)key;
- (id)getObjectForKey:(NSString *)key;
- (BOOL)removeObjectForKey:(NSString *)key;

@end
