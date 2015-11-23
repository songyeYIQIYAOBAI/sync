//
//  BudgetGroupTest.m
//  RTSS
//
//  Created by 刘艳峰 on 5/19/15.
//  Copyright (c) 2015 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BudgetGroup.h"
#import "MappClient.h"
#import "MManager.h"
#import "RTSSAppDefine.h"

@interface BudgetGroupTest : XCTestCase

@end

@implementation BudgetGroupTest

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

- (void)testUpdateProperty {
    BudgetGroup *group = [[BudgetGroup alloc] init];
    group.mGroupId = @"group_id";
//    [group updateProperty:@"property" value:@"value" delegate:nil];
    [group release];
}

@end
