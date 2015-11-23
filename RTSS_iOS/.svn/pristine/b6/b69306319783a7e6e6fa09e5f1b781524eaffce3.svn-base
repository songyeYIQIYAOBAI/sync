//
//  TransferableItem.m
//  librtss
//
//  Created by 刘艳峰 on 4/16/15.
//  Copyright (c) 2015 Ming Lyu. All rights reserved.
//

#import "TransferableItem.h"
#import "Subscriber.h"
#import "Account.h"

@interface TransferableItem ()

@end

@implementation TransferableItem

@synthesize mItemId;
@synthesize mItemName;
@synthesize mSubscriberId;
@synthesize mTotalAmount;
@synthesize mUsedAmount;
@synthesize mRemainAmount;
@synthesize mUnit;

@synthesize mSubscriberType;
@synthesize mSubscriberName;
@synthesize mExtraInfo;

@synthesize mTypeCode;

@synthesize mOriginalItem;

- (void)dealloc {
    [mItemId release];
    [mItemName release];
    [mSubscriberId release];
    
    [mSubscriberName release];
    [mSubscriberType release];
    [mExtraInfo release];
    
    [mOriginalItem release];
    
    [super dealloc];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (NSString *)getItemId {
    return self.mItemId;
}

- (NSString *)getItemName {
    return self.mItemName;
}

- (NSString *)getSubscriberType {
    return self.mSubscriberType;
}

- (NSString *)getSubscriberTypeName{
    return self.mSubscriberName;
}

- (NSString *)getSubscriberId{
    return self.mSubscriberId;
}

- (long long)getTotalAmount{
    return self.mTotalAmount;
}
    
- (long long)getUsedAmount{
    return self.mUsedAmount;
}

- (long long)getRemainAmount {
    return self.mRemainAmount;
}

- (int)getUnit {
    return self.mUnit;
}

- (NSString *)getExtraInfo {
    return self.mExtraInfo;
}

- (int)getTypeCode {
    return self.mTypeCode;
}

- (NSObject *)getOriginalItem {
    return self.mOriginalItem;
}

- (int)transferWithPeerId:(NSString *)peerId andAmount:(long long)amount andDelegate:(id<MappActorDelegate>)delegate {
    if ([self.mOriginalItem isKindOfClass:[ProductResource class]]) {
        return [(ProductResource *)self.mOriginalItem  transferFrom:self.mSubscriberId andTo:peerId andAmount:amount andDelegate:delegate];
    } else {
        return [(Account *)self.mOriginalItem transferFrom:self.mSubscriberId andTo:peerId andAmount:amount andDelegate:delegate];
    }
    
}

- (int)transformTo:(NSString *)targetId withOrignalAmount:(long long)orignalAmount withTargetAmount:(long long)targetAmount andDelegate:(id<MappActorDelegate>)delegate {
    if ([self.mOriginalItem isKindOfClass:[ProductResource class]]) {
        return [(ProductResource *)self.mOriginalItem transformWithSubscriberId:self.mSubscriberId To:targetId withOrignalAmount:orignalAmount withTargetAmount:targetAmount andDelegate:delegate];
    }
    
    return -1;
}


- (int)queryChargeWithTransactionType:(int)transactionType andDelegate:(id<MappActorDelegate>)delegate {
    if ([self.mOriginalItem isKindOfClass:[ProductResource class]]) {
        return [(ProductResource *)self.mOriginalItem queryChargeWithTransactionType:transactionType andDelegate:delegate];
    } else {
        return [(Account *)self.mOriginalItem queryChargeWithTransactionType:transactionType andDelegate:delegate];
    }
    
    return -1;
}

@end
