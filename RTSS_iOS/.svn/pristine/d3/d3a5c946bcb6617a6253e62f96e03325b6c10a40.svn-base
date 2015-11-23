//
//  FileUtils.m
//  SJB
//
//  Created by sheng yinpeng on 13-7-10.
//  Copyright (c) 2013年 sheng yinpeng. All rights reserved.
//

#import "FileUtils.h"

@implementation FileUtils

+ (NSArray*)openPlistFileByArray:(NSString*)plistName
{
    NSString* path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:path];
}

+ (NSDictionary*)openPlistFileByDictionary:(NSString*)plistName
{
    NSString* path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

+ (NSString*)openResourceFile:(NSString*)fileName ofType:(NSString*)ext
{
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

+ (NSString*)openResourceFile:(NSString*)fileName ofType:(NSString*)ext encoding:(NSStringEncoding)enc
{
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
    return [NSString stringWithContentsOfFile:path encoding:enc error:nil];
}

+ (BOOL)creatFilePath:(NSString*)path
{
    return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (NSString*)getDocumentDirectory
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if([paths count] > 0){
        return [paths objectAtIndex:0];
    }
    return nil;
}

+ (NSString*)getDocumentDirectoryByFile:(NSString*)fileName
{
    NSString* documentsDirectory = [FileUtils getDocumentDirectory];
    if(nil != documentsDirectory){
        return [documentsDirectory stringByAppendingPathComponent:fileName];
    }
    return nil;
}

+ (NSString*)getCachesDirectory
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if([paths count] > 0){
        return [paths objectAtIndex:0];
    }
    return nil;
}

+ (NSString*)getCachesDirectoryByFile:(NSString*)fileName
{
    NSString* cachesDirectory = [FileUtils getCachesDirectory];
    if(nil != cachesDirectory){
        return [cachesDirectory stringByAppendingPathComponent:fileName];
    }
    return nil;
}

+ (BOOL)writeToFileWithPath:(NSString*)filePath fileData:(NSData*)data
{
    if([FileUtils creatFilePath:[filePath stringByDeletingLastPathComponent]]){
        return [data writeToFile:filePath atomically:YES];
    }
    return NO;
}

+ (BOOL)fileExistsAtPath:(NSString*)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)copyItemAtPath:(NSString*)srcPath toPath:(NSString*)dstPath
{
    return [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:dstPath error:nil];
}

+ (BOOL)deleteFilePath:(NSString*)pathString
{
	if(nil != pathString && pathString.length > 0){
		NSFileManager* fileManager = [NSFileManager defaultManager];
		return [fileManager removeItemAtPath:pathString error:nil];
	}
	return NO;
}

@end
