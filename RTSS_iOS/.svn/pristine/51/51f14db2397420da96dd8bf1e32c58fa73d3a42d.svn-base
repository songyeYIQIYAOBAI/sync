//
//  Messages.m
//  librtss
//
//  Created by 刘艳峰 on 4/20/15.
//  Copyright (c) 2015 Ming Lyu. All rights reserved.
//

#import "Messages.h"
#import "RTSSDBModel.h"
#import "RTSSUserDataDB.h"
#import "FMResultSet.h"
#import "MappClient.h"
#import "define.h"
#import "Session.h"

@interface Messages ()

//add message item
- (BOOL)add:(MessageItem *)messageItem;

//query notification
- (int)queryNotificationWithCustomerId:(NSString *)customerId andDelegate:(id<MappActorDelegate>)delegate;

@end

@implementation Messages

- (void)dealloc {
    [super dealloc];
}

//get the unique obj

//return sharedFriends;
+ (Messages *)sharedMessages {
    static Messages *sharedMessages = nil;
    static dispatch_once_t predict;
    dispatch_once(&predict, ^{
        sharedMessages = [[Messages alloc] init];
    });
    return sharedMessages;
}

- (int)pushBindWithCustomerId:(NSString *)customerId andToken:(NSString *)token andDeviceInfo:(NSDictionary *)deviceInfo andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSString* myId = [Session sharedSession].mMyUser.mId;
        
        if (nil != myId) {
            NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
            [busiParams setObject:customerId forKey:@"customerId"];
            [busiParams setObject:token forKey:@"token"];
            //        [busiParams setObject:deviceInfo forKey:@"deviceInfo"];
            
            NSString* transactionId = [MappClient generateTransactionId];
            
            NSString* busiCode = @"PushBind";
            NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
            
            [requestEntity setObject:busiParams forKey:@"busiParams"];
            [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
            
            [requestEntity setObject:busiCode forKey:@"busiCode"];
            [requestEntity setObject:transactionId forKey:@"transactionId"];
            
            [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
                int status = execStatus;
                NSLog(@"%s::%s:responseEntity: %@", __FILE__, __func__, responseEntity);
                
                @try {
                    if (0 == status) {
                        int code = [[responseEntity objectForKey:@"code"] intValue];
                        if (0 == code) {
                            NSDictionary *respMsg = [responseEntity objectForKey:@"respMsg"];
                            NSLog(@"%s :: %@", __func__, respMsg);
                            
                        } else {
                            NSDictionary* message = [responseEntity objectForKey:@"message"];
                            NSLog(@"%s::%s:message=%@", __FILE__,__func__, message);
                            
                            status = code;
                        }
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"%s::%s:exception=%@",__FILE__, __func__, [exception description]);
                    status = MappActorFinishStatusInternalError;
                }
                @finally {
                    if (nil != delegate && [delegate respondsToSelector:@selector(pushBindFinished:)]) {
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            [delegate pushBindFinished:status];
                        });
                    }
                }
            }];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s::%s:exception=%@", __FILE__,  __func__, [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)queryNotificationWithCustomerId:(NSString *)customerId andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:customerId forKey:@"customerId"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QueryNotification";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"%s::%s:responseEntity: %@", __FILE__, __func__, responseEntity);
            
            NSMutableArray *messageList = [NSMutableArray arrayWithCapacity:0];
            NSArray *respMsg = nil;
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        respMsg = [responseEntity objectForKey:@"respMsg"];
                        
                        //sort
                        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mTimeStamp" ascending:NO];
                        NSArray *sortDescriptorList = [NSArray arrayWithObject:sortDescriptor];
                        [sortDescriptor release];
                        respMsg = [respMsg sortedArrayUsingDescriptors:sortDescriptorList];
                        //end of sort
                        
                        //add to db
                        for (NSDictionary *item in respMsg) {
                            NSLog(@"Walter");
                            MessageItem *messageItem = [[MessageItem alloc] init];
                            messageItem.mMessageId = [item objectForKey:@"messageId"];
                            messageItem.mMessageType = [[item objectForKey:@"messageType"] intValue];
                            messageItem.mFromCode = [item objectForKey:@"fromCode"];
                            messageItem.mFromName = [item objectForKey:@"fromName"];
                            messageItem.mTimeStamp = [[item objectForKey:@"timeStamp"] longLongValue];
                            messageItem.mHasRead = NO;
                            
                            NSDictionary *msgObject = [item objectForKey:@"msgObject"];
                            if (messageItem.mMessageType == 1) {
                                messageItem.mTitle = [msgObject objectForKey:@"title"];
                                messageItem.mContent = [msgObject objectForKey:@"content"];
                                messageItem.mHref = [item objectForKey:@"href"];
                            } else if (messageItem.mMessageType == 2) {
                                messageItem.mTitle = [msgObject objectForKey:@"title"];
                                messageItem.mHref = [msgObject objectForKey:@"downloadUrl"];
                            }
                            else {
                            }
                            
                            [[Messages sharedMessages] add:messageItem];
                            
                            [messageList addObject:messageItem];
                            
                            [messageItem release];
                        }
                        //end of add to db
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"%s::%s:message=%@", __FILE__,__func__, message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s::%s:exception=%@",__FILE__, __func__, [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(queryNotificationFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate queryNotificationFinished:status andInfo:messageList];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s::%s:exception=%@", __FILE__,  __func__, [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

//get all messages from db   ..in desc order
- (NSArray *)messagesWithDelegate:(id<MappActorDelegate>)delegate {
    NSMutableArray* messages = [NSMutableArray arrayWithCapacity:0];
    
    @try {
        NSString* myId = [Session sharedSession].mMyUser.mId;
        
        if (nil != myId) {
            NSString* sql = [NSString stringWithFormat:@"SELECT %@,%@,%@,%@,%@,%@,%@,%@,%@ FROM %@ ORDER BY %@ DESC",
                             MESSAGE_ID_COLUMN, MESSAGE_TYPE_COLUMN, MESSAGE_FROMCODE_COLUMN, MESSAGE_FROMNAME_COLUMN, MESSAGE_TITLE_COLUMN, MESSAGE_CONTENT_COLUMN,MESSAGE_TIMESTAMP_COLUMN,MESSAGE_HREF_COLUMN,MESSAGE_READ_COLUMN,MESSAGE_TABLE_NAME,MESSAGE_TIMESTAMP_COLUMN];
            FMResultSet* resultSet = [[RTSSUserDataDB standardRTSSUserDataDB] query:sql args:nil];
            while (YES == [resultSet next]) {
                
                NSString *messageId = [resultSet stringForColumn:MESSAGE_ID_COLUMN];
                int messageType = [resultSet intForColumn:MESSAGE_TYPE_COLUMN];
                NSString *fromCode = [resultSet stringForColumn:MESSAGE_FROMCODE_COLUMN];
                NSString *fromName = [resultSet stringForColumn:MESSAGE_FROMNAME_COLUMN];
                NSString *title = [resultSet stringForColumn:MESSAGE_TITLE_COLUMN];
                NSString *content = [resultSet stringForColumn:MESSAGE_CONTENT_COLUMN];
                long long timeStamp = [resultSet longLongIntForColumn:MESSAGE_TIMESTAMP_COLUMN];
                NSString *href = [resultSet stringForColumn:MESSAGE_HREF_COLUMN];
                BOOL hasRead = [resultSet boolForColumn:MESSAGE_READ_COLUMN];
                
                MessageItem *messageItem = [[MessageItem alloc] init];
                messageItem.mMessageId = messageId;
                messageItem.mMessageType = messageType;
                messageItem.mFromCode = fromCode;
                messageItem.mFromName = fromName;
                messageItem.mTitle = title;
                messageItem.mContent = content;
                messageItem.mTimeStamp = timeStamp;
                messageItem.mHref = href;
                messageItem.mHasRead = hasRead;
                
                [messages addObject:messageItem];
                [messageItem release];
            }
            
            //request from net
            [self queryNotificationWithCustomerId:[Session sharedSession].mMyCustomer.mId andDelegate:delegate];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Messages::messagesWithDelegate:exception=%@", [exception description]);
    }
    
    return messages;
}

//get the selected message items
- (NSArray *)getMessageItemByFromName:(NSString *)fromName {
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
    
    @try {
        NSString* myId = [Session sharedSession].mMyUser.mId;
        
        if (nil != myId) {
            //multiple thread safety
            
#if 0
            //update hasRead to YES
            NSString* updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@=? WHERE %@=?",
                                   MESSAGE_TABLE_NAME, MESSAGE_READ_COLUMN, MESSAGE_FROMNAME_COLUMN];
            [[RTSSUserDataDB standardRTSSUserDataDB] update:updateSql args:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],fromName, nil]];
#endif
            
            //query data by fromName
            NSString* sql = [NSString stringWithFormat:@"SELECT %@,%@,%@,%@,%@,%@,%@,%@,%@ FROM %@ WHERE %@=?",
                             MESSAGE_ID_COLUMN, MESSAGE_TYPE_COLUMN, MESSAGE_FROMCODE_COLUMN, MESSAGE_FROMNAME_COLUMN, MESSAGE_TITLE_COLUMN, MESSAGE_CONTENT_COLUMN,MESSAGE_TIMESTAMP_COLUMN,MESSAGE_HREF_COLUMN,MESSAGE_READ_COLUMN,MESSAGE_TABLE_NAME,
                             MESSAGE_FROMNAME_COLUMN];
            FMResultSet* resultSet = [[RTSSUserDataDB standardRTSSUserDataDB] query:sql args:[NSArray arrayWithObjects:fromName, nil]];
            while (YES == [resultSet next]) {
                
                NSString *messageId = [resultSet stringForColumn:MESSAGE_ID_COLUMN];
                int messageType = [resultSet intForColumn:MESSAGE_TYPE_COLUMN];
                NSString *fromCode = [resultSet stringForColumn:MESSAGE_FROMCODE_COLUMN];
                NSString *fromName = [resultSet stringForColumn:MESSAGE_FROMNAME_COLUMN];
                NSString *title = [resultSet stringForColumn:MESSAGE_TITLE_COLUMN];
                NSString *content = [resultSet stringForColumn:MESSAGE_CONTENT_COLUMN];
                long long timeStamp = [resultSet longLongIntForColumn:MESSAGE_TIMESTAMP_COLUMN];
                NSString *href = [resultSet stringForColumn:MESSAGE_HREF_COLUMN];
                BOOL hasRead = [resultSet boolForColumn:MESSAGE_READ_COLUMN];
                
                MessageItem *messageItem = [[MessageItem alloc] init];
                messageItem.mMessageId = messageId;
                messageItem.mMessageType = messageType;
                messageItem.mFromCode = fromCode;
                messageItem.mFromName = fromName;
                messageItem.mTitle = title;
                messageItem.mContent = content;
                messageItem.mTimeStamp = timeStamp;
                messageItem.mHref = href;
                messageItem.mHasRead = hasRead;
                
                [items addObject:messageItem];
            }
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Messages::getMessageItemByFromName:exception=%@", [exception description]);
    }
    
    return items;
}

//remove the selected message item
- (BOOL)removeItem:(MessageItem *)messageItem {
    @try {
        NSString* myId = [Session sharedSession].mMyUser.mId;
        
        if (nil != myId) {
            RTSSUserDataDB* database = [RTSSUserDataDB standardRTSSUserDataDB];
            
            NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=?",
                             MESSAGE_TABLE_NAME, MESSAGE_ID_COLUMN];
            BOOL result = [database remove:sql args:[NSArray arrayWithObjects:messageItem.mMessageId, nil]];
            
            NSLog(@"%s :: %d", __func__, result);
            return result;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Messages::remove:exception=%@", [exception description]);
    }
    
    return NO;
}

//remove the selected message items
- (BOOL)removeItems:(NSArray *)messages {
    @try {
        NSString* myId = [Session sharedSession].mMyUser.mId;
        
        if (nil != myId) {
            RTSSUserDataDB* database = [RTSSUserDataDB standardRTSSUserDataDB];
            
            NSMutableString *sql = [NSMutableString stringWithCapacity:0];  //查询语句
            NSString* sqlHead = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=?",
                             MESSAGE_TABLE_NAME, MESSAGE_ID_COLUMN];
            [sql appendString:sqlHead];
            
            NSMutableArray *itemIdList = [NSMutableArray arrayWithCapacity:0];  //查询参数数组
            MessageItem *item0 = (MessageItem *)[messages objectAtIndex:0];
            NSString *item0Id = item0.mMessageId;
            [itemIdList addObject:item0Id];
            
            for (int i = 1; i < [messages count]; i ++) {   //第一个Condition已经加到sqlHead了，所以i 从 1 开始递增
                NSString *sqlCondition = [NSString stringWithFormat:@" or %@=?",MESSAGE_ID_COLUMN];
                [sql appendString:sqlCondition];
                
                MessageItem *item = (MessageItem *)[messages objectAtIndex:i];
                NSString *itemId = item.mMessageId;
                [itemIdList addObject:itemId];
            }

            BOOL result = [database remove:sql args:itemIdList];
            
            NSLog(@"%s :: %d", __func__, result);
            return result;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Messages::remove:exception=%@", [exception description]);
    }
    
    return NO;
}

//remove all messages from db
- (BOOL)removeAllMessages {
    @try {
        NSString* myId = [Session sharedSession].mMyUser.mId;
        
        if (nil != myId) {
            RTSSUserDataDB* database = [RTSSUserDataDB standardRTSSUserDataDB];
            
            NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@",
                             MESSAGE_TABLE_NAME];
            BOOL result = [database remove:sql args:[NSArray arrayWithObjects:nil]];
            NSLog(@"%s :: %d", __func__, result);
            
            return result;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Messages::removeAllMessages:exception=%@", [exception description]);
    }
    
    return NO;
}


//add message item
- (BOOL)add:(MessageItem *)messageItem {
    messageItem.mMessageId = messageItem.mMessageId ? messageItem.mMessageId : @"";
    messageItem.mMessageType = messageItem.mMessageType ? messageItem.mMessageType : 0;
    messageItem.mFromCode = messageItem.mFromCode ? messageItem.mFromCode : @"";
    messageItem.mFromName = messageItem.mFromName ? messageItem.mFromName : @"";
    messageItem.mTitle = messageItem.mTitle ? messageItem.mTitle : @"";
    messageItem.mContent = messageItem.mContent ? messageItem.mContent : @"";
    messageItem.mTimeStamp = messageItem.mTimeStamp ? messageItem.mTimeStamp : time(NULL);
    messageItem.mHref = messageItem.mHref ? messageItem.mHref : @"";
    messageItem.mHasRead = messageItem.mHasRead ? messageItem.mHasRead : NO;
    
    @try {
        NSString* myId = [Session sharedSession].mMyUser.mId;
        
        if (nil != myId) {
            NSString* sqlString = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@) VALUES (?,?,?,?,?,?,?,?,?)",
                                   MESSAGE_TABLE_NAME, MESSAGE_ID_COLUMN, MESSAGE_TYPE_COLUMN, MESSAGE_FROMCODE_COLUMN, MESSAGE_FROMNAME_COLUMN, MESSAGE_TITLE_COLUMN, MESSAGE_CONTENT_COLUMN,MESSAGE_TIMESTAMP_COLUMN,MESSAGE_HREF_COLUMN,MESSAGE_READ_COLUMN];
            
            BOOL result= [[RTSSUserDataDB standardRTSSUserDataDB] insert:sqlString
                                                                    args:[NSArray arrayWithObjects:messageItem.mMessageId,
                                                                          [NSNumber numberWithInt:messageItem.mMessageType],
                                                                          messageItem.mFromCode, messageItem.mFromName, messageItem.mTitle,
                                                                          messageItem.mContent, [NSNumber numberWithLongLong:messageItem.mTimeStamp],
                                                                          messageItem.mHref,[NSNumber numberWithBool:messageItem.mHasRead],nil]];
            NSLog(@"%s :: %d", __func__, result);
            
            return result;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Messages::add:exception=%@", [exception description]);
    }

    return NO;
}

//update message item
- (BOOL)updateItem:(MessageItem *)messageItem {
    @try {
        NSString* myId = [Session sharedSession].mMyUser.mId;
        
        if (nil != myId) {

            NSString* sqlString = [NSString stringWithFormat:@"UPDATE %@ SET %@=?,%@=?,%@=?,%@=?,%@=?,%@=?,%@=?,%@=? WHERE %@=?",
                                   MESSAGE_TABLE_NAME, MESSAGE_FROMNAME_COLUMN,MESSAGE_FROMCODE_COLUMN,MESSAGE_TYPE_COLUMN, MESSAGE_TITLE_COLUMN, MESSAGE_CONTENT_COLUMN,MESSAGE_TIMESTAMP_COLUMN,MESSAGE_HREF_COLUMN,MESSAGE_READ_COLUMN,MESSAGE_ID_COLUMN];
            BOOL result = [[RTSSUserDataDB standardRTSSUserDataDB] update:sqlString args:[NSArray arrayWithObjects:messageItem.mFromName,messageItem.mFromCode,[NSNumber numberWithInt:messageItem.mMessageType], messageItem.mTitle,messageItem.mContent,[NSNumber numberWithLongLong:messageItem.mTimeStamp],messageItem.mHref,[NSNumber numberWithBool:messageItem.mHasRead],messageItem.mMessageId, nil]];
            
            NSLog(@"%s :: %d", __func__, result);
            
            return result;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Messages::add:exception=%@", [exception description]);
    }
    
    return NO;
}

- (NSArray *)getFromNamesAndFromCodesFromDB {
    NSMutableArray* nameList = [NSMutableArray arrayWithCapacity:0];
    
    @try {
        NSString* myId = [Session sharedSession].mMyUser.mId;
        
        if (nil != myId) {
            NSString* sql = [NSString stringWithFormat:@"SELECT DISTINCT %@,%@ FROM %@",
                             MESSAGE_FROMNAME_COLUMN,MESSAGE_FROMCODE_COLUMN,MESSAGE_TABLE_NAME];
            FMResultSet* resultSet = [[RTSSUserDataDB standardRTSSUserDataDB] query:sql args:nil];
            while (YES == [resultSet next]) {
                
                NSString *fromName = [resultSet stringForColumn:MESSAGE_FROMNAME_COLUMN];
                NSString *fromCode = [resultSet stringForColumn:MESSAGE_FROMCODE_COLUMN];
                NSDictionary *fromDic = [NSDictionary dictionaryWithObjectsAndKeys:fromName,MESSAGE_FROMNAME_COLUMN,fromCode,MESSAGE_FROMCODE_COLUMN, nil];
                
                [nameList addObject:fromDic];
            }
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Messages::getFromNamesFromDB:exception=%@", [exception description]);
    }
    
    return nameList;
}

@end
