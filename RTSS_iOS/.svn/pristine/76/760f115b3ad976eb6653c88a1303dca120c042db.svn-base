//
//  AESUtil.h
//  IOS7Test
//
//  Created by shengyp on 13-12-29.
//  Copyright (c) 2013年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

#define __AES_IV__ @"07A991BB96B249E5"

@interface AESUtil : NSObject

// 加密方法 (key must 16 byte long, ivString must 16 byte long)
+ (NSString*)encrypt:(NSString*)plainText key:(NSData*)key iv:(NSString*)ivString;

+ (NSString*)encryptJson:(NSObject *)jsonData key:(NSData *)key iv:(NSString *)ivString;

// 解密方法 (key must 16 byte long, ivString must 16 byte long)
+ (NSString*)decrypt:(NSString*)encryptText key:(NSData*)key iv:(NSString*)ivString;

+ (NSObject*)decryptJson:(NSString*)encryptText key:(NSData*)key iv:(NSString*)ivString;

@end
