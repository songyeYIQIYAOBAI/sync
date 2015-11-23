//
//  MappClient.h
//  RTSS
//
//  Created by Lyu Ming on 11/4/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MappClient : NSObject

+ (MappClient*)sharedMappClient;
+ (void)destroyMappClient;

+ (NSString*)generateTransactionId;

- (void)prepare:(NSString*)serverAddress callback:(void(^)(int))callback;

- (int)prepare:(NSString *)appId andServerAddress:(NSString *)serverAddress andServerPort:(int)serverPort andBaseUrl:(NSString *)baseUrl callback:(void(^)(int))callback;

- (int)callMapp:(NSString*)busiCode requestEntity:(NSDictionary*)requestEntity responseEntity:(NSMutableDictionary*)responseEntity;
- (int)callMapp:(NSArray*)requestEntities responseEntities:(NSMutableDictionary*)responseEntities;
- (NSString*)upload:(NSString*)name mimeType:(NSString*)mimeType data:(NSData*)data;
- (NSString*)callWebService:(NSString*)url body:(NSString*)body header:(NSDictionary*)header;

@end
