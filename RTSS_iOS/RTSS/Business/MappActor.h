//
//  MappActor.h
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateUtils.h"

typedef NS_ENUM(NSInteger, MappActorFinishStatus) {
    MappActorFinishStatusOK=0,
    MappActorFinishStatusInternalError=-1,
    MappActorFinishStatusNetwork=-2,
    MappActorFinishStatusOTPMissMatch=-3,
    MappActorFinishStatusUserIdDuplicate=-4,
    MappActorFinishStatusTransactionExist=-5,
    MappActorFinishStatusUserLocked=-6,
    MappActorFinishStatusUsageNoData=-7,
    MappActorFinishStatusAlreadyActivated=-8
};

@class Product;

@protocol MappActorDelegate <NSObject>

@optional

- (void)verifyUserIdFinished:(NSInteger)status suggestedUserIds:(NSArray*)suggestedUserIds;
- (void)requestOTPFinished:(NSInteger)status;
- (void)verifyOTPFinished:(NSInteger)status;
- (void)activationFinished:(NSInteger)status suggestedUserIds:(NSArray*)suggestedUserIds;
- (void)loginFinished:(NSInteger)status customer:(NSObject*)customer;
- (void)changePasswordFinished:(NSInteger)status;
- (void)resetPasswordFinished:(NSInteger)status;
- (void)syncFinished:(NSInteger)status;
- (void)accountSyncFinished:(NSInteger)status;
- (void)subscriberSyncFinished:(NSInteger)status;

- (void)syncPropertyFinished:(NSInteger)status;
- (void)updatePropertyFinished:(NSInteger)status propertyUrl:(NSString*)propertyUrl;
- (void)transferBalanceFinished:(NSInteger)status result:(NSDictionary*)result;
- (void)rechargeFinished:(NSInteger)status payParams:(NSString*)params;
- (void)queryOrderFinished:(NSInteger)status;
- (void)topupFinished:(NSInteger)status payParams:(NSString*)params;
- (void)productOffers:(NSInteger)status productOffers:(NSDictionary*)productOffers dataBinding:(int)binding;
- (void)offerDetail:(NSInteger)status detail:(NSDictionary*)detail;
- (void)serviceUsage:(NSInteger)status usage:(NSDictionary*)usage;
- (void)logoutFinished:(NSInteger)status;
- (void)customerInfo:(NSInteger)status info:(NSDictionary*)info;

- (void)ttActionFinished:(NSInteger)status message:(NSString*)message;
- (void)getMessages:(NSInteger)status message:(NSString *)message messageBox:(NSArray *)messages;

- (void)getMyBillFinished:(NSInteger)status andInfo:(NSArray *)info;

- (void)getDetailedBillFinished:(NSInteger)status andFileUrl:(NSString *)fileUrl;

- (void)getStatementFinished:(NSInteger)status andInfo:(NSArray *)info;

- (void)queryUsageDetailFinished:(NSInteger)status andInfo:(NSDictionary *)info;
- (void)getHisBillingStatementFinished:(NSInteger)status andInfo:(NSArray *)info;
- (void)queryMyServiceRequestFinished:(NSInteger)status andInfo:(NSArray *)info;

- (void)queryServiceRequestDetailFinished:(NSInteger)status andInfo:(NSDictionary *)info;

- (void)queryServiceRequestCategoryFinished:(NSInteger)status andInfo:(NSArray *)info;
- (void)createServiceRequestFinished:(NSInteger)status andInfo:(NSString *)info;
- (void)modifyServiceRequestFinished:(NSInteger)status andInfo:(NSString *)info;

- (void)queryChargeFinished:(NSInteger)status andInfo:(double)info;

- (void)pushBindFinished:(NSInteger)status;
- (void)queryNotificationFinished:(NSInteger)status andInfo:(NSArray *)info;

- (void)acquireProductOfferingFinished:(NSInteger)status andInfo:(NSDictionary *)info;

- (void)checkVersionFinished:(NSInteger)status andInfo:(NSDictionary *)info;

- (void)queryConfigFinished:(NSInteger)status andInfo:(NSDictionary *)info;

- (void)uploadFinished:(NSInteger)status andInfo:(NSDictionary *)info;

- (void)queryNegotiationFormulaFinished:(NSInteger)status andInfo:(NSDictionary *)info;

- (void)querySpeededUpAppsFinished:(NSInteger)status andInfo:(NSArray *)info;

- (void)querySpeededUpProductFinished:(NSInteger)status andInfo:(NSArray *)info;

- (void)queryAppsPriorityFinished:(NSInteger)status andInfo:(NSArray *)info;

- (void)setAppsPriorityFinished:(NSInteger)status;

- (void)updateTTRulesFinished:(NSInteger)status andInfo:(NSDictionary *)info;

@end


@interface MappActor : NSObject

- (void)execute:(NSString*)busiCode requestEntity:(NSDictionary*)requestEntity callback:(void(^)(int, NSDictionary*))callback;
- (void)executeWithRequestEntityList:(NSArray *)requestEntityList callback:(void (^)(int, NSDictionary *))callback;

- (void)upload:(NSString*)name mimeType:(NSString*)mimeType data:(NSData*)data callback:(void(^)(int, NSString*))callback;

- (double)doubleValueForObject:(id)obj;
- (long long)longLongValueForObject:(id)obj;
- (int)intValueForObject:(id)obj;
- (BOOL)boolValueForObject:(id)obj;

@end
