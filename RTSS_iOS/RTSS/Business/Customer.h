//
//  Customer.h
//  RTSS
//
//  Created by Lyu Ming on 11/24/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "User.h"
#import "MappActor.h"
#import "Account.h"
#import "Product.h"
#import "ProductResource.h"

@interface Customer : User <NSCoding>

@property (nonatomic, retain) NSString* mId;
@property (nonatomic, retain) NSArray *mMyAccounts;
@property (nonatomic, retain) NSArray* mMySubscribers;
@property (nonatomic, retain) NSArray *mDigitalProperties;

@property (nonatomic, assign) BOOL runLoopEnd;  //for test, should be deleted after use

//查询用户使用详情
- (int)queryUsageDetailWithSubscriberId:(NSString *)subscriberId andType:(int)type andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate andDelegate:(id<MappActorDelegate>)delegate;

//获取历史账单
- (int)getHisBillingStatementWithAccountId:(NSString *)accountId andType:(int)type andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate andDelegate:(id<MappActorDelegate>)delegate;

//同步Customer信息
- (int)sync:(id<MappActorDelegate>)delegate;

- (int)syncWithAccoutId:(NSString *)accountId andDelegate:(id<MappActorDelegate>)delegate;

//查询故障单分类
- (int)queryServiceRequestCategoryWithSubscriberId:(NSString *)subscriberId andCategoryId:(NSString *)categoryId andLevel:(int)level andDelegate:(id<MappActorDelegate>)delegate;

//创建故障单
- (int)createServiceRequestWithRequestInfo:(NSDictionary *)requestInfo andDelegate:(id<MappActorDelegate>)delegate;

//修改故障单
- (int)modifyServiceRequestWithRequestId:(NSString *)requestId andState:(int)state andDelegate:(id<MappActorDelegate>)delegate;

//查询客户故障单
- (int)queryMyServiceRequestWithAccountId:(NSString *)accountId andState:(int)state andBeginDate:(NSString *)beginDate andEndDate:(NSString *)endDate andDelegate:(id<MappActorDelegate>)delegate;

//查询客户故障单详情
- (int)queryServiceRequestDetailWithRequestId:(NSString *)requestId andDelegate:(id<MappActorDelegate>)delegate;

//获取用户账单
- (int)getMyBillWithAccountId:(NSString *)accountId andType:(int)type andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate andDelegate:(id<MappActorDelegate>)delegate;

//获取用户详单
- (int)getDetailedBillWithSubscriberId:(NSString *)subscriberId andBeginDate:(NSString *)beginDate andEndDate:(NSString *)endDate andDelegate:(id<MappActorDelegate>)delegate;

//查询对账单
- (int)getStatementWithAccountId:(NSString *)accountId andType:(int)type andBeginMonth:(NSString *)beginMonth andEndMonth:(NSString *)endMonth andDelegate:(id<MappActorDelegate>)delegate;

//查询可订购Product offer
- (int)rechargeableProductOffers:(NSString*)subscriberId dataBinding:(int)binding delegate:(id<MappActorDelegate>)delegate;

- (int)slaProductOffers:(NSString*)subscriberId dataBinding:(int)binding delegate:(id<MappActorDelegate>)delegate;

//查询可议价Product offer
- (int)customizedProductOffers:(NSString*)subscriberId andDelegate:(id<MappActorDelegate>)delegate;

- (int)offerDetail:(NSArray*)offerIds delegate:(id<MappActorDelegate>)delegate;

//查询产品详情
- (int)acquireProductOfferingWithProductOfferId:(NSString *)offerId andDelegate:(id<MappActorDelegate>)delegate;

- (int)queryUsage:(NSString*)serviceId beginDate:(NSString*)beginDate endDate:(NSString*)endDate delegate:(id<MappActorDelegate>)delegate;

- (int)queryOrder:(NSString*)orderNumber delegate:(id<MappActorDelegate>)delegate;

- (int)queryDefaultAccountByDefaultCustomerId;

- (NSArray *)getTransferable;

@end
