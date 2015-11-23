//
//  RuleManager.h
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MappActor.h"
#import "TTRule.h"
#import "TransferableItem.h"

@interface RuleManager : MappActor

+ (RuleManager*)sharedRuleManager;
+ (void)destroyRuleManager;

- (int)updateTTRulesWithDelegate:(id<MappActorDelegate>)delegate;

- (BOOL)canTransform:(NSString *)fromResourceId to:(NSString *)toResourceId;
- (TTRule*)transformRule:(NSString *)fromResourceId to:(NSString *)toResourceId;

- (BOOL)canTransfer:(NSString *)resourceId;
- (TTRule*)transferRule:(NSString *)resourceId;

- (NSDictionary*)getTTRules;

@end
