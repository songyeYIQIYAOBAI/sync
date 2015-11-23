//
//  MappActor.m
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "define.h"
#import "MappActor.h"
#import "MappClient.h"

@implementation MappActor

//#define __OFFLINE_DEMO__

- (void)executeWithRequestEntityList:(NSArray *)requestEntityList callback:(void (^)(int, NSDictionary *))callback {
#ifndef __OFFLINE_DEMO__
    @try {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            NSLog(@"requestEntityList: %@", requestEntityList);
            @try {
                MappClient* client = [MappClient sharedMappClient];
                
                NSMutableDictionary* responseEntity = [NSMutableDictionary dictionaryWithCapacity:0];
                int status = [client callMapp:requestEntityList responseEntities:responseEntity];
                callback(status, responseEntity);
            }
            @catch (NSException *exception) {
                NSLog(@"MappActor::execute:exception=%@", [exception debugDescription]);
            }
        });
    }
    @catch (NSException *exception) {
        NSLog(@"MappActor::execute:exception=%@", [exception debugDescription]);
    }
#else
    
#endif // __OFFLINE_DEMO__
}

- (void)execute:(NSString*)busiCode requestEntity:(NSDictionary *)requestEntity callback:(void (^)(int, NSDictionary *))callback {
#ifndef __OFFLINE_DEMO__
    @try {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            @try {
                MappClient* client = [MappClient sharedMappClient];
                
                NSMutableDictionary* responseEntity = [NSMutableDictionary dictionaryWithCapacity:0];
                int status = [client callMapp:busiCode requestEntity:requestEntity responseEntity:responseEntity];
                
                callback(status, responseEntity);
            }
            @catch (NSException *exception) {
                NSLog(@"MappActor::execute:exception=%@", [exception debugDescription]);
            }
        });
    }
    @catch (NSException *exception) {
        NSLog(@"MappActor::execute:exception=%@", [exception debugDescription]);
    }
#else
    
#endif // __OFFLINE_DEMO__
}

- (void)upload:(NSString*)name mimeType:(NSString*)mimeType data:(NSData *)data callback:(void (^)(int, NSString *))callback {
    @try {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @try {
                MappClient* client = [MappClient sharedMappClient];
                NSString* updateId = [client upload:name mimeType:mimeType data:data];
                
                if (nil != updateId && 0 < [updateId length]) {
                    callback(0, updateId);
                } else {
                    callback(-1, nil);
                }
            }
            @catch (NSException *exception) {
                NSLog(@"MappActor::upload:exception=%@", [exception debugDescription]);
            }
        });
    }
    @catch (NSException *exception) {
        NSLog(@"MappActor::upload:exception=%@", [exception debugDescription]);
    }
}

- (double)doubleValueForObject:(id)obj {
    return ([NSNull null] == obj) ? 0 : [obj doubleValue];
}

- (long long)longLongValueForObject:(id)obj {
    return ([NSNull null] == obj) ? 0 : [obj longLongValue];
}

- (int)intValueForObject:(id)obj {
    return ([NSNull null] == obj) ? 0 : [obj intValue];
}

- (BOOL)boolValueForObject:(id)obj {
    return ([NSNull null] == obj) ? 0 : [obj boolValue];
}

@end
