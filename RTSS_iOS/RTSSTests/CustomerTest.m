//
//  CustomerTest.m
//  RTSS
//
//  Created by Lyu Ming on 11/28/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MappClient.h"
#import "Customer.h"
#import "MManager.h"
#import "RTSSAppDefine.h"

@interface CustomerTest : XCTestCase

@end

@implementation CustomerTest

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

- (void)testSyncProperty {
    Customer *customer = [[Customer alloc] init];
    for (int i = 0; i < 5; i ++) {
        [customer syncProperty:nil];
    }
    
}

- (void)testSync {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"account" password:@"pwd" rememberMe:YES delegate:nil];
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [user release];
    
    Customer* customer = [[Customer alloc] init];
    customer.mId = @"customerId";
//    customer.mAccountId = @"accountId";
    [customer sync:nil];
    [customer release];
}

- (void)testCustomizedProductOffers {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"Safi_wifi" password:@"Ril@1234" rememberMe:YES delegate:nil];
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [user release];
    
    Customer *customer = [[Customer alloc] init];
    customer.mId = @"customer_id";
    [customer customizedProductOffers:@"product_offer_id" andDelegate:nil];
    [customer release];
}

- (void)testQueryOrder {
    Customer* customer = [[Customer alloc] init];
    [customer queryOrder:@"orderNumber" delegate:nil];
    [customer release];
}

- (void)testRechargeableOffer {
    Customer* customer = [[Customer alloc] init];
    [customer rechargeableProductOffers:@"serviceType" dataBinding:0 delegate:nil];
    [customer release];
}

- (void)testSlaOffer {
    Customer* customer = [[Customer alloc] init];
    [customer slaProductOffers:@"serviceType" delegate:nil];
    [customer release];
}

- (void)testOfferDetail {
    Customer* customer = [[Customer alloc] init];
    [customer offerDetail:[NSArray arrayWithObject:@"offerId"] delegate:nil];
    [customer release];
}

- (void)testQueryUsage {
    Customer* customer = [[Customer alloc] init];
    customer.mId = @"customerId";
    Session *session = [MManager sharedMManager].getSession;
    session.mCurrentAccount.mId = @"accountId";
    [customer queryUsage:@"serviceId" beginDate:@"" endDate:@"" delegate:nil];
    [customer release];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testQueryDefaultAccountByCustomerId {
    Customer *customer = [[Customer alloc] init];
    NSLog(@"id: %@", customer.mId);
    customer.mId = @"C01";
    [customer queryDefaultAccountByDefaultCustomerId];
    [customer release];
}

- (void)testGetMyBill {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" password:@"pwd" rememberMe:NO delegate:nil];
    [user release];
    
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    Customer *customer = [[Customer alloc] init];
    [customer getMyBillWithAccountId:@"account_id" andType:1 andStartDate:@"2014-12-01 10:10:10" andEndDate:@"2015-01-01 10:10:10" andDelegate:nil];
    [customer release];
}

- (void)testGetBillDetail {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" password:@"pwd" rememberMe:NO delegate:nil];
    
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [user release];
    
    Customer *customer = [[Customer alloc] init];
    customer.mId = @"hahaha";
    [customer getDetailedBillWithSubscriberId:@"thanks" andBeginDate:@"20141230" andEndDate:@"20150101" andDelegate:nil];
    [customer release];
}

- (void)testGetStatement {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" password:@"pwd" rememberMe:NO delegate:nil];
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [user release];
    
    Customer *customer = [[Customer alloc] init];
    [customer getStatementWithAccountId:@"accountId" andType:0 andBeginMonth:@"201412" andEndMonth:@"201501" andDelegate:nil];
    [customer release];
}

- (void)testQueryUsageDetailWithSubscriberId {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" password:@"pwd" rememberMe:NO delegate:nil];
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [user release];
    
    Customer *customer = [[Customer alloc] init];
    customer.mId = @"hahaha";
    [[Session sharedSession].mCurrentAccount setMId:@"current_account_id"];
    [customer queryUsageDetailWithSubscriberId:@"subscriber_id" andType:1 andStartDate:@"2014-12-01 10:10:10" andEndDate:@"2015-01-01 10:10:10" andDelegate:nil];
    [customer release];
}

- (void)testRechargeableProductOffers {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" password:@"pwd" rememberMe:NO delegate:nil];
    
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [user release];
    
    Customer *customer = [[Customer alloc] init];
    customer.mId = @"customer_id";
    [customer rechargeableProductOffers:@"my_offer" dataBinding:100 delegate:nil];
    [customer release];
}

- (void)testAcquireProductOfferingWithProductOfferId {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" password:@"pwd" rememberMe:NO delegate:nil];
    
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [user release];
    
    Customer *customer = [[Customer alloc] init];
    customer.mId = @"customer_id";
    [customer acquireProductOfferingWithProductOfferId:@"offer_id" andDelegate:nil];
    [customer release];
}

- (void)testQueryServiceRequestDetail {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" password:@"pwd" rememberMe:NO delegate:nil];
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [user release];
    
    Customer *customer = [[Customer alloc] init];
    [customer queryServiceRequestDetailWithRequestId:@"requestId" andDelegate:nil];
    [customer release];
}

- (void)testQueryMyServiceRequest {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" password:@"pwd" rememberMe:NO delegate:nil];
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [user release];
    
    Customer *customer = [[Customer alloc] init];
    customer.mId = @"hahaha";
    [customer queryMyServiceRequestWithAccountId:@"helloa" andState:0 andBeginDate:@"201412" andEndDate:@"201501" andDelegate:nil];
    [customer release];
}

- (void)testqueryServiceRequestCategoryWithSubscriberId {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" password:@"pwd" rememberMe:NO delegate:nil];
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [user release];
    
    Customer *customer = [[Customer alloc] init];
    [customer queryServiceRequestCategoryWithSubscriberId:@"ren_fei" andCategoryId:@"category_id" andLevel:2 andDelegate:nil];
    [customer release];
}

- (void)testCreateServiceRequestWithRequestInfo {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" password:@"pwd" rememberMe:NO delegate:nil];
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [user release];
    
    Customer *customer = [[Customer alloc] init];
    NSDictionary *requestInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"customerId", @"customerId", @"accountId", @"accountId", @"subscriberId", @"subscriberId", @"categoryId", @"categoryId", @"subCategoryId", @"subCategoryId",@"subSubCategoryId", @"subSubCategoryId", @"title", @"title", @"description", @"description", nil];
    
    [customer createServiceRequestWithRequestInfo:requestInfo andDelegate:nil];
    [customer release];
}

- (void)testModifyServiceRequestWithRequestId {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" password:@"pwd" rememberMe:NO delegate:nil];
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [user release];
    
    Customer *customer = [[Customer alloc] init];
    customer.mId = @"customer_id";
    [customer modifyServiceRequestWithRequestId:@"request_id" andState:1 andDelegate:nil];
    [customer release];
}

@end
