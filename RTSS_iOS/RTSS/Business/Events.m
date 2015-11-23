//
//  Events.m
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "Events.h"
#import "EventItem.h"
#import "RTSSDBModel.h"
#import "RTSSUserDataDB.h"
#import "FMResultSet.h"
#import "Session.h"

@implementation Events

#pragma mark init
+ (Events *)sharedEvents {
    static Events *sharedEvents = nil;
    static dispatch_once_t predict;
    dispatch_once(&predict, ^ {
        sharedEvents = [[Events alloc] init];
    });
    return sharedEvents;
}

#pragma mark query events
- (NSDictionary*)events:(NSArray*)types about:(NSString*)phoneNumber {
    NSMutableDictionary* events = [NSMutableDictionary dictionaryWithCapacity:0];
    
    @try {
        NSString* myId = [Session sharedSession].mMyUser.mId;
        
        if (nil != myId) {
            NSString* typeFilter = @"";
            for (int i=0; i<[types count]; i++) {
                typeFilter = [NSString stringWithFormat:@"%@%@=?%@", typeFilter, EVENT_TYPE_COLUMN, [types count] - 1 > i ? @" OR " : @""];
            }
            NSString* selection = [NSString stringWithFormat:@"%@=? AND %@=? AND (%@)",
                                   EVENT_MYID_COLUMN, EVENT_PEER_PHONENUMBER_COLUMN, typeFilter];
            NSString* sql = [NSString stringWithFormat:@"SELECT %@,%@,%@,%@,%@ FROM %@ WHERE %@ ORDER BY %@ ASC",
                             EVENT_TYPE_COLUMN, EVENT_DESC_COLUMN, EVENT_PARAMETERS_COLUMN, EVENT_PEER_PHONENUMBER_COLUMN, EVENT_TIMESTAMP_COLUMN,
                             EVENT_TABLE_NAME, selection, EVENT_TIMESTAMP_COLUMN];
            
            NSMutableArray* selectionArgs = [NSMutableArray arrayWithCapacity:0];
            [selectionArgs addObject:myId];
            [selectionArgs addObject:phoneNumber];
            for (int i=0; i<[types count]; i++) {
                [selectionArgs addObject:[NSString stringWithFormat:@"%d", [[types objectAtIndex:i] intValue]]];
            }
            
            NSMutableArray* dates = [NSMutableArray arrayWithCapacity:0];
            NSMutableDictionary* itemRegistry = [NSMutableDictionary dictionaryWithCapacity:0];
            
            FMResultSet* resultSet = [[RTSSUserDataDB standardRTSSUserDataDB] query:sql args:selectionArgs];
            while (YES == [resultSet next]) {
                int eventType = [resultSet intForColumn:EVENT_TYPE_COLUMN];
                NSString* description = [resultSet stringForColumn:EVENT_DESC_COLUMN];
                NSDictionary* parameters = [NSKeyedUnarchiver unarchiveObjectWithData:[resultSet dataForColumn:EVENT_PARAMETERS_COLUMN]];
                NSString* peerPhoneNumber = [resultSet stringForColumn:EVENT_PEER_PHONENUMBER_COLUMN];
                long timestamp = [resultSet longForColumn:EVENT_TIMESTAMP_COLUMN];
                
                struct tm* timeInfo = localtime(&timestamp);
                NSString* date = [NSString stringWithFormat:@"%04d%02d%02d", timeInfo->tm_year + 1900, timeInfo->tm_mon + 1, timeInfo->tm_mday];
                
                EventItem* event = [[EventItem alloc] init];
                event.mType = eventType;
                event.mDescription = description;
                event.mParameters = parameters;
                event.mPeerPhoneNumber = peerPhoneNumber;
                event.mTimeStamp = timestamp;
                
                if (nil != [itemRegistry objectForKey:date]) {
                    NSMutableArray* items = [itemRegistry objectForKey:date];
                    [items addObject:event];
                    [event release];
                } else {
                    NSMutableArray* items = [[NSMutableArray alloc] initWithCapacity:0];
                    [items addObject:event];
                    [event release];
                    
                    [itemRegistry setObject:items forKey:date];
                    [dates addObject:[NSNumber numberWithLong:timestamp]];
                }
            }
            
            [events setObject:dates forKey:EVENT_INFO_KEY];
            [events setObject:itemRegistry forKey:EVENT_DATA_KEY];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Events::events:exception=%@", [exception description]);
    }
    
    return events;
}

- (void)addEvent:(EventItem*)event {
    @try {
        NSString* myId = [Session sharedSession].mMyUser.mId;
        
        if (nil != myId) {
            int type = event.mType;
            NSString* description = event.mDescription;
            NSString* peerPhoneNumber = event.mPeerPhoneNumber;
            NSDictionary* parameters = event.mParameters;
            
            NSData* value = nil;
            if (nil != parameters) {
                value = [NSKeyedArchiver archivedDataWithRootObject:parameters];
            }
            
            NSString* sqlString = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@,%@,%@) VALUES (?,?,?,?,?,?)",
                                   EVENT_TABLE_NAME, EVENT_MYID_COLUMN, EVENT_TYPE_COLUMN, EVENT_PEER_PHONENUMBER_COLUMN, EVENT_DESC_COLUMN, EVENT_PARAMETERS_COLUMN, EVENT_TIMESTAMP_COLUMN];
            
           BOOL result= [[RTSSUserDataDB standardRTSSUserDataDB] insert:sqlString
                                                       args:[NSArray arrayWithObjects:myId,
                                                             [NSNumber numberWithInt:type],
                                                             peerPhoneNumber, description, nil != value ? value : @"",
                                                             [NSNumber numberWithLong:(long)time(NULL)], nil]];
            NSLog(@"----->%d",result);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"");
    }
}

@end
