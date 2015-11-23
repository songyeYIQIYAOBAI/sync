//
//  ProductTest.m
//  RTSS
//
//  Created by Lyu Ming on 11/17/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MappClient.h"
#import "Product.h"
#import "ProductResource.h"
#import "RTSSAppDefine.h"
#import "AppDelegate.h"

extern BOOL ppUrlGenerateWithoutMapp; // __PP_URL_GENERATE_WITHOUT_MAPP__

@interface ProductTest : XCTestCase

@end

@implementation ProductTest

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

- (void)testSave {
    // This is an example of a functional test case.
    Product* product = [[Product alloc] init];
    product.mId = @"1000";
    product.mOfferId = @"1000";
    product.mType = 1;
    product.mName = @"product name";
    
    NSMutableArray* resources = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<3; i++) {
        ProductResource* resource = [[ProductResource alloc] init];
        resource.mName = @"resource name";
        resource.mProductId = [NSString stringWithFormat:@"%d", 1000 + i];
        resource.mResourceId = [NSString stringWithFormat:@"%d", 2000 + i];
        resource.mTotal = 100;
        resource.mRemain = 75;
        resource.mUsed = 25;
        resource.mUnit = 1;
        
        [resources addObject:resource];
        [resource release];
    }
    product.mResources = resources;
    
    [product save];
    [product release];
}

- (void)testLoad {
    Product* product = [[Product alloc] init];
    [product load];
    [product release];
}

- (void)testTransfer {
    Product *product = [[Product alloc] init];
    NSString *serviceId = @"15871793832";
    NSString *resourceId = @"3000";
    long long amount = 1*200*1024*1024;
    [product transfer:serviceId resource:resourceId amount:amount delegate:nil];
    
}

- (void)testTransform {
    Product *product = [[Product alloc] init];
    NSString *fromResourceId = @"3000";
    NSString *toResourceId = @"3000";
    long long amount = 1*200*1024*1024;
    [product transform:fromResourceId to:toResourceId amount:amount delegate:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testRecharge {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" password:@"pwd" rememberMe:NO delegate:nil];
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [user release];
    
    
    Customer *customer = [[Customer alloc] init];
    customer.mId = @"customer_id";
    
    Product *product = [[Product alloc] init];
    product.mId = @"product_id";
    ppUrlGenerateWithoutMapp = NO;
    [product recharge:customer serviceId:@"service_id" amount:5600 payType:0 delegate:nil];
    [customer release];
    [product release];
}

- (void)testQueryNegotiationFormula {
    User *user = [[User alloc] init];
    user.mId = @"userId";
    [user login:@"customerId" password:@"pwd" rememberMe:NO delegate:nil];
    while (NO == user.runLoopEnd) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [user release];

    Product *product = [[Product alloc] init];
    product.mId = @"product_id";
    [product queryNegotiationFormulaWithDelegate:nil];
    [product release];
}

@end
