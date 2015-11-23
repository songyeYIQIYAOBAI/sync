//
//  FileUtils.h
//  SJB
//
//  Created by sheng yinpeng on 13-7-10.
//  Copyright (c) 2013年 sheng yinpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtils : NSObject

// 获取Root为NSArray的plist文件内容
+ (NSArray*)openPlistFileByArray:(NSString*)plistName;

// 获取Root为NSDictionary的plist文件内容
+ (NSDictionary*)openPlistFileByDictionary:(NSString*)plistName;

// 读取本地文件数据(文件内容编码是NSUTF8StringEncoding)
+ (NSString*)openResourceFile:(NSString*)fileName ofType:(NSString*)ext;

// 读取本地文件数据(文件内容编码是指定编码)
+ (NSString*)openResourceFile:(NSString*)fileName ofType:(NSString*)ext encoding:(NSStringEncoding)enc;

// 创建文件目录
+ (BOOL)creatFilePath:(NSString*)path;

// 获取工程沙盒DOC目录
+ (NSString*)getDocumentDirectory;

// 获取指定文件在工程沙盒DOC目录
+ (NSString*)getDocumentDirectoryByFile:(NSString*)fileName;

// 获取工程沙盒Caches目录
+ (NSString*)getCachesDirectory;

// 获取指定文件在工程沙盒Caches目录
+ (NSString*)getCachesDirectoryByFile:(NSString*)fileName;

// 写文件
+ (BOOL)writeToFileWithPath:(NSString*)path fileData:(NSData*)data;

// 文件是否存在
+ (BOOL)fileExistsAtPath:(NSString*)path;

// 拷贝文件
+ (BOOL)copyItemAtPath:(NSString*)srcPath toPath:(NSString*)dstPath;

// 删除文件及文件夹
+ (BOOL)deleteFilePath:(NSString*)pathString;

@end
