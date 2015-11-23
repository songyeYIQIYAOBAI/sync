//
//  User.h
//  RTSS
//
//  Created by Lyu Ming on 11/24/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "MappActor.h"

@interface User : MappActor <NSCoding>

@property (nonatomic, retain) NSString* mId;
@property (nonatomic, retain) NSString* mName;
@property (nonatomic, retain) NSString* mPassword;
@property (nonatomic, retain) NSString* mPhoneNumber;
@property (nonatomic, retain) NSString* mEmail;
@property (nonatomic, retain) NSString* mPortrait;

@property (nonatomic, assign) int mType;

@property (nonatomic, assign) BOOL runLoopEnd;  //for test, should be deleted after use

- (int)checkVersionWithDelegate:(id<MappActorDelegate>)delegate;

- (int)queryConfigWithDelegate:(id<MappActorDelegate>)delegate;

- (int)uploadLog:(NSArray *)logArr andWithDelegate:(id<MappActorDelegate>)delegate;

- (int)verifyUserId:(NSString*)userId delegate:(id<MappActorDelegate>)delegate;

// 获取OTP
- (int)requestLoginOTP:(NSString*)userId delegate:(id<MappActorDelegate>)delegate;
- (int)requestResetPasswordOTP:(NSString *)userId delegate:(id<MappActorDelegate>)delegate;
- (int)requestActivationOTP:(NSString*)userId phoneNumber:(NSString*)phoneNumber delegate:(id<MappActorDelegate>)delegate;

- (int)activation:(NSString*)userId
              otp:(NSString*)otp
    desiredUserId:(NSString*)desiredUserId
  desiredPassword:(NSString*)desiredPassword
         delegate:(id<MappActorDelegate>)delegate;

- (int)resetPassword:(NSString*)userId otp:(NSString*)otp desiredPassword:(NSString*)desiredPassword delegate:(id<MappActorDelegate>)delegate;

// 自动登录
- (int)login:(id<MappActorDelegate>)delegate;
// 请求登录
- (int)login:(NSString*)userId password:(NSString*)password rememberMe:(BOOL)rememberMe delegate:(id<MappActorDelegate>)delegate;
// sso登录
- (int)login:(NSString*)customerId ssoToken:(NSString*)ssoToken delegate:(id<MappActorDelegate>)delegate;

- (int)logout:(id<MappActorDelegate>)delegate;
// 更改密码
- (int)changePassword:(NSString*)password desiredPassword:(NSString*)desiredPassword delegate:(id<MappActorDelegate>)delegate;

- (int)syncProperty:(id<MappActorDelegate>)delegate;

- (int)updatePortrait:(NSData*)portrait delegate:(id<MappActorDelegate>)delegate;
- (int)removePortrait:(id<MappActorDelegate>)delegate;

- (int)queryCustomerInfo:(NSString*)serviceType delegate:(id<MappActorDelegate>)delegate;

@end
