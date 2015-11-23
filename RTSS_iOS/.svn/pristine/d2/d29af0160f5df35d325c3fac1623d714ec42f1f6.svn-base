//
//  Friends.m
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "Friends.h"
#import "RTSSUserDataDB.h"
#import "FMResultSet.h"
#import "RTSSDBModel.h"
#import "Session.h"

@interface Friends () {
    
}

@end

@implementation Friends

+ (Friends *)shareFriends {
    static Friends *sharedFriends = nil;
    static dispatch_once_t predict;
    dispatch_once(&predict, ^ {
        sharedFriends = [[Friends alloc] init];
    });
    return sharedFriends;
}

- (void)dealloc {
    
    [super dealloc];
}

- (NSArray*)friends:(int)limit {
    NSMutableArray* friends = [NSMutableArray arrayWithCapacity:0];
    
    @try {
        NSString* myId = [Session sharedSession].mMyUser.mId;
        
        if (nil != myId) {
            NSString* sql = [NSString stringWithFormat:@"SELECT %@,%@,%@,%@,%@ FROM %@ WHERE %@=? ORDER BY %@ DESC %@",
                             FRIENDS_ID_COLUMN, FRIENDS_NAME_COLUMN, FRIENDS_PHONENUMBER_COLUMN, FRIENDS_PORTRAIT_COLUMN,
                             FRIENDS_TIMESTAMP_COLUMN, FRIENDS_TABLE_NAME, FRIENDS_MYID_COLUMN,
                             FRIENDS_TIMESTAMP_COLUMN, 0 == limit ? @"" : [NSString stringWithFormat:@"LIMIT %d", limit]];
            FMResultSet* resultSet = [[RTSSUserDataDB standardRTSSUserDataDB] query:sql args:[NSArray arrayWithObject:myId]];
            while (YES == [resultSet next]) {
                NSString* userId = [resultSet stringForColumn:FRIENDS_ID_COLUMN];
                NSString* username = [resultSet stringForColumn:FRIENDS_NAME_COLUMN];
                NSString* phoneNumber = [resultSet stringForColumn:FRIENDS_PHONENUMBER_COLUMN];
                NSString* portrait = [resultSet stringForColumn:FRIENDS_PORTRAIT_COLUMN];
                long createTime = [resultSet intForColumn:FRIENDS_TIMESTAMP_COLUMN];
                
                User* friend = [[User alloc] init];
                friend.mId = userId;
                friend.mName = username;
                friend.mPhoneNumber = phoneNumber;
                friend.mPortrait = portrait;
                
                [friends addObject:friend];
                [friend release];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Friends::friends:exception=%@", [exception description]);
    }
    
    return friends;
}

- (void)add:(User *)person {
    @try {
        NSString* myId = [Session sharedSession].mMyUser.mId;
        
        if (nil != myId && nil != person.mId && nil != person.mName && nil != person.mPhoneNumber) {
            RTSSUserDataDB* database = [RTSSUserDataDB standardRTSSUserDataDB];
            
            NSString* querySql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@=? AND %@=?", FRIENDS_SN_COLUMN, FRIENDS_TABLE_NAME, FRIENDS_MYID_COLUMN, FRIENDS_PHONENUMBER_COLUMN];
            FMResultSet* resultSet = [database query:querySql args:[NSArray arrayWithObjects:myId, person.mPhoneNumber, nil]];
            if (YES == [resultSet next]) {
                NSString* sqlString = [NSString stringWithFormat:@"UPDATE %@ SET %@=? WHERE %@=? AND %@=?",
                                       FRIENDS_TABLE_NAME, FRIENDS_TIMESTAMP_COLUMN, FRIENDS_MYID_COLUMN, FRIENDS_PHONENUMBER_COLUMN];
                
                [database update:sqlString args:[NSArray arrayWithObjects:[NSNumber numberWithLong:(long)time(NULL)], myId, person.mPhoneNumber, nil]];
            } else {
                NSString* sqlString = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@,%@,%@) VALUES (?,?,?,?,?,?)",
                                       FRIENDS_TABLE_NAME, FRIENDS_MYID_COLUMN, FRIENDS_ID_COLUMN, FRIENDS_NAME_COLUMN,
                                       FRIENDS_PHONENUMBER_COLUMN, FRIENDS_PORTRAIT_COLUMN, FRIENDS_TIMESTAMP_COLUMN];
                [database insert:sqlString args:[NSArray arrayWithObjects:myId, person.mId, person.mName, person.mPhoneNumber,
                                                 (nil != person.mPortrait ? person.mPortrait : @""),
                                                 [NSNumber numberWithLong:(long)time(NULL)], nil]];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Friends::add:exception=%@", [exception description]);
    }
}

- (void)remove:(User *)person {
    @try {
        NSString* myId = [Session sharedSession].mMyUser.mId;
        
        if (nil != myId) {
            RTSSUserDataDB* database = [RTSSUserDataDB standardRTSSUserDataDB];
            
            NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=? AND %@=?",
                             FRIENDS_TABLE_NAME, FRIENDS_MYID_COLUMN, FRIENDS_PHONENUMBER_COLUMN];
            [database remove:sql args:[NSArray arrayWithObjects:myId, person.mPhoneNumber, nil]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Friends::remove:exception=%@", [exception description]);
    }
}

@end
