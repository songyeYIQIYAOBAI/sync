//
//  ITransferable.h
//  librtss
//
//  Created by 刘艳峰 on 4/16/15.
//  Copyright (c) 2015 Ming Lyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappActor.h"

@protocol ITransferable <NSObject>

@required
- (NSString *)getItemId;
- (NSString *)getItemName;
- (NSString *)getSubscriberType;
- (NSString *)getSubscriberTypeName;
- (NSString *)getSubscriberId;
- (long long)getTotalAmount;
- (long long)getUsedAmount;
- (long long)getRemainAmount;
- (int)getUnit;
- (NSString *)getExtraInfo;
- (int)getTypeCode;
- (int)transferWithPeerId:(NSString *)peerId andAmount:(long long)amount andDelegate:(id<MappActorDelegate>)delegate;
- (int)transformTo:(NSString *)targetId withOrignalAmount:(long long)orignalAmount withTargetAmount:(long long)targetAmount andDelegate:(id<MappActorDelegate>)delegate;


- (int)queryChargeWithTransactionType:(int)transactionType andDelegate:(id<MappActorDelegate>)delegate;

- (NSObject *)getOriginalItem;

@end

