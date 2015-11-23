//
//  MappClient.m
//  RTSS
//
//  Created by Lyu Ming on 11/4/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#include <time.h>

#import "define.h"
#import "MappClient.h"
#import "Session.h"
#import "RSAUtil.h"
#import "AESUtil.h"
#import "SBJSON.h"

#import "HttpService.h"
#import "HttpDefine.h"
#import "GTMBase64.h"
#import "RTSSNotificationCenter.h"
#import "MappActor.h"



#define __MAPP_WEB_SERVICE__                @"/MWS/servlet/Service"
#define __MAPP_APPLICATION_SERVICE__        @"/MAS/servlet/Service"
#define __MAS_UPLOAD_SERVICE_SPEC__         @"/MAS/servlet/Upload"

//#define __MAPP_SERVICE_SPEC__               @"/MappServer/servlet/Service"  //for v2.0
//#define __MAPP_UPLOAD_SERVICE_SPEC__        @"/MappServer/servlet/Upload"   //for v2.0

#define __MAPP_SERVICE_SPEC__               @"/MappBase2.5/servlet/Service"  //for v2.5
#define __MAPP_UPLOAD_SERVICE_SPEC__        @"/MappBase2.5/servlet/Upload"   //for v2.5

extern int appVersionCode; // APPLICATION_VERSION_CODE
extern BOOL dispatcher; // __SUPPORT_DISPATCHER__

static MappClient* _instance = nil;
static time_t _transactionId = 0;

@interface MappClient () {
    SBJsonParser* _parserMapper;
    SBJsonWriter* _writerMapper;
    
    NSString* _serverAddress;
    NSString* _serviceUrl;
    NSString* _uploadServiceUrl;
    HttpService* _httpClient;
    
    NSDictionary* _keyPair;
    NSData* _transportKey;
    
    NSString* _sessionId;
}

- (NSString*)buildMessage:(NSMutableDictionary*)entity;
- (NSString*)buildMessageForMultipleEntity:(NSArray*)entities;
- (void)parseMessage:(NSString*)message entity:(NSMutableDictionary*)entity;
- (void)parseMessage:(NSString*)message entities:(NSMutableDictionary*)entities;

- (NSString*)getUrl:(NSString*)busiCode;
- (int)handshake;
- (int)setupTransportKey:(NSString*)data;
- (void)notifySessionInvalid;

@end

@implementation MappClient

+ (MappClient*)sharedMappClient {
    @synchronized (self) {
        if (nil == _instance) {
            _instance = [[MappClient alloc] init];
        }
    }
    
    return _instance;
}

+ (void)destroyMappClient {
    @synchronized (self) {
        [_instance release];
        _instance = nil;
    }
}

- (id)init {
    if (self = [super init]) {
        _parserMapper = [[SBJsonParser alloc] init];
        _writerMapper = [[SBJsonWriter alloc] init];
        
        _httpClient = [[HttpService alloc] init];
        
        _transactionId = time(NULL);
    }
    
    return self;
}

- (void)dealloc {
    [_parserMapper release];
    [_writerMapper release];
    
    [_serverAddress release];
    [_serviceUrl release];
    [_uploadServiceUrl release];
    [_httpClient release];
    
    [_keyPair release];
    [_transportKey release];
    
    [_sessionId release];
    
    [super dealloc];
}

+ (NSString*)generateTransactionId {
    NSString* transactionId = [NSString stringWithFormat:@"%016lld", (long long)_transactionId++];
    return transactionId;
}

- (int)prepare:(NSString *)appId andServerAddress:(NSString *)serverAddress andServerPort:(int)serverPort andBaseUrl:(NSString *)baseUrl callback:(void (^)(int))callback {
    int status = 0;
    
    @try {
        _serverAddress = serverAddress;
        _serviceUrl = [[NSString alloc] initWithFormat:@"https://%@:%d%@", serverAddress,serverPort, baseUrl];
        
//        _uploadServiceUrl = [[NSString alloc] initWithFormat:@"%@%@", serverAddress, __MAPP_UPLOAD_SERVICE_SPEC__];
        
        _keyPair = [[RSAUtil generateRSAKeyPair] retain];
        
        status = [self handshake];
    }
    @catch (NSException *exception) {
        NSLog(@"MappClient::prepare:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    @finally {
        if (nil != callback) {
            callback(status);
        }
    }
    
    return status;
}

- (void)prepare:(NSString*)serverAddress callback:(void (^)(int))callback {
    int status = 0;
    
    @try {
        _serverAddress = serverAddress;
        _serviceUrl = [[NSString alloc] initWithFormat:@"%@%@", serverAddress, __MAPP_SERVICE_SPEC__];
        
        _uploadServiceUrl = [[NSString alloc] initWithFormat:@"%@%@", serverAddress, __MAPP_UPLOAD_SERVICE_SPEC__];
        
        _keyPair = [[RSAUtil generateRSAKeyPair] retain];
        
        status = [self handshake];
    }
    @catch (NSException *exception) {
        NSLog(@"MappClient::prepare:exception=%@", [exception description]);
    }
    @finally {
        if (nil != callback) {
            callback(status);
        }
    }
}

- (int)setupTransportKey:(NSString*)data {
    int status = 0;
    
    @try {
        
        if (nil != data) {
            NSData* keyData = [GTMBase64 decodeString:data];
            
            SecKeyRef privateKey = (SecKeyRef)[_keyPair objectForKey:@"PRIVATE_KEY"];
            _transportKey = [[RSAUtil decrypt:keyData key:privateKey] retain];
            NSLog(@"MappClient::setupTransportKey:transportKey=%@", [_transportKey description]);
            
            if (nil == _transportKey || 0 == [_transportKey length]) {
                status = -1;
            }
        } else {
            status = -1;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"MappClient::setupTransportKey:exception=%@", [exception debugDescription]);
        status = -1;
    }
    
    return status;
}

- (int)callMapp:(NSString*)busiCode requestEntity:(NSDictionary*)requestEntity responseEntity:(NSMutableDictionary*)responseEntity {
    int status = 0;
    
    @try {
        NSString* requestMessage = [self buildMessage:[NSMutableDictionary dictionaryWithDictionary:requestEntity]];
        NSLog(@"MappClient::callMapp:request=%@", requestMessage);

        NSString* url = YES == dispatcher ? [self getUrl:busiCode] : _serviceUrl;
        NSLog(@"MappClient::callMapp:url=%@", url);
        
        NSDictionary* header = [NSDictionary dictionaryWithObject:@"application/json" forKey:@"Content-Type"];
        
        NSString* responseMessage = [_httpClient send:url body:requestMessage header:(NSDictionary*)header];
        NSLog(@"MappClient::callMapp:response=%@", responseMessage);
        
        if (nil != responseMessage && 0 < [responseMessage length]) {
            [self parseMessage:responseMessage entity:responseEntity];
        } else {
            status = MappActorFinishStatusNetwork;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"MappClient::callMapp:exception=%@", [exception debugDescription]);
        status = -1;
    }
    
    return status;
}

- (int)callMapp:(NSArray*)requestEntities responseEntities:(NSMutableDictionary*)responseEntities {
    int status = 0;
    
    @try {
        NSString* requestMessage = [self buildMessageForMultipleEntity:requestEntities];
        NSLog(@"MappClient::callMapp:request=%@", requestMessage);
        
        NSLog(@"MappClient::callMapp:url=%@", _serviceUrl);
        
        NSDictionary* header = [NSDictionary dictionaryWithObject:@"application/json" forKey:@"Content-Type"];
        
        NSString* responseMessage = [_httpClient send:_serviceUrl body:requestMessage header:(NSDictionary*)header];
        NSLog(@"MappClient::callMapp:response=%@", responseMessage);
        
        if (nil != responseMessage && 0 < [responseMessage length]) {
            [self parseMessage:responseMessage entities:responseEntities];
        } else {
            status = MappActorFinishStatusNetwork;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"MappClient::callMapp:exception=%@", [exception debugDescription]);
        status = -1;
    }
    
    return status;
}

- (NSString*)upload:(NSString *)name mimeType:(NSString *)mimeType data:(NSData *)data {
    NSString* uploadId = nil;
    
    @try {
        
        NSString* url = YES == dispatcher ? [self getUrl:@"Upload"] : _uploadServiceUrl;
        NSLog(@"MappClient::upload:url=%@", url);
        
        NSDictionary* response = [_httpClient postData:url sessionId:_sessionId method:@"POST" mimeType:mimeType fileName:name data:data];
        NSString* bodyData = [response objectForKey:HTTP_RESPONSE_BODY_DATA_KEY];
        NSDictionary* body = [_parserMapper objectWithString:bodyData];
        
        int errorCode = [[body objectForKey:@"errorCode"] intValue];
        if (0 == errorCode) {
            NSString* value = [body objectForKey:@"id"];
            if (nil != value && 0 < [value length]) {
                uploadId = value;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"MappClient::upload:exception=%@", [exception debugDescription]);
    }
    
    return uploadId;
}

- (NSString*)getUrl:(NSString*)busiCode {
    NSString* url = nil;
    
    @try {
        if (YES == [busiCode isEqualToString:@"Activation"] ||
            YES == [busiCode isEqualToString:@"ChangePassword"] ||
            YES == [busiCode isEqualToString:@"DoTopUp"] ||
            YES == [busiCode isEqualToString:@"GetAccountBalance"] ||
            YES == [busiCode isEqualToString:@"GetUserInfo"] ||
            YES == [busiCode isEqualToString:@"Login"] ||
            YES == [busiCode isEqualToString:@"Logout"] ||
            YES == [busiCode isEqualToString:@"QueryOrderStatus"] ||
            YES == [busiCode isEqualToString:@"QueryProductDetail"] ||
            YES == [busiCode isEqualToString:@"QueryServiceProductOffer"] ||
            YES == [busiCode isEqualToString:@"QueryUsage"] ||
            YES == [busiCode isEqualToString:@"Recharge"] ||
            YES == [busiCode isEqualToString:@"RequestOTP"] ||
            YES == [busiCode isEqualToString:@"ResetUserPassword"] ||
            YES == [busiCode isEqualToString:@"TransferBalance"] ||
            YES == [busiCode isEqualToString:@"VerifyUserIDUniqueness"] ||
            YES == [busiCode isEqualToString:@"GetTransactionRefNum"] ||
            YES == [busiCode isEqualToString:@"SSOLogin"] ||
            YES == [busiCode isEqualToString:@"PushBindxx"]) {
            
            url = [NSString stringWithFormat:@"%@%@", _serverAddress, __MAPP_WEB_SERVICE__];
            
        } else if (YES == [busiCode isEqualToString:@"GenTransferSession"] ||
                   YES == [busiCode isEqualToString:@"JoinTransferSession"] ||
                   YES == [busiCode isEqualToString:@"GetTransKey"] ||
                   YES == [busiCode isEqualToString:@"QueryTransferSessionUsers"] ||
                   YES == [busiCode isEqualToString:@"QueryTransferStatus"] ||
                   YES == [busiCode isEqualToString:@"UpdateTransferStatus"] ||
                   YES == [busiCode isEqualToString:@"UpdateUserPro"]) {
            
            url = [NSString stringWithFormat:@"%@%@", _serverAddress, __MAPP_APPLICATION_SERVICE__];
        } else if (YES == [busiCode isEqualToString:@"Upload"]) {
            url = [NSString stringWithFormat:@"%@%@", _serverAddress, __MAS_UPLOAD_SERVICE_SPEC__];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"MappClient::getUrl:exception=%@", [exception debugDescription]);
    }
    
    return url;
}

- (int)handshake {
    
    int status = 0;
    
    @try {
        SecKeyRef clientPublicKey = (__bridge SecKeyRef)[_keyPair objectForKey:@"PUBLIC_KEY"];
        
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:[NSNumber numberWithInt:0] forKey:@"type"];
        [busiParams setObject:[RSAUtil wrapPublicKey:clientPublicKey] forKey:@"key"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"GetTransKey";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        [requestEntity setObject:[NSNumber numberWithBool:NO] forKey:@"isEncrypt"];
        
        NSMutableDictionary* responseEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        status = [self callMapp:busiCode requestEntity:requestEntity responseEntity:responseEntity];
        
        if (0 == status) {
            int code = [[responseEntity objectForKey:@"code"] intValue];
            if (0 == code) {
                
                NSDictionary* respMsg = [responseEntity objectForKey:@"respMsg"];
                
                NSString* transKey = [respMsg objectForKey:@"transKey"];
                status = [self setupTransportKey:transKey];
                
                NSString* sessionId = [respMsg objectForKey:@"sessionId"];
                NSLog(@"MappClient::handshake:sessionId=%@", sessionId);
                
                _sessionId = [sessionId retain];
                
            } else {
                NSString* message = [responseEntity objectForKey:@"message"];
                NSLog(@"MappClient::handshake:status=%d, message=%@", status, message);
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"MappClient::handshake:exception=%@", [exception debugDescription]);
        status = -1;
    }
    
    return status;
}

- (NSString*)generateTimestamp {
    time_t now = time(NULL);
    struct tm* time = localtime(&now);
    NSString* timestamp = [NSString stringWithFormat:@"%04d%02d%02d%02d%02d%02d",
                           time->tm_year+1900, time->tm_mon+1, time->tm_mday, time->tm_hour, time->tm_min, time->tm_sec];
    return timestamp;
}

- (NSString*)buildMessage:(NSMutableDictionary *)entity {
    NSString* message = nil;
    
    @try {
        
        if (YES == [[entity objectForKey:@"isEncrypt"] boolValue]) {
            NSDictionary* busiParams = [entity objectForKey:@"busiParams"];
            NSString* encryptedBusiParams = [AESUtil encryptJson:busiParams key:_transportKey iv:__AES_IV__];
            [entity setObject:encryptedBusiParams forKey:@"busiParams"];
        }
        
        NSMutableDictionary* pubInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [pubInfo setObject:@"appId" forKey:@"appId"];
        [pubInfo setObject:(nil == _sessionId ? @"" : _sessionId) forKey:@"sessionId"];
        [pubInfo setObject:[NSString stringWithFormat:@"%d", appVersionCode] forKey:@"version"];
        [pubInfo setObject:[self generateTimestamp] forKey:@"timestamp"];
        [pubInfo setObject:@"lang" forKey:@"lang"];
        
        NSMutableDictionary* request = [NSMutableDictionary dictionaryWithCapacity:0];
        [request setObject:pubInfo forKey:@"pubInfo"];
        [request setObject:[NSArray arrayWithObject:entity] forKey:@"requestList"];
        
        message = [_writerMapper stringWithObject:request];
    }
    @catch (NSException *exception) {
        NSLog(@"MappClient::buildMessage:exception=%@", [exception debugDescription]);
    }
    
    return message;
}

- (NSString*)buildMessageForMultipleEntity:(NSArray*)entities {
    NSString* message = nil;
    
    @try {
        
        NSMutableArray* items = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary* entity in entities) {
            NSMutableDictionary* item = [NSMutableDictionary dictionaryWithDictionary:entity];
            [items addObject:item];
            
            if (YES == [[entity objectForKey:@"isEncrypt"] boolValue]) {
                NSDictionary* busiParams = [entity objectForKey:@"busiParams"];
                NSString* encryptedBusiParams = [AESUtil encryptJson:busiParams key:_transportKey iv:__AES_IV__];
                
                [item setObject:encryptedBusiParams forKey:@"busiParams"];
            }
        }
        
        NSMutableDictionary* pubInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [pubInfo setObject:@"appId" forKey:@"appId"];
        [pubInfo setObject:(nil == _sessionId ? @"" : _sessionId) forKey:@"sessionId"];
        [pubInfo setObject:[NSString stringWithFormat:@"%d", appVersionCode] forKey:@"version"];
        [pubInfo setObject:[self generateTimestamp] forKey:@"timestamp"];
        [pubInfo setObject:@"lang" forKey:@"lang"];
        
        NSMutableDictionary* request = [NSMutableDictionary dictionaryWithCapacity:0];
        [request setObject:pubInfo forKey:@"pubInfo"];
        [request setObject:items forKey:@"requestList"];
        
        message = [_writerMapper stringWithObject:request];
    }
    @catch (NSException *exception) {
        NSLog(@"MappClient::buildMessage:exception=%@", [exception debugDescription]);
    }
    
    return message;
}

- (void)parseMessage:(NSString *)message entity:(NSMutableDictionary*)entity {
    
    @try {
        NSDictionary* response = [message JSONValue];
        
        NSDictionary* respInfo = [response objectForKey:@"respInfo"];
        int status = [[respInfo objectForKey:@"code"] intValue];
        
        NSArray* respData = [response objectForKey:@"respData"];
        if (0 == status) {
            
            NSMutableDictionary* responseEntity = [respData objectAtIndex:0];
            int respCode = [[responseEntity objectForKey:@"code"] intValue];
            if (__ISTATUS_SESSION_INVALID__ != respCode) {
                
                if (YES == [[responseEntity objectForKey:@"isEncrypt"] boolValue]) {
                    //当respMsg为NSNull，跳过解密
                    NSString* encryptedRespMsg = [responseEntity objectForKey:@"respMsg"];
                    if ([encryptedRespMsg isKindOfClass:[NSNull class]] == NO) {
                        NSDictionary* respMsg = (NSDictionary*)[AESUtil decryptJson:encryptedRespMsg key:_transportKey iv:__AES_IV__];
                        [responseEntity setObject:respMsg forKey:@"respMsg"];
                    }
                    //
                }
                
                [entity setDictionary:responseEntity];
            } else {
                [self notifySessionInvalid];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"MappClient::parseMessage:exception=%@", [exception debugDescription]);
    }
}

- (void)parseMessage:(NSString *)message entities:(NSMutableDictionary*)entities {
    
    @try {
        NSDictionary* response = [message JSONValue];
        
        NSDictionary* respInfo = [response objectForKey:@"respInfo"];
        int status = [[respInfo objectForKey:@"code"] intValue];
        
        NSArray* respData = [response objectForKey:@"respData"];
        if (0 == status) {
            
            for (NSMutableDictionary* responseEntity in respData) {
                int respCode = [[responseEntity objectForKey:@"code"] intValue];
                if (__ISTATUS_SESSION_INVALID__ != respCode) {
                    
                    if (YES == [[responseEntity objectForKey:@"isEncrypt"] boolValue]) {
                        //当respMsg为NSNull，跳过解密
                        NSString* encryptedRespMsg = [responseEntity objectForKey:@"respMsg"];
                        if ([encryptedRespMsg isKindOfClass:[NSNull class]] == NO) {
                            NSDictionary* respMsg = (NSDictionary*)[AESUtil decryptJson:encryptedRespMsg key:_transportKey iv:__AES_IV__];
                            [responseEntity setObject:respMsg forKey:@"respMsg"];
                        }
                        //
                    }
                    
                    NSString* transactionId = [responseEntity objectForKey:@"transactionId"];
                    [entities setObject:responseEntity forKey:transactionId];
                    
                } else {
                    [self notifySessionInvalid];
                    break;
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"MappClient::parseMessage:exception=%@", [exception debugDescription]);
    }
}

- (void)notifySessionInvalid {
    @try {
        dispatch_async(dispatch_get_main_queue(), ^ {
            [[RTSSNotificationCenter standardRTSSNotificationCenter]
             postNotificationWithType:RTSSNotificationTypeSessionInvalid object:nil
             userInfo:nil];
        });
    }
    @catch (NSException *exception) {
        NSLog(@"MappClient::notifySessionInvalid:exception=%@", [exception debugDescription]);
    }
}

- (NSString*)callWebService:(NSString*)url body:(NSString*)body header:(NSDictionary*)header {
    
    NSString* responseMessage = nil;
    
    @try {
        responseMessage = [_httpClient send:url body:body header:header];
        NSLog(@"MappClient::callWebService:responseMessage=%@", responseMessage);
    }
    @catch (NSException* exception) {
        NSLog(@"MappClient::callWebService:exception=%@", [exception debugDescription]);
    }
    
    return responseMessage;
}

@end
