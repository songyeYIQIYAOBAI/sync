//
//  RTSSUserDataDB.m
//  RTSS
//
//  Created by shengyp on 14/11/3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "RTSSUserDataDB.h"
#import "FileUtils.h"
#import "FMDatabase.h"
#import "RTSSDBModel.h"
#import "Subscriber.h"
#import "EventItem.h"

// 数据库上一版本号是10
#define RTSS_DB_VERSION                             10

// 数据库文件路径
#define RTSS_DB_FILE_PATH                           [FileUtils getDocumentDirectoryByFile:@"rtss_db.sqlite"]

#define NIL_TO_EMPTY(object)                        (object != nil) ? object : @""

#define IS_EMPTY(object)                            (nil == object || 0 == object.length) ? YES : NO

static RTSSUserDataDB* rtssUserDataDB = nil;

@interface RTSSUserDataDB (){
    FMDatabase*                     rtssDB;
}

@end

@implementation RTSSUserDataDB

- (void)dealloc{
    
    [super dealloc];
}

+ (RTSSUserDataDB*)standardRTSSUserDataDB{
    @synchronized(self){
        if(nil == rtssUserDataDB){
            rtssUserDataDB = [[RTSSUserDataDB alloc] init];
        }
    }
    return rtssUserDataDB;
}

- (void)logErrorWithFile:(NSString*)file WithTable:(NSString*)tableString{
    NSLog(@"%@ 文件打开失败, %@ 表创建失败!",file,tableString);
}

- (instancetype)init{
    self = [super init];
    if (self) {
        rtssDB = [[FMDatabase alloc] initWithPath:RTSS_DB_FILE_PATH];
        NSLog(@"path db %@",RTSS_DB_FILE_PATH);
        if(YES == [rtssDB open]){
            // 创建配置表
            if(NO == [self tableExsit:CONFIG_TABLE_NAME]){
                if(YES == [rtssDB executeUpdate:[RTSSDBModel createConfigTableSql]]){
                     [self addConfigDB];
                }
            }
            // 创建朋友表
            if(NO == [self tableExsit:FRIENDS_TABLE_NAME]){
                if(NO == [rtssDB executeUpdate:[RTSSDBModel createFriendsTableSql]]){
                    [self logErrorWithFile:nil WithTable:FRIENDS_TABLE_NAME];
                }
            }
            // 创建事件表
            if(NO == [self tableExsit:EVENT_TABLE_NAME]){
                if(NO == [rtssDB executeUpdate:[RTSSDBModel createEventTableSql]]){
                    [self logErrorWithFile:nil WithTable:EVENT_TABLE_NAME];
                }
            }
            // 创建消息表
            if(NO == [self tableExsit:MESSAGE_TABLE_NAME]){
                if(NO == [rtssDB executeUpdate:[RTSSDBModel createMessageTableSql]]){
                    [self logErrorWithFile:nil WithTable:MESSAGE_TABLE_NAME];
                }
            }
            // 创建发现表
            if (NO == [self tableExsit:FIND_TABLE_NAME]) {
                if (NO == [rtssDB executeUpdate:[RTSSDBModel createFindTableSql]]) {
                    [self logErrorWithFile:nil WithTable:FIND_TABLE_NAME];
                }
            }
            // 创建收藏表
            if (NO == [self tableExsit:COLLECTION_TABLE_NAME]) {
                if (NO == [rtssDB executeUpdate:[RTSSDBModel createCollectionSql]]) {
                    [self logErrorWithFile:nil WithTable:COLLECTION_TABLE_NAME];
                }
            }
            // 根据数据库版本做DB变更
            [self rtssDBChanges];
        }else{
            [self logErrorWithFile:RTSS_DB_FILE_PATH WithTable:nil];
        }
    }
    return self;
}

// 判断是否存在表
- (BOOL)tableExsit:(NSString *)tableName{
    FMResultSet *rs = [rtssDB executeQuery:@"select count(*) as 'count' from sqlite_master where type = 'table' and name = ?", tableName];
    while ([rs next]){
        // just print out what we’ve got in a number of formats.
        int count = [rs intForColumn:@"count"];
        if (0 == count){
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}

#pragma mark ==========数据库变更==========
- (BOOL)addConfigDB
{
    NSString* sqlString = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES(?)", CONFIG_TABLE_NAME, CONFIG_VERSION_COLUMN];
    return [rtssDB executeUpdate:sqlString,[NSNumber numberWithInt:RTSS_DB_VERSION]];
}

- (BOOL)updateConfigDB
{
    NSString* sqlString = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?", CONFIG_TABLE_NAME, CONFIG_VERSION_COLUMN];
    return [rtssDB executeUpdate:sqlString,[NSNumber numberWithInt:RTSS_DB_VERSION]];
}

- (int)getConfigDBVersion
{
    NSString* sqlString = [NSString stringWithFormat:@"SELECT %@ FROM %@ ", CONFIG_VERSION_COLUMN, CONFIG_TABLE_NAME];
    FMResultSet* resultSet = [rtssDB executeQuery:sqlString];
    if([resultSet next]){
        return [resultSet intForColumn:CONFIG_VERSION_COLUMN];
    }
    return RTSS_DB_VERSION;
}

- (BOOL)rtssDBChanges{
    if(RTSS_DB_VERSION > [self getConfigDBVersion]){
        // TODO 做变更
        
        return [self updateConfigDB];
    }
    return NO;
}

- (BOOL)insert:(NSString*)sql args:(NSArray*)args {
    return [rtssDB executeUpdate:sql withArgumentsInArray:args];
}

- (FMResultSet*)query:(NSString *)sql args:(NSArray *)args {
    return [rtssDB executeQuery:sql withArgumentsInArray:args];
}

- (BOOL)update:(NSString *)sql args:(NSArray *)args {
    return [rtssDB executeUpdate:sql withArgumentsInArray:args];
}

- (BOOL)remove:(NSString *)sql args:(NSArray *)args {
    return [rtssDB executeUpdate:sql withArgumentsInArray:args];
}

@end
