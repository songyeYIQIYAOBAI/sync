//
//  RTSSUserDataDBTest.m
//  RTSS
//
//  Created by Lyu Ming on 12/22/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RTSSDBModel.h"
#import "RTSSUserDataDB.h"
#import "FMResultSet.h"

@interface RTSSUserDataDBTest : XCTestCase

@end

@implementation RTSSUserDataDBTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInsert {
    {
        NSString* sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@,%@) VALUES(?,?,?,?,?)",
                         FRIENDS_TABLE_NAME, FRIENDS_ID_COLUMN, FRIENDS_NAME_COLUMN, FRIENDS_PHONENUMBER_COLUMN,
                         FRIENDS_PORTRAIT_COLUMN, FRIENDS_TIMESTAMP_COLUMN];
        [[RTSSUserDataDB standardRTSSUserDataDB] insert:sql
                                                   args:[NSArray arrayWithObjects:@"id", @"name", @"number", @"portrait", [NSNumber numberWithInt:time(NULL)], nil]];
    }
    
    {
        NSString* sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@,%@) VALUES(?,?,?,?,?)",
                         EVENT_TABLE_NAME, EVENT_PEER_PHONENUMBER_COLUMN, EVENT_TYPE_COLUMN, EVENT_DESC_COLUMN,
                         EVENT_PARAMETERS_COLUMN, EVENT_TIMESTAMP_COLUMN];
        [[RTSSUserDataDB standardRTSSUserDataDB] insert:sql
                                                   args:[NSArray arrayWithObjects:@"peerNumber", [NSNumber numberWithInt:1], @"event", @"parameters", [NSNumber numberWithInt:time(NULL)], nil]];
    }
}

- (void)testQuery {
    {
        NSString* sql = [NSString stringWithFormat:@"SELECT %@,%@,%@,%@,%@ FROM %@ WHERE %@ = ?", FRIENDS_ID_COLUMN, FRIENDS_NAME_COLUMN, FRIENDS_PHONENUMBER_COLUMN, FRIENDS_PORTRAIT_COLUMN, FRIENDS_TIMESTAMP_COLUMN, FRIENDS_TABLE_NAME, FRIENDS_PHONENUMBER_COLUMN];
        FMResultSet* resultSet = [[RTSSUserDataDB standardRTSSUserDataDB] query:sql args:[NSArray arrayWithObject:@"number"]];
        while (YES == [resultSet next]) {
            NSLog(@"id=%@, name=%@, number=%@, portrait=%@, timestamp=%d",
                  [resultSet stringForColumn:FRIENDS_ID_COLUMN],
                  [resultSet stringForColumn:FRIENDS_NAME_COLUMN],
                  [resultSet stringForColumn:FRIENDS_PHONENUMBER_COLUMN],
                  [resultSet stringForColumn:FRIENDS_PORTRAIT_COLUMN],
                  [resultSet intForColumn:FRIENDS_TIMESTAMP_COLUMN]);
        }
    }
    
    {
        NSString* sql = [NSString stringWithFormat:@"SELECT %@,%@,%@,%@,%@,%@ FROM %@", EVENT_ID_COLUMN, EVENT_DESC_COLUMN, EVENT_PEER_PHONENUMBER_COLUMN, EVENT_TYPE_COLUMN, EVENT_PARAMETERS_COLUMN, EVENT_TIMESTAMP_COLUMN, EVENT_TABLE_NAME];
        FMResultSet* resultSet = [[RTSSUserDataDB standardRTSSUserDataDB] query:sql args:nil];
        while (YES == [resultSet next]) {
            NSLog(@"id=%@, event=%@, peer=%@, type=%d, parameters=%@, timestamp=%d",
                  [resultSet stringForColumn:EVENT_ID_COLUMN],
                  [resultSet stringForColumn:EVENT_DESC_COLUMN],
                  [resultSet stringForColumn:EVENT_PEER_PHONENUMBER_COLUMN],
                  [resultSet intForColumn:EVENT_TYPE_COLUMN],
                  [resultSet stringForColumn:EVENT_PARAMETERS_COLUMN],
                  [resultSet intForColumn:EVENT_TIMESTAMP_COLUMN]);
        }
    }
}

- (void)testUpdate {
    NSString* sql = [NSString stringWithFormat:@"UPDATE %@ SET %@=? WHERE %@=?", FRIENDS_TABLE_NAME, FRIENDS_TIMESTAMP_COLUMN, FRIENDS_PHONENUMBER_COLUMN];
    [[RTSSUserDataDB standardRTSSUserDataDB] update:sql args:[NSArray arrayWithObjects:[NSNumber numberWithInt:time(NULL)], @"number", nil]];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
