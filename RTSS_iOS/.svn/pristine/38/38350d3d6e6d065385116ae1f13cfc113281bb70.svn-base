//
//  UserTest.m
//  RTSS
//
//  Created by Lyu Ming on 11/25/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MappClient.h"
#import "User.h"
#import "Session.h"
#import "RTSSAppDefine.h"

@interface UserTest : XCTestCase

@end

@implementation UserTest

- (void)setUp {
    [super setUp];
    
    __block BOOL waiting = YES;
    
    [[MappClient sharedMappClient] prepare:__MAPP_SERVER_ADDRESS__ callback:^(int status) {
        NSLog(@"status=%d", status);
        waiting = NO;
    }];
    
    do {
        sleep(1);
    } while (YES == waiting);
}

- (void)tearDown {
    for (int i=0; i<10; i++) {
        sleep(1);
    }
    
    [MappClient destroyMappClient];
    
    [super tearDown];
}

- (void)testVerifyUserId {
    User* user = [[User alloc] init];
    [user verifyUserId:@"userId" delegate:nil];
    [user release];
}

- (void)testRequestActivationOTP {
    User* user = [[User alloc] init];
    [user requestActivationOTP:@"userId" phoneNumber:@"18612345678" delegate:nil];
    [user release];
}

- (void)testRequestLoginOTP {
    User* user = [[User alloc] init];
    [user requestLoginOTP:@"userId" delegate:nil];
    [user release];
}

- (void)testRequestResetPasswordOTP {
    User* user = [[User alloc] init];
    [user requestResetPasswordOTP:@"userId" delegate:nil];
    [user release];
}

- (void)testActivation {
    User* user = [[User alloc] init];
    [user activation:@"userId" otp:@"otp" desiredUserId:@"desiredUserId" desiredPassword:@"desiredPassword" delegate:nil];
    [user release];
}

- (void)testResetPassword {
    User* user = [[User alloc] init];
    [user resetPassword:@"userId" otp:@"otp" desiredPassword:@"desiredPassword" delegate:nil];
    [user release];
}

- (void)testLogin {
    User* user = [[User alloc] init];
    [user login:@"paul" password:@"password" rememberMe:NO delegate:nil];
    [user release];
}

- (void)testLoginWithRememberMe {
    User* user = [[User alloc] init];
    [user login:@"userId" password:@"password" rememberMe:YES delegate:nil];
    [user release];
}

- (void)testAutoLogin {
    [Session sharedSession].mToken = @"token";
    [Session sharedSession].mJToken = @"jToken001";
    
    User* user = [[User alloc] init];
    [user login:nil];
    [user release];
}

- (void)testLogout {
    User* user = [[User alloc] init];
    [user logout:nil];
    [user release];
}

- (void)testChangePassword {
    User* user = [[User alloc] init];
    user.mId = @"userId";
    user.mPassword = @"password";
    [user changePassword:@"password" desiredPassword:@"desiredPassword" delegate:nil];
    [user release];
}

- (void)testSyncProperty {
    User* user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" ssoToken:@"this_is_a_token" delegate:nil];
    
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    user.mId = @"userId";
    [user syncProperty:nil];
    [user release];
}

- (void)testUpdatePortrait {
    UIImage* portrait = [UIImage imageNamed:@"common_head_icon_d"];
    NSData* portraitData = UIImagePNGRepresentation(portrait);
    
    User* user = [[User alloc] init];
    user.mId = @"userId";
    [user updatePortrait:portraitData delegate:nil];
    [user release];
}

- (void)testCheckVersion {
    User *user = [[User alloc] init];
    [user checkVersionWithDelegate:nil];
    [user release];
}

- (void)testQueryConfig {
    User *user = [[User alloc] init];
    user.mId = @"mId";
    [user queryConfigWithDelegate:nil];
    [user release];
}

- (void)testUploadLog {
    User *user = [[User alloc] init];
    NSDictionary *log = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithInt:1],@"logType",
                         [NSNumber numberWithLongLong:20150519],@"genTime",
                         @"crash",@"crash",
                         @"deviceModel",@"deviceModel",
                         @"rtssVersion",@"rtssVersion",
                         @"osVersion",@"osVersion",
                         nil];
    NSArray *logArr = [NSArray arrayWithObject:log];
    [user uploadLog:logArr andWithDelegate:nil];
    [user release];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
