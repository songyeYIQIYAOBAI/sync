//
//  MemberBudget.m
//  RTSS
//
//  Created by 刘艳峰 on 15/2/6.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "MemberBudget.h"

@implementation MemberBudget

@synthesize mSubscriberId;
@synthesize mBudget;
@synthesize mNotification;
@synthesize mBarred;

- (void)dealloc {
    [mSubscriberId release];
    
    [super dealloc];
}

@end
