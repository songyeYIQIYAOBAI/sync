//
//  RuleManagerTest.m
//  RTSS
//
//  Created by Lyu Ming on 11/15/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MappClient.h"
#import "RuleManager.h"
#import "RTSSAppDefine.h"

@interface RuleManagerTest : XCTestCase

@end

@implementation RuleManagerTest

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

//- (void)testGetPriceRule {
//    PriceRule *priceRule = [[RuleManager sharedRuleManager] getPriceRule:@"F01"];
//    PriceRuleItem *item1 = [priceRule.mRuleItems objectForKey:@"R06"];
//    NSLog(@"item: %@", item1.description);
//}

- (void)testUpdate {
    [[RuleManager sharedRuleManager] update];
//    sleep(20);
//    [self testTranferRule];
}

- (void)testTranferRule {
    NSDictionary *ttRules = [[RuleManager sharedRuleManager] getTTRules];
    TTRule *rule = [[RuleManager sharedRuleManager] transferRule:@"r0103"];
    NSLog(@"rule: %@", rule.mRuleId);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
