//
//  Account.h
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MappActor.h"
@class Subscriber;
@class Customer;

@interface Account : MappActor

@property (nonatomic, retain) NSString* mId;
@property (nonatomic, retain) Customer *mMyCustomer;
@property (nonatomic, retain) Account *mParentAccount;
@property (nonatomic, retain) NSMutableArray* mSubAccounts;
@property (nonatomic, retain) Subscriber *mPaidSubscriber;
@property (nonatomic, assign) int mPaidType;
@property (nonatomic, assign) long long mTotalAmount;
@property (nonatomic, assign) long long mRemainAmount;
@property (nonatomic, assign) long long mUsedAmount;
@property (nonatomic, assign) int mStatus;
@property (nonatomic, retain) NSString *mValidDate;
@property (nonatomic, retain) NSString* mExpiryDate;

@property (nonatomic, assign) BOOL runLoopEnd;

- (void)createFromJsonObject:(NSObject*)jsonObject;

- (int)transferBalance:(long long)amount toPeer:(NSString*)peerServiceId delegate:(id<MappActorDelegate>)delegate;

//充值：主账户充值和service充值
- (int)topup:(long long)amount delegate:(id<MappActorDelegate>)delegate;

- (int)sync:(id<MappActorDelegate>)delegate;

//转移balance
- (int)transferFrom:(NSString *)from andTo:(NSString *)to andAmount:(long long)amount andDelegate:(id<MappActorDelegate>)delegate;

//查询手续费
- (int)queryChargeWithTransactionType:(int)transactionType andDelegate:(id<MappActorDelegate>)delegate;

@end
