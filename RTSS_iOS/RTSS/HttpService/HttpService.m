//
//  HttpService.m
//  RTSS
//
//  Created by sheng yinpeng on 14-11-03.
//  Copyright (c) 2014年 sheng yinpeng. All rights reserved.
//

#import "HttpService.h"
#import "HttpDefine.h"

@interface MappURLConnection : NSURLConnection {
    NSMutableData* _data;
    void(^_handler)(NSData*);
}

- (instancetype)initWithRequest:(NSURLRequest *)request delegate:(id)delegate completeHandler:(void(^)(NSData*))handler;
- (void)complete:(NSData*)result;
- (void)finish;

@end

@implementation MappURLConnection

- (instancetype)initWithRequest:(NSURLRequest *)request delegate:(id)delegate completeHandler:(void(^)(NSData*))handler {
    if (self = [super initWithRequest:request delegate:delegate]) {
        _data = [[NSMutableData alloc] initWithCapacity:0];
        _handler = handler;
    }
    
    return self;
}

- (void)dealloc {
    [_data release];
    
    [super dealloc];
}

- (void)complete:(NSData *)result {
    if (nil != result) {
        [_data appendData:result];
    }
}

- (void)finish {
    if (nil != _handler) {
        _handler(_data);
    }
}

@end

@interface HttpService () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@end

@implementation HttpService

- (void)dealloc{
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSMutableDictionary*)handleResponse:(NSData*)responseData error:(NSError*)error{
    NSMutableDictionary* responseDic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    if(nil != error){
        NSLog(@"HttpRequestError:%d,%@",(int)[error code],[error description]);
        [responseDic setObject:[NSNumber numberWithInteger:[error code]] forKey:HTTP_RESPONSE_ERROR_CODE_KEY];
        [responseDic setObject:error.localizedDescription forKey:HTTP_RESPONSE_ERROR_MESSAGE_KEY];
    }else{
        NSString* responseString = nil;
        if(nil != responseData){
            NSString* responseStringTemp = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSCharacterSet* control = [NSCharacterSet controlCharacterSet];
            responseString = [responseStringTemp stringByTrimmingCharactersInSet:control];
            [responseStringTemp release];
        }
        if(nil == responseString || responseString.length == 0){
            [responseDic setObject:[NSNumber numberWithInteger:HTTP_CONNECTION_ERROR_CODE] forKey:HTTP_RESPONSE_ERROR_CODE_KEY];
            [responseDic setObject:HTTP_CONNECTION_ERROR_MESSAGE forKey:HTTP_RESPONSE_ERROR_MESSAGE_KEY];
        }else{
            [responseDic setObject:[NSNumber numberWithInteger:HTTP_RESPONSE_OK_CODE] forKey:HTTP_RESPONSE_ERROR_CODE_KEY];
            [responseDic setObject:HTTP_RESPONSE_OK_MESSAGE forKey:HTTP_RESPONSE_ERROR_MESSAGE_KEY];
            [responseDic setObject:responseString forKey:HTTP_RESPONSE_BODY_DATA_KEY];
        }
    }
    return responseDic;
}

- (NSString*)send:(NSString*)urlString body:(NSString*)bodyString header:(NSDictionary*)header {
    // 组装 HTTP
    NSURL* url = [NSURL URLWithString:urlString];
    NSData* bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:HTTP_CONNECTION_TIMEOUT];
    [request setHTTPMethod:@"POST"];
    
    if (nil != header && 0 < [header count]) {
        for (NSString* key in [header allKeys]) {
            [request addValue:[header objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    [request setHTTPBody:bodyData];
    
    // 请求响应返回
    __block BOOL finished = NO;
    __block NSMutableString* responseString = [[[NSMutableString alloc] initWithCapacity:0] autorelease];

    MappURLConnection* mappConnection = [[MappURLConnection alloc] initWithRequest:request delegate:self completeHandler:^(NSData *result) {
        if (nil != result) {
            NSString* responseStringTemp = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            if(nil != responseStringTemp && 0 < [responseStringTemp length]){
                NSCharacterSet* control = [NSCharacterSet controlCharacterSet];
                [responseString setString:[responseStringTemp stringByTrimmingCharactersInSet:control]];
            }
            [responseStringTemp release];
        }
        
        finished = YES;
    }];
    [mappConnection release];
    [request release];
    
    for (int i=0; i<HTTP_CONNECTION_TIMEOUT; i++) {
        NSLog(@"waiting......");
        if (YES == finished) {
            NSLog(@"ready!");
            break;
        }
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    }
    
    return responseString;
}

- (NSDictionary*)postData:(NSString*)urlString method:(NSString*)methodString data:(NSString*)bodyString
{
    // 组装 HTTP
    NSURL* url = [NSURL URLWithString:urlString];
    NSData* bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:HTTP_CONNECTION_TIMEOUT];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    //[request addValue:[NSString stringWithFormat:@"%d",[bodyData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:bodyData];
    
    // 请求响应返回
    NSURLResponse* response;
    NSError* error = nil;
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSMutableDictionary* resultDic = [self handleResponse:responseData error:error];
    [resultDic setObject:methodString forKey:HTTP_REQUEST_METHOD_NAME_KEY];
    NSLog(@"HttpResponse 方法:%@-->报文:%@",methodString, [resultDic objectForKey:HTTP_RESPONSE_BODY_DATA_KEY]);

    [request release];
    
    return resultDic;
}

- (NSDictionary*)postData:(NSString *)urlString sessionId:(NSString*)sessionId method:(NSString*)methodString mimeType:(NSString*)mimeType fileName:(NSString*)fileName data:(NSData*)fileData
{
	// 组装 HTTP
	NSURL* url = [NSURL URLWithString:urlString];
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:HTTP_CONNECTION_TIMEOUT];
	[request setHTTPMethod:@"POST"];
	[request addValue:mimeType forHTTPHeaderField:@"Content-Type"];
	[request addValue:[NSString stringWithFormat:@"attachment;filename=\"%@\"",fileName] forHTTPHeaderField:@"Content-Disposition"];
    [request addValue:sessionId forHTTPHeaderField:@"SessionId"];
	[request setHTTPBody:fileData];
	
	// 请求响应返回
    __block BOOL finished = NO;
    __block NSMutableDictionary* resultDic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    
    MappURLConnection* mappConnection = [[MappURLConnection alloc] initWithRequest:request delegate:self completeHandler:^(NSData *result) {
        if (nil != result) {
            NSDictionary* dict = [self handleResponse:result error:nil];
            [resultDic addEntriesFromDictionary:dict];
            [resultDic setObject:methodString forKey:HTTP_REQUEST_METHOD_NAME_KEY];
            NSLog(@"HttpResponse 文件名称:%@-->报文:%@",fileName, [resultDic objectForKey:HTTP_RESPONSE_BODY_DATA_KEY]);
        }
        
        finished = YES;
    }];
    [mappConnection release];
	[request release];
	
    for (int i=0; i<HTTP_CONNECTION_TIMEOUT * 10; i++) {
        NSLog(@"waiting......");
        if (YES == finished) {
            NSLog(@"ready!");
            break;
        }
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
	return resultDic;
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return (YES == [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]);
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if (YES == [challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [[challenge sender] useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender] continueWithoutCredentialForAuthenticationChallenge: challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"HttpService::didFailWithError:%@", [error debugDescription]);
    
    @try {
        MappURLConnection* mappConnection = (MappURLConnection*)connection;
        if (nil != mappConnection && YES == [mappConnection respondsToSelector:@selector(finish)]) {
            [mappConnection finish];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"HttpService::didFailWithError:%@", [exception description]);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    @try {
        MappURLConnection* mappConnection = (MappURLConnection*)connection;
        if (nil != mappConnection && YES == [mappConnection respondsToSelector:@selector(finish)]) {
            [mappConnection finish];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"HttpService::connectionDidFinishLoading:%@", [exception description]);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    @try {
        if (nil != data) {
            MappURLConnection* mappConnection = (MappURLConnection*)connection;
            if (nil != mappConnection && YES == [mappConnection respondsToSelector:@selector(complete:)]) {
                [mappConnection complete:data];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"HttpService::didReceiveData:%@", [exception description]);
    }
}

@end
