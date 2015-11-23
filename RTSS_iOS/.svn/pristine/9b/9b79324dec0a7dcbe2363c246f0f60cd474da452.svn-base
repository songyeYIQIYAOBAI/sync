//
//  TTRule.m
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "TTRule.h"

@implementation TTRule

@synthesize mRuleId;
@synthesize mName;
@synthesize mChargeAmount;
@synthesize mChargeMeasureId;
@synthesize mOrgItemType;
@synthesize mOrgItem;
@synthesize mOrgAmount;
@synthesize mOrgMeasureId;
@synthesize mMinOrgAmount;
@synthesize mMaxOrgAmount;
@synthesize mTargetItemType;
@synthesize mTargetItem;
@synthesize mTargetAmount;
@synthesize mTargetMeasureId;
@synthesize mValidityType;
@synthesize mDurationType;
@synthesize mDuration;

- (void)dealloc {
    if (nil != self.mRuleId) {
        [mRuleId release], mRuleId = nil;
    }
    
    if (nil != self.mName) {
        [mName release], mName = nil;
    }
    
    if (nil != self.mOrgItem) {
        [mOrgItem release], mOrgItem = nil;
    }
    
    if (nil != self.mTargetItem) {
        [mTargetItem release], mTargetItem = nil;
    }
    
    [super dealloc];
}

@end
