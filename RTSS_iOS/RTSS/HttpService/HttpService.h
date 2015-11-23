//
//  HttpService.h
//  RTSS
//
//  Created by sheng yinpeng on 14-11-03.
//  Copyright (c) 2014年 sheng yinpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpService : NSObject

- (NSString*)send:(NSString*)urlString body:(NSString*)bodyString header:(NSDictionary*)header;

- (NSDictionary*)postData:(NSString*)urlString method:(NSString*)methodString data:(NSString*)bodyString;

- (NSDictionary*)postData:(NSString *)urlString sessionId:(NSString*)sessionId method:(NSString*)methodString mimeType:(NSString*)mimeType fileName:(NSString*)fileName data:(NSData*)fileData;

@end

@protocol HttpServiceDelegate <NSObject>

@optional
- (void)requestDidFinished:(NSDictionary*)messageDic;

- (void)requestFailed:(NSDictionary*)errorInfo;

@end
