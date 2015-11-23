//
//  RTSSDBModel.h
//  RTSS
//
//  Created by shengyp on 14/11/20.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark ===========配置表============

#define CONFIG_TABLE_NAME                               @"CONFIG_TABLE"

#define CONFIG_VERSION_COLUMN                           @"CONFIG_VERSION"

#pragma mark ===========消息表============

#define MESSAGE_TABLE_NAME                              @"MESSAGE_TABLE"

#define MESSAGE_ID_COLUMN                               @"MESSAGE_ID"
#define MESSAGE_TYPE_COLUMN                             @"MESSAGE_TYPE"
#define MESSAGE_FROMCODE_COLUMN                         @"MESSAGE_FROMCODE"
#define MESSAGE_FROMNAME_COLUMN                         @"MESSAGE_FROMNAME"
#define MESSAGE_TITLE_COLUMN                            @"MESSAGE_TITLE"
#define MESSAGE_CONTENT_COLUMN                          @"MESSAGE_CONTENT"
#define MESSAGE_TIMESTAMP_COLUMN                        @"MESSAGE_TIMESTAMP"
#define MESSAGE_HREF_COLUMN                             @"MESSAGE_HREF"
#define MESSAGE_READ_COLUMN                             @"MESSAGE_READ"

#pragma mark ===========朋友表============

#define FRIENDS_TABLE_NAME                              @"FRIENDS_TABLE"

#define FRIENDS_SN_COLUMN                               @"FRIENDS_SN"
#define FRIENDS_MYID_COLUMN                             @"FRIENDS_MYID"
#define FRIENDS_ID_COLUMN                               @"FRIENDS_ID"
#define FRIENDS_NAME_COLUMN                             @"FRIENDS_NAME"
#define FRIENDS_PHONENUMBER_COLUMN                      @"FRIENDS_PHONENUMBER"
#define FRIENDS_PORTRAIT_COLUMN                         @"FRIENDS_PORTRAIT"
#define FRIENDS_TIMESTAMP_COLUMN                        @"FRIENDS_TIMESTAMP"

#pragma mark ===========事件表============

#define EVENT_TABLE_NAME                                @"EVENT_TABLE"

#define EVENT_ID_COLUMN                                 @"EVENT_ID"
#define EVENT_MYID_COLUMN                               @"EVENT_MYID"
#define EVENT_TYPE_COLUMN                               @"EVENT_TYPE"
#define EVENT_PEER_PHONENUMBER_COLUMN                   @"EVENT_PEER_PHONENUMBER"
#define EVENT_DESC_COLUMN                               @"EVENT_DESC"
#define EVENT_TIMESTAMP_COLUMN                          @"EVENT_TIMESTAMP"
#define EVENT_PARAMETERS_COLUMN                         @"EVENT_PARAMETERS"

#pragma mark ==========发现表===========

#define FIND_TABLE_NAME                                 @"FIND_TABLE"
#define COLLECTION_TABLE_NAME                           @"COLLECTION_TABLE"

#define FIND_COLUMS_SN                                  @"FIND_COLUMS_SN"
#define FIND_COLUMS_ID                                  @"FIND_COLUMS_ID"
#define FIND_COLUMS_TYPE                                @"FIND_COLUMS_TYPE"
#define FIND_COLUMS_CATALOG                             @"FIND_COLUMS_CATALOG"
#define FIND_COLUMS_NAME                                @"FIND_COLUMS_NAME"
#define FIND_COLUMS_TITLE                               @"FIND_COLUMS_TITLE"
#define FIND_COLUMS_DATE                                @"FIND_COLUMS_DATE"
#define FIND_COLUMS_ICON_URL                            @"FIND_COLUMS_ICON_URL"
#define FIND_COLUMS_PIC_URL                             @"FIND_COLUMS_PIC_URL"
#define FIND_COLUMS_DESCRIPTION                         @"FIND_COLUMS_DESCRIPTION"
#define FIND_COLUMS_TARGET_URL                          @"FIND_COLUMS_TARGET_URL"
#define FIND_COLUMS_HOT_COUNT                           @"FIND_COLUMS_HOT_COUNT"
#define FIND_COLUMS_HAS_HOT                             @"FIND_COLUMS_HAS_HOT"
#define FIND_COLUMS_COMMENT_COUNT                       @"FIND_COLUMS_COMMENT_COUNT"
#define FIND_COLUMS_TAG_INFO                            @"FIND_COLUMS_TAG_INFO"
#define FIND_COLUMS_HAS_COLLECT                         @"FIND_COLUMS_HAS_COLLECT"

@interface RTSSDBModel : NSObject

// 创建配置表语句
+ (NSString*)createConfigTableSql;

// 创建朋友表语句
+ (NSString*)createFriendsTableSql;

// 创建事件表语句
+ (NSString*)createEventTableSql;

// 创建消息表语句
+ (NSString*)createMessageTableSql;

// 创建发现表语句
+ (NSString*)createFindTableSql;

// 创建收藏表语句
+ (NSString*)createCollectionSql;

@end
