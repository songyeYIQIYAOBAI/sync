//
//  User.m
//  RTSS
//
//  Created by Lyu Ming on 11/24/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#include <time.h>

#import "define.h"
#import "User.h"
#import "MappClient.h"
#import "Customer.h"
#import "AESUtil.h"
#import "Session.h"
#import "UIDevice+Extend.h"
#import "MManager.h"

#define __KEY_USER_NAME__ @"USER_NAME"
#define __KEY_USER_PASSWORD__ @"USER_PASSWORD"
#define __KEY_USER_PORTRAIT__ @"USER_PORTRAIT"

@interface User ()

- (int)requestOTP:(NSString*)userId phoneNumber:(NSString*)phoneNumber action:(int)action delegate:(id<MappActorDelegate>)delegate;
- (int)updateProperty:(NSString*)property value:(NSString*)value delegate:(id<MappActorDelegate>)delegate;

@end

@implementation User

@synthesize mId;
@synthesize mName;
@synthesize mPassword;
@synthesize mPhoneNumber;
@synthesize mEmail;
@synthesize mPortrait;

@synthesize mType;

@synthesize runLoopEnd;

extern int appVersionCode; // APPLICATION_VERSION_CODE

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.mName = [aDecoder decodeObjectForKey:__KEY_USER_NAME__];
    self.mPassword = [aDecoder decodeObjectForKey:__KEY_USER_PASSWORD__];
    self.mPortrait = [aDecoder decodeObjectForKey:__KEY_USER_PORTRAIT__];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:mName forKey:__KEY_USER_NAME__];
    [aCoder encodeObject:mPassword forKey:__KEY_USER_PASSWORD__];
    [aCoder encodeObject:mPortrait forKey:__KEY_USER_PORTRAIT__];
}

- (void)dealloc {
    [mName release];
    [mPassword release];
    [mPortrait release];
    
    [super dealloc];
}

- (int)checkVersionWithDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:[NSNumber numberWithInt:appVersionCode] forKey:@"version"];
        [busiParams setObject:[NSNumber numberWithInt:2] forKey:@"os"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"CheckVersion";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"%s ::responseEntity: %@", __func__, responseEntity);
            
            NSDictionary *respMsg = nil;
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        respMsg = [responseEntity objectForKey:@"respMsg"];
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"%s ::message=%@", __func__ ,message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s :exception=%@",__func__, [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(checkVersionFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate checkVersionFinished:status andInfo:respMsg];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s:exception=%@", __func__, [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)verifyUserId:(NSString*)userId delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:userId forKey:@"userId"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"VerifyUserIDUniqueness";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            NSArray* suggestedUserIds = nil;
            @try {
                
                if (0 == status) {
                    if (nil != responseEntity && nil != [responseEntity objectForKey:@"code"]) {
                        
                        int code = [[responseEntity objectForKey:@"code"] intValue];
                        if (__ISTATUS_USERID_OCCUPIED__ == code) {
                            status = MappActorFinishStatusUserIdDuplicate;
                        } else {
                            status = code;
                        }
                        
                    } else {
                        status = MappActorFinishStatusInternalError;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"User::verifyUserId:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(verifyUserIdFinished:suggestedUserIds:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate verifyUserIdFinished:status suggestedUserIds:suggestedUserIds];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"User::verifyUserId:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)requestActivationOTP:(NSString *)userId phoneNumber:(NSString *)phoneNumber delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    status = [self requestOTP:userId phoneNumber:phoneNumber action:1 delegate:delegate];
    
    return status;
}

- (int)requestLoginOTP:(NSString *)userId delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    status = [self requestOTP:userId phoneNumber:nil action:2 delegate:delegate];
    
    return status;
}

- (int)requestResetPasswordOTP:(NSString *)userId delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    status = [self requestOTP:userId phoneNumber:nil action:3 delegate:delegate];
    
    return status;
}

- (int)requestOTP:(NSString*)userId phoneNumber:(NSString*)phoneNumber action:(int)action delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:userId forKey:@"userId"];
        if (1 == action) {
            [busiParams setObject:phoneNumber forKey:@"phoneNumber"];
        }
        [busiParams setObject:[NSNumber numberWithInt:action] forKey:@"action"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"RequestOTP";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary* responseEntity) {
            int status = execStatus;
            
            @try {
                
                if (0 == status) {
                    if (nil != responseEntity && nil != [responseEntity objectForKey:@"code"]) {
                        
                        int code = [[responseEntity objectForKey:@"code"] intValue];
                        if (0 == code){
                            status = MappActorFinishStatusOK;
                        } else if (__ISTATUS_USER_REACTIVATE__ == code) {
                            status = MappActorFinishStatusAlreadyActivated;
                        } else {
                            NSDictionary* message = [responseEntity objectForKey:@"message"];
                            NSLog(@"User::requestOTP:message=%@", message);
                            
                            status = code;
                        }
                        
                    } else {
                        status = MappActorFinishStatusInternalError;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"User::requestOTP:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(requestOTPFinished:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate requestOTPFinished:status];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"User::requestOTP:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)activation:(NSString *)userId
              otp:(NSString *)otp
    desiredUserId:(NSString *)desiredUserId
  desiredPassword:(NSString *)desiredPassword
         delegate:(id<MappActorDelegate>)delegate {
    
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:userId forKey:@"userId"];
        [busiParams setObject:otp forKey:@"otp"];
        [busiParams setObject:desiredUserId forKey:@"newUserId"];
        [busiParams setObject:desiredPassword forKey:@"newPassword"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"Activation";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            NSArray* suggestedUserIds = nil;
            @try {
                
                if (0 == status) {
                    if (nil != responseEntity && nil != [responseEntity objectForKey:@"code"]) {
                        
                        int code = [[responseEntity objectForKey:@"code"] intValue];
                        if (__ISTATUS_USERID_OCCUPIED__ == code) {
                            status = MappActorFinishStatusUserIdDuplicate;
                        } else if (__ISTATUS_USER_REACTIVATE__ == code) {
                            status = MappActorFinishStatusAlreadyActivated;
                        } else {
                            status = code;
                        }
                        
                        if (0 != code) {
                            NSDictionary* message = [responseEntity objectForKey:@"message"];
                            NSLog(@"User::activation:message=%@", message);
                            
                            NSDictionary* respMsg = [responseEntity objectForKey:@"respMsg"];
                            suggestedUserIds = [respMsg objectForKey:@"suggestion"];
                            NSLog(@"User::activation:suggestedUserIds=%@", [suggestedUserIds description]);
                        }
                        
                    } else {
                        status = MappActorFinishStatusInternalError;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"User::activation:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(activationFinished:suggestedUserIds:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate activationFinished:status suggestedUserIds:suggestedUserIds];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"User::activation:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)resetPassword:(NSString*)userId otp:(NSString *)otp desiredPassword:(NSString*)desiredPassword delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:userId forKey:@"userId"];
        [busiParams setObject:otp forKey:@"otp"];
        [busiParams setObject:desiredPassword forKey:@"desiredPassword"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"ResetUserPassword";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            @try {
                
                if (0 == status) {
                    if (nil != responseEntity && nil != [responseEntity objectForKey:@"code"]) {
                        
                        int code = [[responseEntity objectForKey:@"code"] intValue];
                        if (0 != code) {
                            NSDictionary* message = [responseEntity objectForKey:@"message"];
                            NSLog(@"User::resetPassword:message=%@", message);
                            
                            status = code;
                        }
                        
                    } else {
                        status = MappActorFinishStatusInternalError;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"User::resetPassword:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(resetPasswordFinished:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate resetPasswordFinished:status];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"User::resetPassword:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)login:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    status = [self login:nil password:nil rememberMe:NO delegate:delegate];
    
    return status;
}

- (int)login:(NSString*)userId password:(NSString*)password rememberMe:(BOOL)rememberMe delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        if (nil != userId && nil != password) {
            [busiParams setObject:userId forKey:@"userId"];
            [busiParams setObject:password forKey:@"password"];
            
            if (YES == rememberMe) {
                [busiParams setObject:[NSNumber numberWithInt:3] forKey:@"type"];
                
                NSDictionary* deviceInfo = [[UIDevice currentDevice] getDeviceInfo];
                [busiParams setObject:deviceInfo forKey:@"deviceInfo"];
            } else {
                [busiParams setObject:[NSNumber numberWithInt:1] forKey:@"type"];
            }
            
        } else {
            [busiParams setObject:[Session sharedSession].mJToken forKey:@"jToken"];

            [busiParams setObject:[NSNumber numberWithInt:2] forKey:@"type"];
            
            NSDictionary* deviceInfo = [[UIDevice currentDevice] getDeviceInfo];
            [busiParams setObject:deviceInfo forKey:@"deviceInfo"];
        }
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"Login";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary* responseEntity) {
            int status = execStatus;
            NSLog(@"%s :: responseEntity: %@", __func__,responseEntity);
            Customer* customer = nil;
            @try {
                
                if (0 == status) {
                    if (nil != responseEntity && nil != [responseEntity objectForKey:@"code"]) {
                        
                        int code = [[responseEntity objectForKey:@"code"] intValue];
                        if (0 == code) {
                            
                            if (nil != userId && nil != password) {
                                self.mId = userId;
                                self.mPassword = password;
                            }
                            
                            NSDictionary* respMsg = [responseEntity objectForKey:@"respMsg"];
                            
                            NSDictionary* customerInfo = [respMsg objectForKey:@"customer"];
                            NSString* customerId = [customerInfo objectForKey:@"customerId"];
                            
                            customer = [[Customer alloc] init];
                            customer.mId = customerId;
                                                        
                            [Session sharedSession].mMyUser = self;
                            [Session sharedSession].mMyCustomer = customer;
                            
                            NSString* sessionToken = [respMsg objectForKey:@"ssoToken"];
                            NSLog(@"User::login:sessionToken=%@", sessionToken);
                            
                            if (nil != sessionToken) {
                                [Session sharedSession].mToken = sessionToken;
                            }
                            
                            NSString *jToken = [respMsg objectForKey:@"jToken"];
                            if (nil != jToken) {
                                [Session sharedSession].mJToken = jToken;
                            }
                            
                            [[Session sharedSession] save];
                            
                            self.runLoopEnd = YES;
                            
                        } else if (__ISTATUS_USER_LOCKED__ == code) {
                            NSDictionary* message = [responseEntity objectForKey:@"message"];
                            NSLog(@"User::login:message=%@", message);
                            
                            status = MappActorFinishStatusUserLocked;
                        } else {
                            NSDictionary* message = [responseEntity objectForKey:@"message"];
                            NSLog(@"User::login:message=%@", message);
                            
                            status = code;
                        }
                    } else {
                        status = MappActorFinishStatusInternalError;
                    }
                }
                
            }
            @catch (NSException *exception) {
                NSLog(@"User::login:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if(nil != delegate && [delegate respondsToSelector:@selector(loginFinished:customer:)]){
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate loginFinished:status customer:customer];
                    });
                }
            }
            
            [customer release];
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"User::login:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)login:(NSString*)customerId ssoToken:(NSString*)ssoToken delegate:(id<MappActorDelegate>)delegate {
    
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableArray *requestEntityList = [NSMutableArray array];
        NSArray *busiCodes = [NSArray arrayWithObjects:@"SSOLogin",@"QueryCustomer", nil];  // busiCode list
        
        NSString* ssoLoginTransactionId = [MappClient generateTransactionId];               //sso transactionId
        NSString* queryCustomerTransactionId = [MappClient generateTransactionId];          //queryCustomer transactionId
        for (NSString *busiCode in busiCodes) {
            NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
            NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
            
            if ([busiCode isEqualToString:@"SSOLogin"]) {
                [busiParams setObject:customerId forKey:@"customerId"];
                [busiParams setObject:ssoToken forKey:@"ssoToken"];
                [requestEntity setObject:ssoLoginTransactionId forKey:@"transactionId"];
            } else {
                [busiParams setObject:[NSNumber numberWithInt:1] forKey:@"type"];
                [busiParams setObject:self.mId forKey:@"condition"];
                [requestEntity setObject:queryCustomerTransactionId forKey:@"transactionId"];
            }
            
            [requestEntity setObject:busiParams forKey:@"busiParams"];
            [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
            
            [requestEntity setObject:busiCode forKey:@"busiCode"];
            
            [requestEntityList addObject:requestEntity];
        }
    
        [self executeWithRequestEntityList:requestEntityList callback:^(int execStatus, NSDictionary *responseEntity) {
            NSLog(@"User::login:responseEntity: %@", responseEntity);
            int status = execStatus;
            Customer* customer = nil;
            @try {
                
                if (0 == status) {
                    if (nil != responseEntity) {
                        NSDictionary *ssoLoginResponseEntity = [responseEntity objectForKey:ssoLoginTransactionId];
                        if (nil != ssoLoginResponseEntity) {
                            int code = [[ssoLoginResponseEntity objectForKey:@"code"] intValue];
                            if (0 == code) {
                                [Session sharedSession].mMyUser = self;
                                [Session sharedSession].mToken = ssoToken;
                                
                                //if SSOLogin succeed, then QueryCustomer
                                NSDictionary *queryCustomerResponseEntity = [responseEntity objectForKey:queryCustomerTransactionId];
                                if (nil != queryCustomerResponseEntity) {
                                    code = [[queryCustomerResponseEntity objectForKey:@"code"] intValue];
                                    if (0 == code) {
                                        NSDictionary *respMsg = [queryCustomerResponseEntity objectForKey:@"respMsg"];
                                        NSDictionary* customerInfo = [respMsg objectForKey:@"customerInfo"];
                                        NSString* customerId = [customerInfo objectForKey:@"customerId"];
                                        
                                        customer = [[Customer alloc] init];
                                        customer.mId = customerId;

                                        [Session sharedSession].mMyCustomer = customer;
                                        [[Session sharedSession] save];
                                        
                                        self.runLoopEnd = YES;
                                    } else {
                                        NSDictionary* message = [ssoLoginResponseEntity objectForKey:@"message"];
                                        NSLog(@"User::login:message=%@", message);
                                        
                                        status = code;
                                    }
                                } else {
                                    status = MappActorFinishStatusInternalError;
                                }

                            }
                            else {
                                NSDictionary* message = [ssoLoginResponseEntity objectForKey:@"message"];
                                NSLog(@"User::login:message=%@", message);
                                
                                status = code;
                            }
                        }
                        else {
                            status = MappActorFinishStatusInternalError;
                        }
                    
                        
                    } else {
                        status = MappActorFinishStatusInternalError;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"User::login:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(loginFinished:customer:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate loginFinished:status customer:customer];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"User::login:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)logout:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {        
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:[Session sharedSession].mToken forKey:@"ssoToken"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"Logout";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            @try {
                
                if (0 == status) {
                    if (nil != responseEntity && nil != [responseEntity objectForKey:@"code"]) {
                        int code = [[responseEntity objectForKey:@"code"] intValue];
                        if (0 != code) {
                            NSDictionary* message = [responseEntity objectForKey:@"message"];
                            NSLog(@"User::logout:message=%@", message);
                            
                            status = code;
                        }
                    } else {
                        status = MappActorFinishStatusInternalError;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"User::logout:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(logoutFinished:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate logoutFinished:status];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"User::logout:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)changePassword:password desiredPassword:(NSString*)desiredPassword delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mId forKey:@"userId"];
        [busiParams setObject:password forKey:@"password"];
        [busiParams setObject:desiredPassword forKey:@"desiredPassword"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"ChangePassword";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary* responseEntity) {
            int status = execStatus;
            
            @try {
                
                if (0 == status) {
                    if (nil != responseEntity && nil != [responseEntity objectForKey:@"code"]) {
                        
                        int code = [[responseEntity objectForKey:@"code"] intValue];
                        if (0 == code) {
                            self.mPassword = desiredPassword;
                        } else {
                            NSDictionary* message = [responseEntity objectForKey:@"message"];
                            NSLog(@"User::changePassword:message=%@", message);
                            
                            status = code;
                        }
                    } else {
                        status = MappActorFinishStatusInternalError;
                    }
                }
                
            }
            @catch (NSException *exception) {
                NSLog(@"User::changePassword:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(changePasswordFinished:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate changePasswordFinished:status];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"User::changePassword:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)syncProperty:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mId forKey:@"userId"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"AcquireUserInfo";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"%s :: responseEntity: %@", __func__,responseEntity);
            @try {
                
                if (0 == status) {
                    if (nil != responseEntity && nil != [responseEntity objectForKey:@"code"]) {
                        int code = [[responseEntity objectForKey:@"code"] intValue];
                        if (0 == code) {
                            NSDictionary* respMsg = [responseEntity objectForKey:@"respMsg"];
                            
                            NSString* username = [respMsg objectForKey:@"userName"];
                            NSString* phoneNumber = [respMsg objectForKey:@"mobileNumber"];
                            NSString* email = [respMsg objectForKey:@"email"];
                            NSString* portrait = [respMsg objectForKey:@"photoUrl"];
                            NSLog(@"User::syncProperty:username=%@, phoneNumber=%@, email=%@, portrait=%@",
                                  username, phoneNumber, email, portrait);
                            
                            self.mName = username;
                            self.mPhoneNumber = phoneNumber;
                            self.mEmail = email;
                            self.mPortrait = portrait;
                            
                            [[Session sharedSession] save];
                        } else {
                            NSDictionary* message = [responseEntity objectForKey:@"message"];
                            NSLog(@"User::syncProperty:message=%@", message);
                            
                            status = code;
                        }
                    } else {
                        status = MappActorFinishStatusInternalError;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"User::syncProperty:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(syncPropertyFinished:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate syncPropertyFinished:status];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"User::syncProperty:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)updatePortrait:(NSData *)portrait delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSString* name = [NSString stringWithFormat:@"portrait_%@_%016lld.png", self.mId, (long long)time(NULL)];
        [self upload:name mimeType:@"image/png" data:portrait callback:^(int execStatus, NSString* uploadId) {
            int status = execStatus;
            
            @try {
                if (0 == status) {
                    status = [self updateProperty:@"pro.user.icon" value:uploadId delegate:delegate];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"User::updateProperty:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            
            if (0 != status) {
                if (nil != delegate && [delegate respondsToSelector:@selector(updatePropertyFinished:propertyUrl:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate updatePropertyFinished:status propertyUrl:nil];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"User::updateProperty:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)removePortrait:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        status = [self updateProperty:@"pro.user.icon" value:@"" delegate:delegate];
    }
    @catch (NSException *exception) {
        NSLog(@"User::removePortrait:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)updateProperty:(NSString*)property value:(NSString*)value delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mId forKey:@"userId"];
        [busiParams setObject:property forKey:@"name"];
        [busiParams setObject:value forKey:@"value"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"UpdateUserPro";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            NSString* propertyUrl = nil;
            @try {
                
                if (0 == status) {
                    if (nil != responseEntity && nil != [responseEntity objectForKey:@"code"]) {
                        
                        int code = [[responseEntity objectForKey:@"code"] intValue];
                        if (0 == code) {
                            NSDictionary* respMsg = [responseEntity objectForKey:@"respMsg"];
                            propertyUrl = [respMsg objectForKey:@"iconUrl"];
                            NSLog(@"User::updateProperty:propertyUrl=%@", propertyUrl);
                            
                            self.mPortrait = propertyUrl;
                            
                            [[Session sharedSession] save];
                        } else {
                            NSDictionary* message = [responseEntity objectForKey:@"message"];
                            NSLog(@"User::updateProperty:message=%@", message);
                            
                            status = code;
                        }
                    } else {
                        status = MappActorFinishStatusInternalError;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"User::updateProperty:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(updatePropertyFinished:propertyUrl:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate updatePropertyFinished:status propertyUrl:propertyUrl];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"User::updateProperty:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)queryCustomerInfo:(NSString *)serviceType delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:mId forKey:@"mobileNumber"];
        [busiParams setObject:serviceType forKey:@"serviceType"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QueryServiceInfo";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            NSDictionary* result = nil;
            @try {
                
                if (0 == status) {
                    if (nil != responseEntity && nil != [responseEntity objectForKey:@"code"]) {
                        int code = [[responseEntity objectForKey:@"code"] intValue];
                        if (0 == code) {
                            result = [responseEntity objectForKey:@"respMsg"];
                            NSLog(@"User::queryCustomerInfo:result=%@", [result description]);
                        } else {
                            NSDictionary* message = [responseEntity objectForKey:@"message"];
                            NSLog(@"User::queryCustomerInfo:message=%@", message);
                            
                            status = code;
                        }
                    } else {
                        status = MappActorFinishStatusInternalError;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"User::queryCustomerInfo:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(customerInfo:info:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate customerInfo:status info:result];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"User::queryCustomerInfo:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)queryConfigWithDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mId forKey:@"userId"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QueryConfig";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"%s ::responseEntity: %@", __func__, responseEntity);
            
            NSDictionary *respMsg = nil;
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        respMsg = [responseEntity objectForKey:@"respMsg"];
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"%s ::message=%@", __func__ ,message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s :exception=%@",__func__, [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(queryConfigFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate queryConfigFinished:status andInfo:respMsg];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s:exception=%@", __func__, [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)uploadLog:(NSArray *)logArr andWithDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:logArr forKey:@"data"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"UploadLog";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"%s ::responseEntity: %@", __func__, responseEntity);
            
            NSDictionary *respMsg = nil;
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        respMsg = [responseEntity objectForKey:@"respMsg"];
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"%s ::message=%@", __func__ ,message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s :exception=%@",__func__, [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(uploadFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate uploadFinished:status andInfo:respMsg];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s:exception=%@", __func__, [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

@end
