//
//  EventsTest.m
//  RTSS
//
//  Created by Lyu Ming on 12/22/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Events.h"
#import "User.h"
#import "Session.h"

@interface EventsTest : XCTestCase

@end

@implementation EventsTest

- (void)setUp {
    [super setUp];
    
    User* myUser = [[User alloc] init];
    myUser.mId = @"myId";
    [Session sharedSession].mMyUser = myUser;
    [myUser release];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAdd {
    EventItem* event = [[EventItem alloc] init];
    event.mDescription = @"balance transfer";
    event.mPeerPhoneNumber = @"peerServiceId";
    event.mTimeStamp = time(NULL);
    event.mType = EventTypeBalanceTransferIn;
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[NSNumber numberWithLongLong:100000] forKey:@"amount"];
    [parameters setObject:@"serviceType" forKey:@"serviceType"];
    [parameters setObject:@"serviceId" forKey:@"serviceId"];
    [parameters setObject:@"peerServiceId" forKey:@"targetServiceId"];
    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"status"];
    event.mParameters = parameters;
    
    [[Events sharedEvents] addEvent:event];
    [event release];
}

- (void)testQuery {
    NSDictionary* events = [[Events sharedEvents] events:[NSArray arrayWithObject:[NSNumber numberWithInt:4]] about:@"peerServiceId"];
    
    NSArray* info = [events objectForKey:@"info"];
    NSLog(@"info=%@", [info description]);
    
    NSDictionary* data = [events objectForKey:@"data"];
    NSLog(@"data=%@", [data description]);
    
    NSArray* itemsForOneDay = [data allValues];
    for (NSArray* items in itemsForOneDay) {
        for (EventItem* item in items) {
            NSLog(@"item.parameters=%@", item.mParameters);
        }
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
