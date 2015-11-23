//
//  Messages.h
//  librtss
//
//  Created by 刘艳峰 on 4/20/15.
//  Copyright (c) 2015 Ming Lyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageItem.h"
#import "MappActor.h"

@interface Messages : MappActor

//get the unique obj
+ (Messages *)sharedMessages;

//get all messages from db   ..in desc order
- (NSArray *)messagesWithDelegate:(id<MappActorDelegate>)delegate;

//get the selected message items
- (NSArray *)getMessageItemByFromName:(NSString *)fromName;

- (NSArray *)getFromNamesAndFromCodesFromDB;

//remove the selected message item
- (BOOL)removeItem:(MessageItem *)messageItem;

//remove multiple items
- (BOOL)removeItems:(NSArray *)messages;

//remove all messages from db
- (BOOL)removeAllMessages;

//update message item
- (BOOL)updateItem:(MessageItem *)messageItem;

//user binding
- (int)pushBindWithCustomerId:(NSString *)customerId andToken:(NSString *)token andDeviceInfo:(NSDictionary *)deviceInfo andDelegate:(id<MappActorDelegate>)delegate;

@end
