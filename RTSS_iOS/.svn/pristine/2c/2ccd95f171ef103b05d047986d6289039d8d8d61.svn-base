//
//  AESUtil.m
//  IOS7Test
//
//  Created by shengyp on 13-12-29.
//  Copyright (c) 2013年 shengyp. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>

#import "AESUtil.h"
#import "GTMBase64.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"

@implementation AESUtil

// 加密方法
+ (NSString*)encrypt:(NSString*)plainText key:(NSData*)key iv:(NSString*)ivString
{
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeAES128) & ~(kCCBlockSizeAES128 - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = [key bytes];
    const void *vinitVec = (const void *) [ivString UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithmAES128,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySizeAES128,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSMutableData *myData = [NSMutableData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [GTMBase64 stringByEncodingData:myData];
	free(bufferPtr);
	
    return result;
}

+ (NSString*)encryptJson:(NSObject *)jsonData key:(NSData *)key iv:(NSString *)ivString {
    NSString* result = nil;
    
    SBJSON* mapper = [[SBJSON alloc] init];
    NSString* jsonText = [mapper stringWithObject:jsonData];
    
    result = [AESUtil encrypt:jsonText key:key iv:ivString];
    
    [mapper release];
    
    return result;
}

// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText key:(NSData*)key iv:(NSString*)ivString
{
    NSData *encryptData = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeAES128) & ~(kCCBlockSizeAES128 - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = [key bytes];
    const void *vinitVec = (const void *) [ivString UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithmAES128,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySizeAES128,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                      length:(NSUInteger)movedBytes]
                                              encoding:NSUTF8StringEncoding] autorelease];
	free(bufferPtr);
	
    return result;
}

+ (NSObject*)decryptJson:(NSString *)encryptText key:(NSData *)key iv:(NSString *)ivString {
    NSObject* result = nil;
    
    NSString* jsonText = [AESUtil decrypt:encryptText key:key iv:ivString];
    result = [jsonText JSONValue];
    
    return result;
}

@end
