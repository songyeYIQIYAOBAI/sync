//
//  TransferTransactionTest.m
//  RTSS
//
//  Created by Lyu Ming on 11/15/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MappClient.h"
#import "TransferTransaction.h"
#import "User.h"

@interface TransferTransactionTest : XCTestCase

@end

@implementation TransferTransactionTest

- (void)setUp {
    [super setUp];
    
    __block BOOL waiting = YES;
    
//    [[MappClient sharedMappClient] prepare:__MAPP_SERVER_ADDRESS__ callback:^(int status) {
//        NSLog(@"status=%d", status);
//        waiting = NO;
//    }];
    
    do {
        sleep(1);
    } while (YES == waiting);
}

- (void)tearDown {
    for (int i=0; i<60; i++) {
        sleep(1);
    }
    
    [[TransferTransaction sharedTransferTransaction] close];
    
    [MappClient destroyMappClient];
    
    [super tearDown];
}

- (void)testCreate {
    User* user = [[User alloc] init];
    user.mId = @"userId";
    //User中的mUserName、mPhoneNumber、mEmail调整到Customer中
//    user.mUserName = @"name";
    user.mPortrait = @"portrait";
    
    [[TransferTransaction sharedTransferTransaction] create:user longitude:116.123456 latitude:40.123456];
    [user release];
}

- (void)testJoin {
    User* user = [[User alloc] init];
    user.mId = @"userId";
    //User中的mUserName、mPhoneNumber、mEmail调整到Customer中
//    user.mUserName = @"name";
    user.mPortrait = @"portrait";
    
    [[TransferTransaction sharedTransferTransaction] join:user longitude:116.123456 latitude:40.123456 serviceType:@"serviceType" serviceId:@"serviceId"];
    [user release];
}

- (void)testUpdateStatus {
    User* user = [[User alloc] init];
    user.mId = @"userId";
    //User中的mUserName、mPhoneNumber、mEmail调整到Customer中
//    user.mUserName = @"name";
    user.mPortrait = @"portrait";
    
    [[TransferTransaction sharedTransferTransaction] create:user longitude:116.123456 latitude:40.123456];
    
    sleep(1);
    
    [[TransferTransaction sharedTransferTransaction] update:user transactionStatus:1];
    
    [user release];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
