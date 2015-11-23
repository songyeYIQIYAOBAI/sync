//
//  RuleManager.m
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "RuleManager.h"
#import "MappClient.h"
#import "Session.h"
#import "Customer.h"
#import "RTSSAppDefine.h"
#import "define.h"

static RuleManager* _instance = nil;

@interface RuleManager () {
    NSDictionary* _ttRules;
}

@property (nonatomic, retain) NSDictionary *ttRules;

//人造数据
- (NSDictionary *)manMadeData;

@end

@implementation RuleManager

@synthesize ttRules = _ttRules;

+ (RuleManager*)sharedRuleManager {
    @synchronized (self) {
        if (nil == _instance) {
            _instance = [[RuleManager alloc] init];
        }
    }
    
    return _instance;
}

+ (void)destroyRuleManager {
    @synchronized (self) {
        [_instance release];
        _instance = nil;
    }
}

- (void)dealloc {
    [_ttRules release];
    
    [super dealloc];
}

- (BOOL)canTransform:(NSString *)fromResourceId to:(NSString *)toResourceId {
    BOOL support = NO;
    
    @try {
        NSDictionary* sourceRuleSet = nil;
        if (nil != (sourceRuleSet = [self.ttRules objectForKey:fromResourceId])) {
            if (nil != [sourceRuleSet objectForKey:toResourceId]) {
                support = YES;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"RuleManager::canTransform:exception=%@", [exception debugDescription]);
    }
    
    return support;
}

- (TTRule*)transformRule:(NSString *)fromResourceId to:(NSString *)toResourceId {
    if (nil == self.ttRules) {
        //get ttRules from net
    }
    
    TTRule *currentRule = [[TTRule alloc] init];
    
    TransferableItem *fromItem = nil;
    TransferableItem *toItem = nil;
    for (TransferableItem *item in [Session sharedSession].mTransferables) {
        if ([item.mItemId isEqualToString:fromResourceId]) {
            fromItem = item;
        }
        if ([item.mItemId isEqualToString:toResourceId]) {
            toItem = item;
        }
    }
    
    //from
    ProductResource *fromResource = (ProductResource *)fromItem.mOriginalItem;
    currentRule.mOrgItemType = fromResource.mTypeCode;
    currentRule.mOrgItem = fromItem.mItemId;
    currentRule.mTargetAmount = fromResource.mUnitPrice;
    currentRule.mOrgMeasureId = fromResource.mUnit;
    
    //to
    ProductResource *toResource = (ProductResource *)toItem.mOriginalItem;
    currentRule.mTargetItemType = toResource.mTypeCode;
    currentRule.mTargetItem = toItem.mItemId;
    currentRule.mOrgAmount = toResource.mUnitPrice;
    currentRule.mTargetMeasureId = toResource.mUnit;
    
    //others
    currentRule.mMinOrgAmount = 0;
    currentRule.mMaxOrgAmount = fromResource.mTotal;
    
    return [currentRule autorelease];
}

- (BOOL)canTransfer:(NSString *)resourceId {
    return YES;
}

- (TTRule*)transferRule:(NSString *)resourceId {
    if (nil == self.ttRules) {
        //get ttRules from net
    }
    
    TTRule* rule = nil;
    
    @try {
        NSDictionary* sourceRuleSet = [self.ttRules objectForKey:resourceId];
        rule = [sourceRuleSet objectForKey:resourceId];
    }
    @catch (NSException *exception) {
        NSLog(@"RuleManager::transferRule:exception=%@", [exception debugDescription]);
    }
    
    return rule;
}

//人造数据
- (NSDictionary *)manMadeData {
    NSMutableDictionary *respMap = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:0];
    
    //转移规则1->1
    NSMutableDictionary *transferRule1 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [transferRule1 setObject:@"1" forKey:@"ruleId"];
    [transferRule1 setObject:@"转移规则1->1" forKey:@"name"];
    [transferRule1 setObject:[NSNumber numberWithLongLong:100] forKey:@"chargeAmount"];
    [transferRule1 setObject:[NSNumber numberWithLongLong:2] forKey:@"chargeMeasureId"];
    [transferRule1 setObject:[NSNumber numberWithInt:1] forKey:@"orgItemType"];
    [transferRule1 setObject:@"3000" forKey:@"orgItem"];
    [transferRule1 setObject:[NSNumber numberWithLongLong:1*10*1024*1024] forKey:@"orgAmount"];
    [transferRule1 setObject:[NSNumber numberWithInt:1] forKey:@"orgMeasureId"];
    [transferRule1 setObject:[NSNumber numberWithLongLong:1*100*1024*1024] forKey:@"minOrgAmount"];
    [transferRule1 setObject:[NSNumber numberWithLongLong:1*500*1024*1024] forKey:@"maxOrgAmount"];
    [transferRule1 setObject:[NSNumber numberWithInt:1] forKey:@"targetItemType"];
    [transferRule1 setObject:@"3000" forKey:@"targetItem"];
    [transferRule1 setObject:[NSNumber numberWithLongLong:1*10*1024*1024] forKey:@"targetAmount"];
    [transferRule1 setObject:[NSNumber numberWithInt:1] forKey:@"targetMeasureId"];
    [transferRule1 setObject:[NSNumber numberWithInt:1] forKey:@"validityType"];
    [transferRule1 setObject:[NSNumber numberWithInt:1] forKey:@"durationType"];
    [transferRule1 setObject:[NSNumber numberWithInt:1] forKey:@"duration"];
    [list addObject:transferRule1];
    [transferRule1 release];
    
    //转移规则2->2
    NSMutableDictionary *transferRule2 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [transferRule2 setObject:@"2" forKey:@"ruleId"];
    [transferRule2 setObject:@"转移规则2->2" forKey:@"name"];
    [transferRule2 setObject:[NSNumber numberWithLongLong:100] forKey:@"chargeAmount"];
    [transferRule2 setObject:[NSNumber numberWithLongLong:2] forKey:@"chargeMeasureId"];
    [transferRule2 setObject:[NSNumber numberWithInt:1] forKey:@"orgItemType"];
    [transferRule2 setObject:@"3001" forKey:@"orgItem"];
    [transferRule2 setObject:[NSNumber numberWithLongLong:1*10*1024*1024] forKey:@"orgAmount"];
    [transferRule2 setObject:[NSNumber numberWithInt:1] forKey:@"orgMeasureId"];
    [transferRule2 setObject:[NSNumber numberWithLongLong:1*200*1024*1024] forKey:@"minOrgAmount"];
    [transferRule2 setObject:[NSNumber numberWithLongLong:1*800*1024*1024] forKey:@"maxOrgAmount"];
    [transferRule2 setObject:[NSNumber numberWithInt:1] forKey:@"targetItemType"];
    [transferRule2 setObject:@"3001" forKey:@"targetItem"];
    [transferRule2 setObject:[NSNumber numberWithLongLong:1*10*1024*1024] forKey:@"targetAmount"];
    [transferRule2 setObject:[NSNumber numberWithInt:1] forKey:@"targetMeasureId"];
    [transferRule2 setObject:[NSNumber numberWithInt:1] forKey:@"validityType"];
    [transferRule2 setObject:[NSNumber numberWithInt:1] forKey:@"durationType"];
    [transferRule2 setObject:[NSNumber numberWithInt:1] forKey:@"duration"];
    [list addObject:transferRule2];
    [transferRule2 release];
    
    //转移规则3->3
    NSMutableDictionary *transferRule3 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [transferRule3 setObject:@"3" forKey:@"ruleId"];
    [transferRule3 setObject:@"转移规则3->3" forKey:@"name"];
    [transferRule3 setObject:[NSNumber numberWithLongLong:100] forKey:@"chargeAmount"];
    [transferRule3 setObject:[NSNumber numberWithLongLong:3] forKey:@"chargeMeasureId"];
    [transferRule3 setObject:[NSNumber numberWithInt:3] forKey:@"orgItemType"];
    [transferRule3 setObject:@"3002" forKey:@"orgItem"];
    [transferRule3 setObject:[NSNumber numberWithLongLong:10*60] forKey:@"orgAmount"];
    [transferRule3 setObject:[NSNumber numberWithInt:3] forKey:@"orgMeasureId"];
    [transferRule3 setObject:[NSNumber numberWithLongLong:50*60] forKey:@"minOrgAmount"];
    [transferRule3 setObject:[NSNumber numberWithLongLong:150*60] forKey:@"maxOrgAmount"];
    [transferRule3 setObject:[NSNumber numberWithInt:3] forKey:@"targetItemType"];
    [transferRule3 setObject:@"3002" forKey:@"targetItem"];
    [transferRule3 setObject:[NSNumber numberWithLongLong:10*60] forKey:@"targetAmount"];
    [transferRule3 setObject:[NSNumber numberWithInt:3] forKey:@"targetMeasureId"];
    [transferRule3 setObject:[NSNumber numberWithInt:1] forKey:@"validityType"];
    [transferRule3 setObject:[NSNumber numberWithInt:1] forKey:@"durationType"];
    [transferRule3 setObject:[NSNumber numberWithInt:1] forKey:@"duration"];
    [list addObject:transferRule3];
    [transferRule3 release];
    
    //转移规则4->4
    NSMutableDictionary *transferRule4 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [transferRule4 setObject:@"4" forKey:@"ruleId"];
    [transferRule4 setObject:@"转移规则4->4" forKey:@"name"];
    [transferRule4 setObject:[NSNumber numberWithLongLong:50] forKey:@"chargeAmount"];
    [transferRule4 setObject:[NSNumber numberWithLongLong:4] forKey:@"chargeMeasureId"];
    [transferRule4 setObject:[NSNumber numberWithInt:4] forKey:@"orgItemType"];
    [transferRule4 setObject:@"3003" forKey:@"orgItem"];
    [transferRule4 setObject:[NSNumber numberWithLongLong:10] forKey:@"orgAmount"];
    [transferRule4 setObject:[NSNumber numberWithInt:4] forKey:@"orgMeasureId"];
    [transferRule4 setObject:[NSNumber numberWithLongLong:100] forKey:@"minOrgAmount"];
    [transferRule4 setObject:[NSNumber numberWithLongLong:300] forKey:@"maxOrgAmount"];
    [transferRule4 setObject:[NSNumber numberWithInt:4] forKey:@"targetItemType"];
    [transferRule4 setObject:@"3003" forKey:@"targetItem"];
    [transferRule4 setObject:[NSNumber numberWithLongLong:10] forKey:@"targetAmount"];
    [transferRule4 setObject:[NSNumber numberWithInt:4] forKey:@"targetMeasureId"];
    [transferRule4 setObject:[NSNumber numberWithInt:1] forKey:@"validityType"];
    [transferRule4 setObject:[NSNumber numberWithInt:1] forKey:@"durationType"];
    [transferRule4 setObject:[NSNumber numberWithInt:1] forKey:@"duration"];
    [list addObject:transferRule4];
    [transferRule4 release];
    
    //转移规则1->3
    NSMutableDictionary *transferRule5 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [transferRule5 setObject:@"5" forKey:@"ruleId"];
    [transferRule5 setObject:@"转移规则1->3" forKey:@"name"];
    [transferRule5 setObject:[NSNumber numberWithLongLong:300] forKey:@"chargeAmount"];
    [transferRule5 setObject:[NSNumber numberWithLongLong:2] forKey:@"chargeMeasureId"];
    [transferRule5 setObject:[NSNumber numberWithInt:1] forKey:@"orgItemType"];
    [transferRule5 setObject:@"3000" forKey:@"orgItem"];
    [transferRule5 setObject:[NSNumber numberWithLongLong:1*30*1024*1024] forKey:@"orgAmount"];
    [transferRule5 setObject:[NSNumber numberWithInt:1] forKey:@"orgMeasureId"];
    [transferRule5 setObject:[NSNumber numberWithLongLong:1*100*1024*1024] forKey:@"minOrgAmount"];
    [transferRule5 setObject:[NSNumber numberWithLongLong:1*500*1024*1024] forKey:@"maxOrgAmount"];
    [transferRule5 setObject:[NSNumber numberWithInt:3] forKey:@"targetItemType"];
    [transferRule5 setObject:@"3002" forKey:@"targetItem"];
    [transferRule5 setObject:[NSNumber numberWithLongLong:5*60] forKey:@"targetAmount"];
    [transferRule5 setObject:[NSNumber numberWithInt:3] forKey:@"targetMeasureId"];
    [transferRule5 setObject:[NSNumber numberWithInt:1] forKey:@"validityType"];
    [transferRule5 setObject:[NSNumber numberWithInt:1] forKey:@"durationType"];
    [transferRule5 setObject:[NSNumber numberWithInt:1] forKey:@"duration"];
    [list addObject:transferRule5];
    [transferRule5 release];
    
    //转移规则1->4
    NSMutableDictionary *transferRule6 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [transferRule6 setObject:@"6" forKey:@"ruleId"];
    [transferRule6 setObject:@"转移规则1->4" forKey:@"name"];
    [transferRule6 setObject:[NSNumber numberWithLongLong:300] forKey:@"chargeAmount"];
    [transferRule6 setObject:[NSNumber numberWithLongLong:2] forKey:@"chargeMeasureId"];
    [transferRule6 setObject:[NSNumber numberWithInt:1] forKey:@"orgItemType"];
    [transferRule6 setObject:@"3000" forKey:@"orgItem"];
    [transferRule6 setObject:[NSNumber numberWithLongLong:1*5*1024*1024] forKey:@"orgAmount"];
    [transferRule6 setObject:[NSNumber numberWithInt:1] forKey:@"orgMeasureId"];
    [transferRule6 setObject:[NSNumber numberWithLongLong:1*100*1024*1024] forKey:@"minOrgAmount"];
    [transferRule6 setObject:[NSNumber numberWithLongLong:1*500*1024*1024] forKey:@"maxOrgAmount"];
    [transferRule6 setObject:[NSNumber numberWithInt:4] forKey:@"targetItemType"];
    [transferRule6 setObject:@"3003" forKey:@"targetItem"];
    [transferRule6 setObject:[NSNumber numberWithLongLong:5] forKey:@"targetAmount"];
    [transferRule6 setObject:[NSNumber numberWithInt:4] forKey:@"targetMeasureId"];
    [transferRule6 setObject:[NSNumber numberWithInt:1] forKey:@"validityType"];
    [transferRule6 setObject:[NSNumber numberWithInt:1] forKey:@"durationType"];
    [transferRule6 setObject:[NSNumber numberWithInt:1] forKey:@"duration"];
    [list addObject:transferRule6];
    [transferRule6 release];
    
    //转移规则2->3
    NSMutableDictionary *transferRule7 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [transferRule7 setObject:@"7" forKey:@"ruleId"];
    [transferRule7 setObject:@"转移规则2->3" forKey:@"name"];
    [transferRule7 setObject:[NSNumber numberWithLongLong:100] forKey:@"chargeAmount"];
    [transferRule7 setObject:[NSNumber numberWithLongLong:2] forKey:@"chargeMeasureId"];
    [transferRule7 setObject:[NSNumber numberWithInt:1] forKey:@"orgItemType"];
    [transferRule7 setObject:@"3001" forKey:@"orgItem"];
    [transferRule7 setObject:[NSNumber numberWithLongLong:1*30*1024*1024] forKey:@"orgAmount"];
    [transferRule7 setObject:[NSNumber numberWithInt:1] forKey:@"orgMeasureId"];
    [transferRule7 setObject:[NSNumber numberWithLongLong:1*200*1024*1024] forKey:@"minOrgAmount"];
    [transferRule7 setObject:[NSNumber numberWithLongLong:1*800*1024*1024] forKey:@"maxOrgAmount"];
    [transferRule7 setObject:[NSNumber numberWithInt:3] forKey:@"targetItemType"];
    [transferRule7 setObject:@"3002" forKey:@"targetItem"];
    [transferRule7 setObject:[NSNumber numberWithLongLong:5*60] forKey:@"targetAmount"];
    [transferRule7 setObject:[NSNumber numberWithInt:3] forKey:@"targetMeasureId"];
    [transferRule7 setObject:[NSNumber numberWithInt:1] forKey:@"validityType"];
    [transferRule7 setObject:[NSNumber numberWithInt:1] forKey:@"durationType"];
    [transferRule7 setObject:[NSNumber numberWithInt:1] forKey:@"duration"];
    [list addObject:transferRule7];
    [transferRule7 release];
    
    //转移规则2->4
    NSMutableDictionary *transferRule8 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [transferRule8 setObject:@"8" forKey:@"ruleId"];
    [transferRule8 setObject:@"转移规则2->4" forKey:@"name"];
    [transferRule8 setObject:[NSNumber numberWithLongLong:800] forKey:@"chargeAmount"];
    [transferRule8 setObject:[NSNumber numberWithLongLong:2] forKey:@"chargeMeasureId"];
    [transferRule8 setObject:[NSNumber numberWithInt:1] forKey:@"orgItemType"];
    [transferRule8 setObject:@"3001" forKey:@"orgItem"];
    [transferRule8 setObject:[NSNumber numberWithLongLong:1*5*1024*1024] forKey:@"orgAmount"];
    [transferRule8 setObject:[NSNumber numberWithInt:1] forKey:@"orgMeasureId"];
    [transferRule8 setObject:[NSNumber numberWithLongLong:1*200*1024*1024] forKey:@"minOrgAmount"];
    [transferRule8 setObject:[NSNumber numberWithLongLong:1*800*1024*1024] forKey:@"maxOrgAmount"];
    [transferRule8 setObject:[NSNumber numberWithInt:4] forKey:@"targetItemType"];
    [transferRule8 setObject:@"3003" forKey:@"targetItem"];
    [transferRule8 setObject:[NSNumber numberWithLongLong:5] forKey:@"targetAmount"];
    [transferRule8 setObject:[NSNumber numberWithInt:4] forKey:@"targetMeasureId"];
    [transferRule8 setObject:[NSNumber numberWithInt:1] forKey:@"validityType"];
    [transferRule8 setObject:[NSNumber numberWithInt:1] forKey:@"durationType"];
    [transferRule8 setObject:[NSNumber numberWithInt:1] forKey:@"duration"];
    [list addObject:transferRule8];
    [transferRule8 release];
    
    //转移规则3->1
    NSMutableDictionary *transferRule9 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [transferRule9 setObject:@"9" forKey:@"ruleId"];
    [transferRule9 setObject:@"转移规则3->1" forKey:@"name"];
    [transferRule9 setObject:[NSNumber numberWithLongLong:100] forKey:@"chargeAmount"];
    [transferRule9 setObject:[NSNumber numberWithLongLong:3] forKey:@"chargeMeasureId"];
    [transferRule9 setObject:[NSNumber numberWithInt:3] forKey:@"orgItemType"];
    [transferRule9 setObject:@"3002" forKey:@"orgItem"];
    [transferRule9 setObject:[NSNumber numberWithLongLong:10*60] forKey:@"orgAmount"];
    [transferRule9 setObject:[NSNumber numberWithInt:3] forKey:@"orgMeasureId"];
    [transferRule9 setObject:[NSNumber numberWithLongLong:50*60] forKey:@"minOrgAmount"];
    [transferRule9 setObject:[NSNumber numberWithLongLong:150*60] forKey:@"maxOrgAmount"];
    [transferRule9 setObject:[NSNumber numberWithInt:1] forKey:@"targetItemType"];
    [transferRule9 setObject:@"3000" forKey:@"targetItem"];
    [transferRule9 setObject:[NSNumber numberWithLongLong:1*50*1024*1024] forKey:@"targetAmount"];
    [transferRule9 setObject:[NSNumber numberWithInt:1] forKey:@"targetMeasureId"];
    [transferRule9 setObject:[NSNumber numberWithInt:1] forKey:@"validityType"];
    [transferRule9 setObject:[NSNumber numberWithInt:1] forKey:@"durationType"];
    [transferRule9 setObject:[NSNumber numberWithInt:1] forKey:@"duration"];
    [list addObject:transferRule9];
    [transferRule9 release];
    
    //转移规则3->2
    NSMutableDictionary *transferRule10 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [transferRule10 setObject:@"10" forKey:@"ruleId"];
    [transferRule10 setObject:@"转移规则3->2" forKey:@"name"];
    [transferRule10 setObject:[NSNumber numberWithLongLong:100] forKey:@"chargeAmount"];
    [transferRule10 setObject:[NSNumber numberWithLongLong:3] forKey:@"chargeMeasureId"];
    [transferRule10 setObject:[NSNumber numberWithInt:3] forKey:@"orgItemType"];
    [transferRule10 setObject:@"3002" forKey:@"orgItem"];
    [transferRule10 setObject:[NSNumber numberWithLongLong:10*60] forKey:@"orgAmount"];
    [transferRule10 setObject:[NSNumber numberWithInt:3] forKey:@"orgMeasureId"];
    [transferRule10 setObject:[NSNumber numberWithLongLong:50*60] forKey:@"minOrgAmount"];
    [transferRule10 setObject:[NSNumber numberWithLongLong:150*60] forKey:@"maxOrgAmount"];
    [transferRule10 setObject:[NSNumber numberWithInt:1] forKey:@"targetItemType"];
    [transferRule10 setObject:@"3001" forKey:@"targetItem"];
    [transferRule10 setObject:[NSNumber numberWithLongLong:1*50*1024*1024] forKey:@"targetAmount"];
    [transferRule10 setObject:[NSNumber numberWithInt:1] forKey:@"targetMeasureId"];
    [transferRule10 setObject:[NSNumber numberWithInt:1] forKey:@"validityType"];
    [transferRule10 setObject:[NSNumber numberWithInt:1] forKey:@"durationType"];
    [transferRule10 setObject:[NSNumber numberWithInt:1] forKey:@"duration"];
    [list addObject:transferRule10];
    [transferRule10 release];
    
    //转移规则3->4
    NSMutableDictionary *transferRule11 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [transferRule11 setObject:@"11" forKey:@"ruleId"];
    [transferRule11 setObject:@"转移规则3->4" forKey:@"name"];
    [transferRule11 setObject:[NSNumber numberWithLongLong:100] forKey:@"chargeAmount"];
    [transferRule11 setObject:[NSNumber numberWithLongLong:3] forKey:@"chargeMeasureId"];
    [transferRule11 setObject:[NSNumber numberWithInt:3] forKey:@"orgItemType"];
    [transferRule11 setObject:@"3002" forKey:@"orgItem"];
    [transferRule11 setObject:[NSNumber numberWithLongLong:10*60] forKey:@"orgAmount"];
    [transferRule11 setObject:[NSNumber numberWithInt:3] forKey:@"orgMeasureId"];
    [transferRule11 setObject:[NSNumber numberWithLongLong:50*60] forKey:@"minOrgAmount"];
    [transferRule11 setObject:[NSNumber numberWithLongLong:150*60] forKey:@"maxOrgAmount"];
    [transferRule11 setObject:[NSNumber numberWithInt:4] forKey:@"targetItemType"];
    [transferRule11 setObject:@"3003" forKey:@"targetItem"];
    [transferRule11 setObject:[NSNumber numberWithLongLong:15] forKey:@"targetAmount"];
    [transferRule11 setObject:[NSNumber numberWithInt:4] forKey:@"targetMeasureId"];
    [transferRule11 setObject:[NSNumber numberWithInt:1] forKey:@"validityType"];
    [transferRule11 setObject:[NSNumber numberWithInt:1] forKey:@"durationType"];
    [transferRule11 setObject:[NSNumber numberWithInt:1] forKey:@"duration"];
    [list addObject:transferRule11];
    [transferRule11 release];
    
    //转移规则4->1
    NSMutableDictionary *transferRule12 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [transferRule12 setObject:@"12" forKey:@"ruleId"];
    [transferRule12 setObject:@"转移规则4->1" forKey:@"name"];
    [transferRule12 setObject:[NSNumber numberWithLongLong:200] forKey:@"chargeAmount"];
    [transferRule12 setObject:[NSNumber numberWithLongLong:4] forKey:@"chargeMeasureId"];
    [transferRule12 setObject:[NSNumber numberWithInt:4] forKey:@"orgItemType"];
    [transferRule12 setObject:@"3003" forKey:@"orgItem"];
    [transferRule12 setObject:[NSNumber numberWithLongLong:10] forKey:@"orgAmount"];
    [transferRule12 setObject:[NSNumber numberWithInt:4] forKey:@"orgMeasureId"];
    [transferRule12 setObject:[NSNumber numberWithLongLong:100] forKey:@"minOrgAmount"];
    [transferRule12 setObject:[NSNumber numberWithLongLong:300] forKey:@"maxOrgAmount"];
    [transferRule12 setObject:[NSNumber numberWithInt:1] forKey:@"targetItemType"];
    [transferRule12 setObject:@"3000" forKey:@"targetItem"];
    [transferRule12 setObject:[NSNumber numberWithLongLong:1*15*1024*1024] forKey:@"targetAmount"];
    [transferRule12 setObject:[NSNumber numberWithInt:1] forKey:@"targetMeasureId"];
    [transferRule12 setObject:[NSNumber numberWithInt:1] forKey:@"validityType"];
    [transferRule12 setObject:[NSNumber numberWithInt:1] forKey:@"durationType"];
    [transferRule12 setObject:[NSNumber numberWithInt:1] forKey:@"duration"];
    [list addObject:transferRule12];
    [transferRule12 release];
    
    //转移规则4->2
    NSMutableDictionary *transferRule13 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [transferRule13 setObject:@"13" forKey:@"ruleId"];
    [transferRule13 setObject:@"转移规则4->2" forKey:@"name"];
    [transferRule13 setObject:[NSNumber numberWithLongLong:200] forKey:@"chargeAmount"];
    [transferRule13 setObject:[NSNumber numberWithLongLong:4] forKey:@"chargeMeasureId"];
    [transferRule13 setObject:[NSNumber numberWithInt:4] forKey:@"orgItemType"];
    [transferRule13 setObject:@"3003" forKey:@"orgItem"];
    [transferRule13 setObject:[NSNumber numberWithLongLong:10] forKey:@"orgAmount"];
    [transferRule13 setObject:[NSNumber numberWithInt:4] forKey:@"orgMeasureId"];
    [transferRule13 setObject:[NSNumber numberWithLongLong:100] forKey:@"minOrgAmount"];
    [transferRule13 setObject:[NSNumber numberWithLongLong:300] forKey:@"maxOrgAmount"];
    [transferRule13 setObject:[NSNumber numberWithInt:1] forKey:@"targetItemType"];
    [transferRule13 setObject:@"3001" forKey:@"targetItem"];
    [transferRule13 setObject:[NSNumber numberWithLongLong:1*15*1024*1024] forKey:@"targetAmount"];
    [transferRule13 setObject:[NSNumber numberWithInt:1] forKey:@"targetMeasureId"];
    [transferRule13 setObject:[NSNumber numberWithInt:1] forKey:@"validityType"];
    [transferRule13 setObject:[NSNumber numberWithInt:1] forKey:@"durationType"];
    [transferRule13 setObject:[NSNumber numberWithInt:1] forKey:@"duration"];
    [list addObject:transferRule13];
    [transferRule13 release];
    
    //转移规则4->3
    NSMutableDictionary *transferRule14 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [transferRule14 setObject:@"14" forKey:@"ruleId"];
    [transferRule14 setObject:@"转移规则4->3" forKey:@"name"];
    [transferRule14 setObject:[NSNumber numberWithLongLong:200] forKey:@"chargeAmount"];
    [transferRule14 setObject:[NSNumber numberWithLongLong:4] forKey:@"chargeMeasureId"];
    [transferRule14 setObject:[NSNumber numberWithInt:4] forKey:@"orgItemType"];
    [transferRule14 setObject:@"3003" forKey:@"orgItem"];
    [transferRule14 setObject:[NSNumber numberWithLongLong:10] forKey:@"orgAmount"];
    [transferRule14 setObject:[NSNumber numberWithInt:4] forKey:@"orgMeasureId"];
    [transferRule14 setObject:[NSNumber numberWithLongLong:100] forKey:@"minOrgAmount"];
    [transferRule14 setObject:[NSNumber numberWithLongLong:300] forKey:@"maxOrgAmount"];
    [transferRule14 setObject:[NSNumber numberWithInt:3] forKey:@"targetItemType"];
    [transferRule14 setObject:@"3002" forKey:@"targetItem"];
    [transferRule14 setObject:[NSNumber numberWithLongLong:10*60] forKey:@"targetAmount"];
    [transferRule14 setObject:[NSNumber numberWithInt:3] forKey:@"targetMeasureId"];
    [transferRule14 setObject:[NSNumber numberWithInt:1] forKey:@"validityType"];
    [transferRule14 setObject:[NSNumber numberWithInt:1] forKey:@"durationType"];
    [transferRule14 setObject:[NSNumber numberWithInt:1] forKey:@"duration"];
    [list addObject:transferRule14];
    [transferRule14 release];
    
    [respMap setObject:list forKey:@"ruleList"];
    [list release];
    
    NSMutableDictionary *responseEntity = [[NSMutableDictionary alloc] initWithCapacity:0];
    [responseEntity setObject:(NSDictionary *)respMap forKey:@"respMsg"];
    [respMap release];
    [responseEntity setObject:[NSNumber numberWithInt:0] forKey:@"code"];
    
    return [(NSDictionary *)responseEntity autorelease];
}

- (int)updateTTRulesWithDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    @try {
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QueryTransferRule";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        //__ENCRYPTION_ENABLED__
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        [requestEntity setObject:[NSMutableDictionary dictionaryWithCapacity:0] forKey:@"busiParams"];
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"execStatus: %d", execStatus);
            @try {
                if (nil != responseEntity) {
                    
                    status = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == status) {
                        NSMutableDictionary* ruleSets = [NSMutableDictionary dictionaryWithCapacity:0];
                        
                        NSDictionary* respMsg = [responseEntity objectForKey:@"respMsg"];
                        NSArray* rules = [respMsg objectForKey:@"ruleList"];
                        for (NSDictionary* rule in rules) {
                            NSString *ruleId = [rule objectForKey:@"ruleId"];
                            NSString* name = [rule objectForKey:@"name"];
                            long long chargeAmount = [[rule objectForKey:@"chargeAmount"] longLongValue];
                            long long chargeMeasureId = [[rule objectForKey:@"chargeMeasureId"] longLongValue];
                            int orgItemType = [[rule objectForKey:@"orgItemType"] intValue];
                            NSString *orgItem = [rule objectForKey:@"orgItem"];
                            long long orgAmount = [[rule objectForKey:@"orgAmount"] longLongValue];
                            int orgMeasureId = [[rule objectForKey:@"orgMeasureId"] intValue];
                            long long minOrgAmount = [[rule objectForKey:@"minOrgAmount"] longLongValue];
                            long long maxOrgAmount = [[rule objectForKey:@"maxOrgAmount"] longLongValue];
                            int targetItemType = [[rule objectForKey:@"targetItemType"] intValue];
                            NSString *targetItem = [rule objectForKey:@"targetItem"];
                            long long targetAmount = [[rule objectForKey:@"targetAmount"] longLongValue];
                            int targetMeasureId = [[rule objectForKey:@"targetMeasureId"] intValue];
                            int validityType = [[rule objectForKey:@"validityType"] intValue];
                            int durationType = [[rule objectForKey:@"durationType"] intValue];
                            int duration = [[rule objectForKey:@"duration"] intValue];
//                            NSLog(@"RuleManager::updateTTRules:ruleId=%@, name=%@, chargeAmount=%lld, chargeMeasureId=%lld, orgItemType=%d, orgItem=%@, orgAmount=%lld, orgMeasureId=%d, minOrgAmount=%lld, maxOrgAmount=%lld, targetItemType=%d, targetItem=%@, targetAmount=%lld, targetMeasureId=%d, validityType=%d, durationType=%d, duration=%d", ruleId, name, chargeAmount, chargeMeasureId, orgItemType, orgItem, orgAmount, orgMeasureId, minOrgAmount, maxOrgAmount, targetItemType, targetItem, targetAmount, targetMeasureId, validityType, durationType, duration);
                            
                            TTRule* ttRule = [[TTRule alloc] init];
                            ttRule.mRuleId = ruleId;
                            ttRule.mName = name;
                            ttRule.mChargeAmount = chargeAmount;
                            ttRule.mChargeMeasureId = chargeMeasureId;
                            ttRule.mOrgItemType = orgItemType;
                            ttRule.mOrgAmount = orgAmount;
                            ttRule.mOrgMeasureId = orgMeasureId;
                            ttRule.mMinOrgAmount = minOrgAmount;
                            ttRule.mMaxOrgAmount = maxOrgAmount;
                            ttRule.mTargetItemType = targetItemType;
                            ttRule.mTargetItem = targetItem;
                            ttRule.mTargetAmount = targetAmount;
                            ttRule.mTargetMeasureId = targetMeasureId;
                            ttRule.mValidityType = validityType;
                            ttRule.mDurationType = durationType;
                            ttRule.mDurationType = duration;
                            
                            NSMutableDictionary* ruleSet = [ruleSets objectForKey:orgItem];
                            if (nil == ruleSet) {
                                ruleSet = [[NSMutableDictionary alloc] initWithCapacity:0];
                                [ruleSets setObject:ruleSet forKey:orgItem];
                                [ruleSet release];
                            }
                            
                            [ruleSet setObject:ttRule forKey:targetItem];
                            [ttRule release];
                        }
                        
                        self.ttRules = ruleSets;
                    } else {
                        status = MappActorFinishStatusInternalError;
                        NSString* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"RuleManager::updateTTRules:status=%d, message=%@", status, message);
                    }
                } else {
                    status = MappActorFinishStatusNetwork;
                    NSLog(@"RuleManager::updateTTRules:failed to invoke mapp interface!");
                }
            }
            @catch (NSException *exception) {
                status = MappActorFinishStatusInternalError;
                NSLog(@"RuleManager::updateTTRules:exception=%@", [exception debugDescription]);
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(updateTTRulesFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate updateTTRulesFinished:status andInfo:self.ttRules];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        status = MappActorFinishStatusInternalError;
        NSLog(@"RuleManager::updateTTRules:exception=%@", [exception debugDescription]);
    }
    
    return status;
}

- (NSDictionary*)getTTRules {
    return self.ttRules;
}

@end
