//
//  FriendsTest.m
//  RTSS
//
//  Created by Lyu Ming on 12/22/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Friends.h"
#import "User.h"
#import "Session.h"

@interface FriendsTest : XCTestCase

@end

@implementation FriendsTest

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
    for (int i=0; i<10; i++) {
        User* user = [[User alloc] init];
        user.mId = [NSString stringWithFormat:@"userId%d", i];
        //User中的mUserName、mPhoneNumber、mEmail调整到Customer中
//        user.mPhoneNumber = [NSString stringWithFormat:@"phoneNumber%d", i];
//        user.mUserName = [NSString stringWithFormat:@"name%d", i];
        
        [[Friends shareFriends] add:user];
    }
}

- (void)testQuery {
    NSArray* friends = [[Friends shareFriends] friends:3];
//    for (User* friend in friends) {
        //User中的mUserName、mPhoneNumber、mEmail调整到Customer中
//        NSLog(@"friend=%@,%@,%@,%@,%ld", friend.mUserId, friend.mUserName, friend.mPhoneNumber, friend.mPortrait, friend.mCreateTime);
//    }
}

- (void)testRemove {
    User* friend = [[User alloc] init];
    //User中的mUserName、mPhoneNumber、mEmail调整到Customer中
//    friend.mPhoneNumber = @"phoneNumber3";
    [[Friends shareFriends] remove:friend];
    [friend release];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
