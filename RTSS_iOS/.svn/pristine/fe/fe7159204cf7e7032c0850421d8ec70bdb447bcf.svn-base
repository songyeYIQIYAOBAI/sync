//
//  Subscriber.h
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MappActor.h"
#import "Product.h"
#import "AppsInfo.h"
@class Account;

typedef NS_ENUM(NSInteger, SubscriberProperty) {
    PropertyPortrait
};

@interface Subscriber : MappActor

@property (nonatomic, retain) NSString* mId;
@property (nonatomic, retain) NSString* mServiceType;
@property (nonatomic, assign) int mPaidType;
@property (nonatomic, retain) NSString* mName;
@property (nonatomic, retain) NSArray* mProducts;
@property (nonatomic, retain) Account *mDefaultAccount;
@property (nonatomic, retain) Customer *mMyCustomer;

@property (nonatomic, assign) BOOL runLoopEnd;

- (void)createFromJsonObject:(NSObject*)jsonObject;

- (int)sync:(id<MappActorDelegate>)delegate;

- (int)queryMyServiceRequestWithState:(int)state andBeginDate:(NSString *)beginDate andEndDate:(NSString *)endDate andDelegate:(id<MappActorDelegate>)delegate;

- (int)querySpeededUpAppsWithDelegate:(id<MappActorDelegate>)delegate;

- (int)querySpeededUpProductWithAppId:(NSString *)appId andDelegate:(id<MappActorDelegate>)delegate;

- (int)queryAppsPriorityWithDelegate:(id<MappActorDelegate>)delegate;

- (int)setAppsPriorityWithAppsList:(NSArray *)appsList andDelegate:(id<MappActorDelegate>)delegate;

@end
