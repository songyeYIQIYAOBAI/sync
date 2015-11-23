//
//  MManagerTest.m
//  RTSS
//
//  Created by 刘艳峰 on 5/12/15.
//  Copyright (c) 2015 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MManager.h"
#import "RTSSAppDefine.h"

@interface MManagerTest : XCTestCase

@end

@implementation MManagerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSharedMManger {
//    https://124.207.3.44:443/MappBase2.5/servlet/Service
    MManager *mManager = [MManager sharedMManager];
    NSDictionary *config = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"124.207.3.44",__MAPP_SERVICE_IPADDRESS__,
                            [NSNumber numberWithInt:443],__MAPP_SERVICE_PORT__,
                            @"/MappBase2.5/servlet/Service",__MAPP_SERVICE_BASEURL__,
                            @"__push_service_ipaddress",__PUSH_SERVICE_IPADDRESS__,
                            [NSNumber numberWithInt:80],__PUSH_SERVICE_PORT__,
                            @"__mdk_auth_appid",__MDK_AUTH_APPID__,
                            nil];
    [mManager init:config];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
