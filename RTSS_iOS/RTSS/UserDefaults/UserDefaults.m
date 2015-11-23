//
//  UserDefaults.m
//  RTSS
//
//  Created by shengyp on 14/10/24.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "UserDefaults.h"
#import "AESUtil.h"

static UserDefaults* userDefaults = nil;

static const char*   aesKey = "asiainfo.com";

@implementation UserDefaults

- (void)dealloc{
    [super dealloc];
}

- (id)init {
    if (self = [super init]) {
        userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

+ (UserDefaults*)standardUserDefaults{
    @synchronized (self) {
        if(nil == userDefaults){
            userDefaults = [[UserDefaults alloc] init];
        }
    }
    return userDefaults;
}

+ (void)destroy{
    @synchronized (self) {
        if(nil != userDefaults){
            [userDefaults release];
            userDefaults = nil;
        }
    }
}

- (NSData*)archiveDataWithObject:(id)object{
    return [NSKeyedArchiver archivedDataWithRootObject:object];
}

- (id)unarchiveObjectWithData:(NSData*)data{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

#pragma mark 设置 获取 移除数据归档 根据KEY
- (BOOL)setArchiveDataWithObject:(id)object forKey:(NSString*)key{
    [userDefaults setObject:[self archiveDataWithObject:object] forKey:key];
    return [userDefaults synchronize];
}

- (id)getUnarchiveObjcetWithKey:(NSString*)key{
    return [self unarchiveObjectWithData:[userDefaults dataForKey:key]];
}

- (BOOL)removeArchiveDataForKey:(NSString*)key{
    [userDefaults removeObjectForKey:key];
    return [userDefaults synchronize];
}

#pragma mark 设置 获取 移除数据字符串 根据KEY
- (BOOL)setObject:(id)value forKey:(NSString*)key cipher:(BOOL)isCipher{
    BOOL status = YES;
    @try {
        if(isCipher){
            NSData* aesKeyData = [NSData dataWithBytes:aesKey length:strlen(aesKey)];
            NSString* encryptedSessionInfo = [AESUtil encryptJson:value key:aesKeyData iv:__AES_IV__];
            
            [userDefaults setObject:encryptedSessionInfo forKey:key];
        }else{
            [userDefaults setObject:value forKey:key];
        }
        status = [userDefaults synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"UserDefaults::setObject:exception=%@", [exception description]);
        status = NO;
    }
    return status;
}

- (id)getObjectForKey:(id)key cipher:(BOOL)isCipher{
    id value = nil;
    
    @try {
        if(isCipher){
            NSString* encryptedValue = [userDefaults objectForKey:key];
            NSData* aesKeyData = [NSData dataWithBytes:aesKey length:strlen(aesKey)];
            value = [AESUtil decryptJson:encryptedValue key:aesKeyData iv:__AES_IV__];
        }else{
            value = [userDefaults objectForKey:key];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"UserDefaults::setObject:exception=%@", [exception description]);
    }
    
    return value;
}

#pragma mark 设置 获取 移除数据值 根据KEY
- (BOOL)setValue:(NSString*)value forKey:(NSString*)key cipher:(BOOL)isCipher{
    BOOL status = NO;
    @try {
        if(isCipher){
            NSData* aesKeyData = [NSData dataWithBytes:aesKey length:strlen(aesKey)];
            NSString* encryptedSessionInfo = [AESUtil encrypt:value key:aesKeyData iv:__AES_IV__];
            [userDefaults setObject:encryptedSessionInfo forKey:key];
        }else{
            [userDefaults setObject:value forKey:key];
        }
        status = [userDefaults synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"UserDefaults::setObject:exception=%@", [exception description]);
    }
    return status;
}

- (NSString*)getValueForKey:(NSString*)key cipher:(BOOL)isCipher{
    NSString* value = nil;
    @try {
        if(isCipher){
            NSString* encryptedValue = [userDefaults objectForKey:key];
            NSData* aesKeyData = [NSData dataWithBytes:aesKey length:strlen(aesKey)];
            value = [AESUtil decrypt:encryptedValue key:aesKeyData iv:__AES_IV__];
        }else{
            value = [userDefaults objectForKey:key];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"UserDefaults::setObject:exception=%@", [exception description]);
    }
    return value;
}

#pragma mark 设置 获取 移除对象 根据KEY
- (BOOL)setObject:(id)value forKey:(NSString *)key{
    [userDefaults setObject:value forKey:key];
    return [userDefaults synchronize];
}

- (id)getObjectForKey:(NSString *)key{
    return [userDefaults objectForKey:key];
}

- (BOOL)removeObjectForKey:(NSString *)key{
    [userDefaults removeObjectForKey:key];
    return [userDefaults synchronize];
}

@end
