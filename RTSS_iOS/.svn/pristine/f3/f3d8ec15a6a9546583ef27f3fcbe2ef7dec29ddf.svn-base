//
//  MManager.h
//  RTSS
//
//  Created by 刘艳峰 on 5/11/15.
//  Copyright (c) 2015 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Session.h"
#import "MappClient.h"

@interface MManager : NSObject

@property (nonatomic, retain, readonly) NSString *mVersion;
@property (nonatomic, retain) MappClient *mMappClient;
@property (nonatomic, retain) Session *mSession;

+ (MManager *)sharedMManager;

+ (void)destroyMManager;

//acquire session
- (Session *)getSession;

- (int)init:(NSDictionary *)config;

- (NSDictionary *)queryDeviceInfo;

@end
