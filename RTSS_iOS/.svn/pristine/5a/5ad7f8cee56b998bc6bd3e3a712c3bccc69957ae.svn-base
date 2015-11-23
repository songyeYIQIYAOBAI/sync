//
//  SubscriberTest.m
//  RTSS
//
//  Created by Lyu Ming on 11/7/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MappClient.h"
#import "Subscriber.h"
#import "Session.h"
#import "RTSSAppDefine.h"
#import "AppsInfo.h"

@interface SubscriberTest : XCTestCase

@end

@implementation SubscriberTest

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
    
    for (int i=0; i<40; i++) {
        sleep(1);
    }
    
    [MappClient destroyMappClient];
    
    [super tearDown];
}

- (void)testSync {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"account" password:@"pwd" rememberMe:YES delegate:nil];    
    
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    Customer* customer = [[Customer alloc] init];
    customer.mId = @"customerId";
//    customer.mAccountId = @"accountId";
    [customer sync:nil];
    
    
    while (NO == customer.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    Subscriber *subscriber = [[Subscriber alloc] init];
    subscriber.mId = @"subscriberId";
    
    subscriber.mDefaultAccount = [[Account alloc] init];
    subscriber.mDefaultAccount.mId = @"default_account_id";
    subscriber.mDefaultAccount.mPaidType = 1;
    
    [subscriber sync:nil];
    
    while (NO == subscriber.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    //    NSArray *list = [customer getTransferable];
    //
    [user release];
    [customer release];
    [subscriber release];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testQueryMyServiceRequestWithState {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" password:@"pwd" rememberMe:NO delegate:nil];
    
    
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    Subscriber *subscriber = [[Subscriber alloc] init];
    subscriber.mId = @"subscriberId";
    [subscriber queryMyServiceRequestWithState:0 andBeginDate:@"201412" andEndDate:@"201505" andDelegate:nil];
    [user release];
    [subscriber release];
}

- (void)testQuerySpeededUpApps {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" password:@"pwd" rememberMe:NO delegate:nil];
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [user release];
    
    Subscriber *subscriber = [[Subscriber alloc] init];
    subscriber.mId = @"subscriber_id";
    [subscriber querySpeededUpAppsWithDelegate:nil];
    [subscriber release];
}

- (void)testQuerySpeededUpProduct {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" password:@"pwd" rememberMe:NO delegate:nil];
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [user release];
    
    Subscriber *subscriber = [[Subscriber alloc] init];
    subscriber.mId = @"subscriber_id";
    [subscriber querySpeededUpProductWithAppId:@"appId1" andDelegate:nil];
    [subscriber release];
}

- (void)testQueryAppsPriority {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" password:@"pwd" rememberMe:NO delegate:nil];
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [user release];
    
    Subscriber *subscriber = [[Subscriber alloc] init];
    subscriber.mId = @"subscriber_id";
    [subscriber queryAppsPriorityWithDelegate:nil];
    [subscriber release];
}

- (void)testSetAppsPriority {
    
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" password:@"pwd" rememberMe:NO delegate:nil];
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [user release];
    
    
    AppsInfo *appInfo = [[AppsInfo alloc] init];
    appInfo.mAppId = @"appId";
    appInfo.mName = @"name";
    appInfo.mIconUrl = @"iconUrl";
    appInfo.mSpeededUp = 1;
    appInfo.mPriority = 0;
    NSArray *appsList = [NSArray arrayWithObject:appInfo];
    [appInfo release];
    
    Subscriber *subscriber = [[Subscriber alloc] init];
    subscriber.mId = @"subscriber_id";
    [subscriber setAppsPriorityWithAppsList:appsList andDelegate:nil];
    [subscriber release];
    
    
}

@end
