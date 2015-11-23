//
//  Session.h
//  RTSS
//
//  Created by Lyu Ming on 11/24/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"
#import "Customer.h"

#import "Account.h"
#import "Subscriber.h"

@interface Session : NSObject

@property (nonatomic, retain) NSString* mToken;
@property (nonatomic, retain) NSString *mJToken;

@property (nonatomic, retain, setter=setMyUser:) User* mMyUser;
@property (nonatomic, retain) Customer* mMyCustomer;
@property (nonatomic, retain) Account* mCurrentAccount;
@property (nonatomic, retain) Subscriber* mCurrentSubscriber;
@property (nonatomic, retain) NSArray *mTransferables;

+ (Session*)sharedSession;
+ (void)destroySession;

- (void)load;
- (void)save;

- (NSArray*)getProductOffers:(NSString*)serviceType forType:(int)type;
- (void)setProductOffers:(NSArray*)productOffers withServiceType:(NSString*)serviceType forType:(int)type;

- (NSDictionary*)getProductOfferDetail:(NSString*)offerId;
- (void)setProductOfferDetail:(NSDictionary*)offerDetail withOfferId:(NSString*)offerId;

@end
