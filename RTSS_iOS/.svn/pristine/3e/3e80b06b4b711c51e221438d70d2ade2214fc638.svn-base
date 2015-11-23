//
//  ProductOfferTest.m
//  RTSS
//
//  Created by Lyu Ming on 12/5/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MappActor.h"
#import "MappClient.h"
#import "ProductOffer.h"
#import "Customer.h"
#import "MManager.h"

@interface ProductOfferTest : XCTestCase

@end

@implementation ProductOfferTest

- (void)setUp {
    [super setUp];
    
    __block BOOL waiting = YES;
    
//    [[MappClient sharedMappClient] prepare:__MAPP_SERVER_ADDRESS__ callback:^(int status) {
//        NSLog(@"status=%d", status);
//        waiting = NO;
//    }];
//    
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

- (void)testRecharge {
    Customer* customer = [[Customer alloc] init];
  //  customer.mCustomerId = @"customerId";
    Session *session = [MManager sharedMManager].getSession;
    session.mCurrentAccount.mId = @"accountId";
    
    ProductOffer* productOffer = [[ProductOffer alloc] init];
    productOffer.mOfferId = @"offerId";
    [productOffer recharge:customer serviceId:@"serviceId" amount:10000 payType:0 delegate:nil];
    [productOffer release];
    
    [customer release];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
