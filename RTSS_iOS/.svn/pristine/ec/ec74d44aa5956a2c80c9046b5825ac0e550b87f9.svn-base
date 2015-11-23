//
//  MManager.m
//  RTSS
//
//  Created by 刘艳峰 on 5/11/15.
//  Copyright (c) 2015 shengyp. All rights reserved.
//

#import "MManager.h"
#import "RTSSAppDefine.h"

static MManager* _instance = nil;

@implementation MManager

@synthesize mVersion;
@synthesize mMappClient;
@synthesize mSession;

+ (MManager *)sharedMManager {
    @synchronized (self) {
        if (nil == _instance) {
            _instance = [[MManager alloc] init];
        }
    }
    
    return _instance;
}

+ (void)destroyMManager {
    @synchronized (self) {
        [_instance release];
        _instance = nil;
    }
}

- (int)init:(NSDictionary *)config {
    int status = MappActorFinishStatusOK;
    
    __block BOOL handShakeFinished = NO;
    @try {
#if 1
        [[MappClient sharedMappClient] prepare:
         [config objectForKey:__MDK_AUTH_APPID__] andServerAddress:
         [config objectForKey:__MAPP_SERVICE_IPADDRESS__] andServerPort:
         [[config objectForKey:__MAPP_SERVICE_PORT__] intValue] andBaseUrl:
         [config objectForKey:__MAPP_SERVICE_BASEURL__] callback:^(int status) {
            @try {
                //
                if (status == MappActorFinishStatusOK) {
                    Session *session = [self getSession];
                    [session load];
                    
                    handShakeFinished = YES;
                }
                
                status = status;
            }
            @catch (NSException *exception) {
                NSLog(@"%s :exception=%@",__func__, [exception description]);
                status = MappActorFinishStatusInternalError;
            };
        }];
#else
        [[MappClient sharedMappClient] prepare:__MAPP_SERVER_ADDRESS__ callback:^(int status) {
            @try {
                //
                if (status == MappActorFinishStatusOK) {
                    Session *session = [self getSession];
                    [session load];
                    
                    handShakeFinished = YES;
                }
                
                status = status;
            }
            @catch (NSException *exception) {
                NSLog(@"%s :exception=%@",__func__, [exception description]);
                status = MappActorFinishStatusInternalError;
            };
        }];
#endif
    }
    @catch (NSException *exception) {
        NSLog(@"%s :exception=%@",__func__, [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    while (NO == handShakeFinished) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    return status;
}

- (NSDictionary *)queryDeviceInfo {
    return nil;
}

- (id)init {
    if (self = [super init]) {
    }
    
    return self;
}

- (void)dealloc {
    [mVersion release];
    [mMappClient release];
    [mSession release];
    
    [super dealloc];
}

- (Session *)getSession {
    self.mSession = [Session sharedSession];
    return self.mSession;
}

@end
