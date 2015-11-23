//
//  PlanManageHeadModel.m
//  RTSS
//
//  Created by tiger on 14-11-3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "PlanManageModel.h"

//HeadModel
@implementation PlanManageHeadModel
@synthesize headImage, name, phone, balance, tariff, money, serviceArray;

-(void)dealloc{
    [money release];
    [tariff release];
    [balance release];
    [phone release];
    [name release];
    [headImage release];
    [serviceArray release];
    [super dealloc];
}

@end


