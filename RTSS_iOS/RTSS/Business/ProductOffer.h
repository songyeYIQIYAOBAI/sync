//
//  ProductOffer.h
//  RTSS
//
//  Created by Lyu Ming on 11/14/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MappActor.h"
#import "Customer.h"

@interface ProductOffer : MappActor <NSCoding>

@property (nonatomic, retain) NSString* mOfferId;
@property (nonatomic, retain) NSString* mName;
@property (nonatomic, retain) NSString* mDescription;
@property (nonatomic, assign) BOOL mAutoRenew;
@property (nonatomic, assign) BOOL mNegotiable;
@property (nonatomic, assign) int mType;
@property (nonatomic, assign) int mBillingType;
@property (nonatomic, assign) int mSubType;
@property (nonatomic, assign) int mPriceType;
@property (nonatomic, assign) long long mPrice;
@property (nonatomic, assign) BOOL mTaxable;
@property (nonatomic, retain) NSArray* mResources;

@property (nonatomic, retain) NSDictionary *mDetail;
@property (nonatomic, retain) NSString *mOfferingTypeName;


- (void)createFromJsonObject:(NSObject*)jsonObject;

//订购
- (int)recharge:(Customer*)customer serviceId:(NSString*)serviceId amount:(long long)amount payType:(int)payType delegate:(id<MappActorDelegate>)delegate;

//pp多账户订购使用
+ (int)rechargeWithoutMapp:(Customer *)customer
                 offerList: (NSArray *)offerList
                  delegate:(id<MappActorDelegate>)delegate;

@end
