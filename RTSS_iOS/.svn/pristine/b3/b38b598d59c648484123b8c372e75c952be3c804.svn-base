//
//  AccountTest.m
//  RTSS
//
//  Created by Lyu Ming on 12/2/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MappClient.h"
#import "MappActor.h"
#import "Account.h"
#import "RTSSAppDefine.h"
#import "User.h"
#import "AppDelegate.h"

extern BOOL ppUrlGenerateWithoutMapp; // __PP_URL_GENERATE_WITHOUT_MAPP__

@interface AccountTest : XCTestCase

@end

@implementation AccountTest

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

- (void)testTopUp {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" password:@"pwd" rememberMe:NO delegate:nil];
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [user release];
    
    Account *account = [[Account alloc] init];
    account.mId = @"account_id";
    ppUrlGenerateWithoutMapp = NO;
    [account topup:5600 delegate:nil];
    [account release];
}

@end
