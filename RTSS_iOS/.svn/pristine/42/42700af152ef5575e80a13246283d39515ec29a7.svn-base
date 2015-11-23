//
//  PriceRuleItem.m
//  RTSS
//
//  Created by 刘艳峰 on 15/2/7.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "PriceRuleItem.h"

@implementation PriceRuleItem

@synthesize mResourceId;
@synthesize mMinValue;
@synthesize mMaxValue;

- (void)dealloc {
    [mResourceId release];
    
    [super dealloc];
}

- (NSString *)description {
    NSString *myDescription = [NSString stringWithFormat:@"ResourceId: %@ and MinValue: %lld and MaxValue: %lld", self.mResourceId, self.mMinValue, self.mMaxValue];
    return myDescription;
};

@end
