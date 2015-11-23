//
//  ProductResource.h
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappActor.h"
#import "Session.h"

typedef NS_ENUM(NSInteger, MeasureUnit) {
    UnitForDataAmount = 1,
    UnitForMoney,
    UnitForTime,
    UnitForMessageAmount
};

@interface ProductResource : MappActor <NSCoding>

@property (nonatomic, retain) NSString* mOfferId;
@property (nonatomic, retain) NSString* mProductId;
@property (nonatomic, retain) NSString* mResourceId;
@property (nonatomic, retain) NSString* mName;
@property (nonatomic, assign) long long mTotal;
@property (nonatomic, assign) long long mUsed;
@property (nonatomic, assign) long long mRemain;
@property (nonatomic, retain) NSString* mExpiryDate;
@property (nonatomic, assign) MeasureUnit mUnit;

@property (nonatomic, assign) int mTypeCode;
@property (nonatomic, assign) double mUnitPrice;

- (void)createFromJsonObject:(NSObject*)jsonObject;

//转移资源
- (int)transferFrom:(NSString *)from andTo:(NSString *)to andAmount:(long long)amount andDelegate:(id<MappActorDelegate>)delegate;

//转换资源
- (int)transformWithSubscriberId:(NSString *)orignalId To:(NSString *)targetId withOrignalAmount:(long long)orignalAmount withTargetAmount:(long long)targetAmount andDelegate:(id<MappActorDelegate>)delegate;

//查询手续费
- (int)queryChargeWithTransactionType:(int)transactionType andDelegate:(id<MappActorDelegate>)delegate;

@end
