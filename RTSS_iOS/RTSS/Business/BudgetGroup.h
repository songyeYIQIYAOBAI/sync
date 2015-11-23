//
//  BudgetGroup.h
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappActor.h"
@class Subscriber;

typedef NS_ENUM(NSInteger, BudgetGroupType) {
    BudgetGroupTypeTypeShareWallet = 1,
    BudgetGroupTypeTypeShareUsage
};

@interface BudgetGroup : MappActor

@property (nonatomic, copy) NSString *mGroupId;
@property (nonatomic, copy) NSString *mGroupName;
@property (nonatomic, assign) BudgetGroupType mType;
@property (nonatomic, copy) NSString *mIcon;
@property (nonatomic, assign) long long mGroupBudget;
@property (nonatomic, assign)   int mUnit;
@property (nonatomic, copy) NSString *mTargetAccountId;
@property (nonatomic, copy) NSString *mTargetProductId;
@property (nonatomic, copy) NSString *mTargetResourceId;
@property (nonatomic, copy) NSString *mTargetName;
@property (nonatomic, copy) NSString *mOwnerId;
@property (nonatomic, retain) NSMutableArray *mMembers;
@property (nonatomic, retain) NSMutableDictionary *mMemberBudgets;

- (void)updateIcon:(NSString*)icon;
- (void)addMember:(Subscriber *)member;
- (void)removeMember:(Subscriber *)member;
- (void)queryUsage;

- (int)updatePortrait:(NSData*)portrait delegate:(id<MappActorDelegate>)delegate;

@end
