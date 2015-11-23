//
//  Product.h
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MappActor.h"

@class Customer;

@interface Product : MappActor <NSCoding>

@property (nonatomic, retain) NSString* mId;
@property (nonatomic, retain) NSString* mServiceId;
@property (nonatomic, retain) NSString* mOfferId;
@property (nonatomic, retain) NSString* mName;
@property (nonatomic, assign) long long mPrice;
@property (nonatomic, assign) int mType;
@property (nonatomic, assign) BOOL mAutoRenew;
@property (nonatomic, retain) NSString* mStartDate;
@property (nonatomic, retain) NSString* mEndDate;
@property (nonatomic, retain) NSArray* mResources;

- (void)load;
- (void)save;

- (void)createFromJsonObject:(NSObject*)jsonObject;

//订购
- (int)recharge:(Customer*)customer serviceId:(NSString*)serviceId amount:(long long)amount payType:(int)payType delegate:(id<MappActorDelegate>)delegate;

- (int)transform:(int)fromResourceId to:(int)toResourceId amount:(long long)amount delegate:(id<MappActorDelegate>)delegate;
- (int)transfer:(NSString*)toMdn resource:(int)resourceId amount:(long long)amount delegate:(id<MappActorDelegate>)delegate;

- (int)queryNegotiationFormulaWithDelegate:(id<MappActorDelegate>)delegate;

@end
