//
//  Customer.m
//  RTSS
//
//  Created by Lyu Ming on 11/24/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "define.h"
#import "Customer.h"
#import "MappClient.h"
#import "Subscriber.h"
#import "Product.h"
#import "Account.h"
#import "ProductOffer.h"
#import "Session.h"
#import "TransferableItem.h"
#import "MManager.h"

#define __KEY_CUSTOMER_ID__ @"CUSTOMER_ID"
#define __KEY_CUSTOMER_MAIN_PRODUCT__ @"CUSTOMER_MAIN_PRODUCT"
#define __KEY_CUSTOMER_PRODUCTS__ @"CUSTOMER_PRODUCTS"

@interface Customer ()

@property (nonatomic, retain) NSDictionary *mMyAccountsDic; //为了提升效率用，否则需要遍历数组mMyAccounts

- (int)queryAccountsAndSubscribersWithDelegate:(id<MappActorDelegate>)delegate;

- (int)availableProductOffers:(NSString*)subscriberId type:(int)type dataBinding:(int)binding delegate:(id<MappActorDelegate>)delegate;
- (int)onlineAvailableProductOffers:(NSString *)subscriberId type:(int)type dataBinding:(int)binding delegate:(id<MappActorDelegate>)delegate;

@end

@implementation Customer

@synthesize mId;
@synthesize mMyAccounts;
@synthesize mMySubscribers;
@synthesize mDigitalProperties;

@synthesize mMyAccountsDic;

@synthesize runLoopEnd;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.mId = [aDecoder decodeObjectForKey:__KEY_CUSTOMER_ID__];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:mId forKey:__KEY_CUSTOMER_ID__];
}

- (void)dealloc {
    [mId release];
    [mMyAccounts release];
    [mMySubscribers release];
    [mDigitalProperties release];
    
    [mMyAccountsDic release];
        
    [super dealloc];
}

- (int)sync:(id<MappActorDelegate>)delegate {
    return [self queryAccountsAndSubscribersWithDelegate:delegate];
}

- (int)queryAccountsAndSubscribersWithDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableArray *requestEntityList = [NSMutableArray array];
        NSArray *busiCodes = [NSArray arrayWithObjects:@"QueryAccounts",@"QuerySubscribers", nil];
        
        NSString *queryAccountsTransactionId = [MappClient generateTransactionId];
        NSString *querySubscribersTransactionId = [MappClient generateTransactionId];
        for (NSString *busiCode in busiCodes) {
            NSMutableDictionary *busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
            NSMutableDictionary *requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
            if ([busiCode isEqualToString:@"QueryAccounts"]) {
                [busiParams setObject:self.mId forKey:@"customerId"];
                [requestEntity setObject:queryAccountsTransactionId forKey:@"transactionId"];
            }
            else {
                [busiParams setObject:[NSNumber numberWithInt:1] forKey:@"type"];
                [busiParams setObject:self.mId forKey:@"condition"];
                [requestEntity setObject:querySubscribersTransactionId forKey:@"transactionId"];
            }
            
            [requestEntity setObject:busiParams forKey:@"busiParams"];
            [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
            
            [requestEntity setObject:busiCode forKey:@"busiCode"];
            
            [requestEntityList addObject:requestEntity];
        }
        
            [self executeWithRequestEntityList:requestEntityList callback:^(int execStatus, NSDictionary *responseEntity) {
                NSLog(@"Customer::queryAccountsAndSubscribers:responseEntity: %@", responseEntity);
                int status = execStatus;
                @try {
                    if (0 == status) {
                        //1.QueryAccounts
                        NSDictionary *queryAccountsResponseEntity = [responseEntity objectForKey:queryAccountsTransactionId];
                        if (nil != queryAccountsResponseEntity) {
                            int code = [[queryAccountsResponseEntity objectForKey:@"code"] intValue];
                            if (0 == code) {
                                NSDictionary *respMsg = [queryAccountsResponseEntity objectForKey:@"respMsg"];
                                NSArray *accountArray = [respMsg objectForKey:@"accountArray"];
                                
                                NSMutableArray *myAccounts = [NSMutableArray array];
                                NSMutableDictionary *myAccountsDic = [NSMutableDictionary dictionary];
                                
                                for (NSDictionary *item in accountArray) {
                                    Account *account = [[Account alloc] init];
                                    account.mId = [item objectForKey:@"accountId"];
                                    account.mPaidType = [[item objectForKey:@"paidType"] intValue];
                                    
                                    [myAccounts addObject:account];
                                    [myAccountsDic setObject:account forKey:account.mId];
                                }
                                self.mMyAccounts = (NSArray *)myAccounts;
                                self.mMyAccountsDic = (NSDictionary *)myAccountsDic;
                            } else {
                                NSDictionary* message = [queryAccountsResponseEntity objectForKey:@"message"];
                                NSLog(@"Customer::queryAccountsAndSubscribers:message=%@", message);
                                
                                status = code;
                            }
                        } else {
                            status = MappActorFinishStatusInternalError;
                        }
                        
                        //2.QuerySubscribers
                        NSDictionary *querySubscribersResponseEntity = [responseEntity objectForKey:querySubscribersTransactionId];
                        NSLog(@"querySubscribersResponseEntity: %@", querySubscribersResponseEntity);
                        if (nil != querySubscribersResponseEntity) {
                            int code = [[querySubscribersResponseEntity objectForKey:@"code"] intValue];
                            if (0 == code) {
                                NSDictionary *respMsg = [querySubscribersResponseEntity objectForKey:@"respMsg"];
                                NSArray *subscriberArray = [respMsg objectForKey:@"subscriberArray"];
                                
                                NSMutableArray *mySubscribers = [NSMutableArray array];
                                
                                for (NSDictionary *item in subscriberArray) {
                                    
                                    Subscriber *subscriber = [[Subscriber alloc] init];
                                    subscriber.mId = [item objectForKey:@"subscriberId"];
                                    subscriber.mName = [item objectForKey:@"typeName"];
                                    subscriber.mServiceType = [item objectForKey:@"typeCode"];
                                    
                                    //
                                    //add account to defaultAccount.mSubAccounts
                                    NSDictionary *defaultAccountDic = [item objectForKey:@"defaultAccount"];
                                    Account *rightAccount = [self.mMyAccountsDic objectForKey:[defaultAccountDic objectForKey:@"accountId"]];
                                    
                                    subscriber.mPaidType = rightAccount.mPaidType;
                                    
                                    //关联subscriber和rightAccount
                                    subscriber.mDefaultAccount = rightAccount;
                                    rightAccount.mPaidSubscriber = subscriber;
                                    
                                    [mySubscribers addObject:subscriber];
                                    [subscriber release];
                                }
                                self.mMySubscribers = (NSArray *)mySubscribers;
                                self.runLoopEnd = YES;
                            } else {
                                NSDictionary* message = [querySubscribersResponseEntity objectForKey:@"message"];
                                NSLog(@"Customer::queryAccountsAndSubscribers:message=%@", message);
                                
                                status = code;
                            }
                        } else {
                            status = MappActorFinishStatusInternalError;
                        }
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"Customer::queryAccountsAndSubscribers = %@", [exception description]);
                    status = MappActorFinishStatusInternalError;
                }
                @finally {
                    //if we need a callback here, then code
                    if (nil != delegate && [delegate respondsToSelector:@selector(syncFinished:)]) {
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            [delegate syncFinished:status];
                        });
                    }
                }
            }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Customer::queryAccountsAndSubscribers = %@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}


- (int)rechargeableProductOffers:(NSString *)subscriberId dataBinding:(int)binding delegate:(id<MappActorDelegate>)delegate {
    int status = 0;
    
    status = [self availableProductOffers:subscriberId type:1 dataBinding:binding delegate:delegate];
    
    return status;
}

- (int)slaProductOffers:(NSString *)subscriberId dataBinding:(int)binding delegate:(id<MappActorDelegate>)delegate {
    int status = 0;
    
    status = [self availableProductOffers:subscriberId type:2 dataBinding:binding delegate:delegate];
    
    return status;
}

- (int)customizedProductOffers:(NSString*)subscriberId andDelegate:(id<MappActorDelegate>)delegate {
    int status = 0;
    
    status = [self availableProductOffers:subscriberId type:3 dataBinding:0 delegate:delegate];
    
    return status;
}

- (int)availableProductOffers:(NSString *)subscriberId type:(int)type dataBinding:(int)binding delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSArray* offers = [[Session sharedSession] getProductOffers:subscriberId forType:type];
        if (nil != offers && 0 < [offers count]) {
            NSDictionary* productOffers = [NSDictionary dictionaryWithObject:offers forKey:subscriberId];
            
            if (nil != delegate && [delegate respondsToSelector:@selector(productOffers:productOffers:dataBinding:)]) {
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [delegate productOffers:status productOffers:productOffers dataBinding:binding];
                });
            }
        } else {
            status = [self onlineAvailableProductOffers:subscriberId type:type dataBinding:binding delegate:delegate];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Customer::availableProductOffers:exception=%@", [exception description]);
    }
    
    return status;
}

- (int)onlineAvailableProductOffers:(NSString *)subscriberId type:(int)type dataBinding:(int)binding delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:subscriberId forKey:@"subscriberId"];
        [busiParams setObject:[NSNumber numberWithInt:type] forKey:@"type"];
        [busiParams setObject:[NSNumber numberWithInt:0] forKey:@"pageSize"];
        [busiParams setObject:[NSNumber numberWithInt:0] forKey:@"offSet"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QueryProductOffering";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            NSLog(@"%s:: responseEntity: %@", __func__, responseEntity);
            int status = execStatus;
            
            NSMutableDictionary* productOffers = [NSMutableDictionary dictionaryWithCapacity:0];
            @try {
                
                if (0 == status) {
                    if (nil != responseEntity) {
                        
                        int code = MappActorFinishStatusInternalError;
                        if (nil != [responseEntity objectForKey:@"code"] && 0 == (code = [[responseEntity objectForKey:@"code"] intValue])) {
                            NSDictionary* respMsg = [responseEntity objectForKey:@"respMsg"];
                            
                            NSMutableArray* offers = [NSMutableArray arrayWithCapacity:0];
                            
                            NSArray* offerList = [respMsg objectForKey:@"offeringArray"];
                            for (NSDictionary* offer in offerList) {
                                ProductOffer* productOffer = [[ProductOffer alloc] init];
                                [productOffer createFromJsonObject:offer];
                                
                                [offers addObject:productOffer];
                                [productOffer release];
                            }
                            
                            //begin bargain
                            NSMutableArray *customizedOfferNameList = [NSMutableArray arrayWithCapacity:0];
                            NSMutableArray *negotiableOfferList = [NSMutableArray arrayWithCapacity:0];
                            NSMutableDictionary *customizedDic = [NSMutableDictionary dictionaryWithCapacity:0];
                            for (ProductOffer *offer in offers) {
                                if (offer.mNegotiable == YES) {
                                    if ([customizedDic objectForKey:offer.mName] == nil) {
                                        [customizedDic setObject:[NSMutableArray arrayWithCapacity:0] forKey:offer.mName];
                                        [customizedOfferNameList addObject:offer.mName];
                                    }
                                    [[customizedDic objectForKey:offer.mName] addObject:offer];
                                    [negotiableOfferList addObject:offer];
                                }
                            }
                            
                            NSMutableDictionary *sortedCustomizedDic = [NSMutableDictionary dictionaryWithCapacity:0];
                            for (NSString *offerName in customizedOfferNameList) {
                                NSArray *offerList = [customizedDic objectForKey:offerName];
                                
                                //sort
                                NSArray *sortedOfferList = [offerList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                                    ProductOffer *offer1 = (ProductOffer *)obj1;
                                    ProductOffer *offer2 = (ProductOffer *)obj2;
                                    ProductResource *resource1 = (ProductResource *)[offer1.mResources objectAtIndex:0];
                                    ProductResource *resource2 = (ProductResource *)[offer2.mResources objectAtIndex:0];
                                    long long value1 = resource1.mTotal;
                                    long long value2 = resource2.mTotal;
                                    
                                    return value1 > value2;
                                }];

                                [sortedCustomizedDic setObject:sortedOfferList forKey:offerName];
                                
                            }
                            //end bargain
                            
                            if (type == 3) {                                        //bargain
                                [productOffers removeAllObjects];
                                [productOffers setDictionary:sortedCustomizedDic];
                                [[Session sharedSession] setProductOffers:negotiableOfferList withServiceType:subscriberId forType:type];
                            } else {
                                NSArray *sortedOfferList = [offers sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                                    ProductOffer *offer1 = (ProductOffer *)obj1;
                                    ProductOffer *offer2 = (ProductOffer *)obj2;
                                    ProductResource *resource1 = (ProductResource *)[offer1.mResources objectAtIndex:0];
                                    ProductResource *resource2 = (ProductResource *)[offer2.mResources objectAtIndex:0];
                                    long long value1 = resource1.mTotal;
                                    long long value2 = resource2.mTotal;
                                    
                                    return value1 > value2;
                                }];
                                [productOffers setObject:sortedOfferList forKey:subscriberId];
                                [[Session sharedSession] setProductOffers:sortedOfferList withServiceType:subscriberId forType:type];
                            }
        
                        } else {
                            NSDictionary* message = [responseEntity objectForKey:@"message"];
                            NSLog(@"Customer::onlineAvailableProductOffers:message=%@", message);
                            
                            status = code;
                        }
                        
                    } else {
                        status = MappActorFinishStatusNetwork;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Customer::onlineAvailableProductOffers:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(productOffers:productOffers:dataBinding:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate productOffers:status productOffers:productOffers dataBinding:binding];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Customer::onlineAvailableProductOffers:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)acquireProductOfferingWithProductOfferId:(NSString *)offerId andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:offerId forKey:@"offeringId"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"AcquireProductOffering";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"%s ::responseEntity: %@", __func__, responseEntity);
            
            NSDictionary *productOffering = nil;
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        NSDictionary *respMsg = [responseEntity objectForKey:@"respMsg"];
                        productOffering = [respMsg objectForKey:@"productOffering"];
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"%s ::message=%@", __func__ ,message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s :exception=%@",__func__, [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(acquireProductOfferingFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate acquireProductOfferingFinished:status andInfo:productOffering];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s:exception=%@", __func__, [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)offerDetail:(NSArray*)offerIds delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:offerIds forKey:@"prodIdArray"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QueryProductDetail";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            NSMutableDictionary* detail = [NSMutableDictionary dictionaryWithCapacity:0];
            @try {
                
                if (0 == status) {
                    if (nil != responseEntity) {
                        
                        int code = MappActorFinishStatusInternalError;
                        if (nil != [responseEntity objectForKey:@"code"] && 0 == (code = [[responseEntity objectForKey:@"code"] intValue])) {
                            NSDictionary* respMsg = [responseEntity objectForKey:@"respMsg"];
                            
                            NSArray* detailList = [respMsg objectForKey:@"planDetailList"];
                            for (NSDictionary* detailEntry in detailList) {
                                NSString* detailOfferId = [detailEntry objectForKey:@"planId"];
                                [detail setObject:detailEntry forKey:detailOfferId];
                            }
                            NSLog(@"Customer::offerDetail:detail=%@", [detail description]);
                            
                        } else {
                            NSDictionary* message = [responseEntity objectForKey:@"message"];
                            NSLog(@"Customer::offerDetail:message=%@", message);
                            
                            status = code;
                        }
                    } else {
                        status = MappActorFinishStatusNetwork;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Customer::offerDetail:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(offerDetail:detail:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate offerDetail:status detail:detail];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Customer::offerDetail:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)queryUsage:(NSString *)serviceId beginDate:(NSString *)beginDate endDate:(NSString *)endDate delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mId forKey:@"customerId"];
        [busiParams setObject:[Session sharedSession].mCurrentAccount.mId forKey:@"accountId"];
        
        [busiParams setObject:serviceId forKey:@"serviceId"];
        [busiParams setObject:[NSNumber numberWithInt:1] forKey:@"type"];
        [busiParams setObject:beginDate forKey:@"startDate"];
        [busiParams setObject:endDate forKey:@"endDate"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QueryUsage";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            NSDictionary* usage = nil;
            @try {
                
                if (0 == status) {
                    if (nil != responseEntity) {
                        int code = MappActorFinishStatusInternalError;
                        if (nil != [responseEntity objectForKey:@"code"] && 0 == (code = [[responseEntity objectForKey:@"code"] intValue])) {
                            NSDictionary* respMsg = [responseEntity objectForKey:@"respMsg"];
                            
                            usage = respMsg;
                            NSLog(@"Customer::queryUsage:usage=%@", [usage description]);
                        } else if (__ISTATUS_USAGE_NODATA__ == code) {
                            status = MappActorFinishStatusUsageNoData;
                        } else {
                            NSDictionary* message = [responseEntity objectForKey:@"message"];
                            NSLog(@"Customer::queryUsage:message=%@", message);
                            
                            status = code;
                        }
                        
                    } else {
                        status = MappActorFinishStatusNetwork;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Customer::queryUsage:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(serviceUsage:usage:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate serviceUsage:status usage:usage];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Customer::queryUsage:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)queryOrder:(NSString *)orderNumber delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:orderNumber forKey:@"orderNo"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QueryOrderStatus";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            @try {
                
                if (0 == status) {
                    if (nil != responseEntity) {
                        
                        int code = MappActorFinishStatusInternalError;
                        if (nil != [responseEntity objectForKey:@"code"] && 0 == (code = [[responseEntity objectForKey:@"code"] intValue])) {
                            NSDictionary* message = [responseEntity objectForKey:@"message"];
                            NSLog(@"Customer::queryOrder:message=%@", message);
                            
                            status = code;
                        }
                    } else {
                        status = MappActorFinishStatusNetwork;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Customer::queryOrder:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(queryOrderFinished:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate queryOrderFinished:status];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Customer::queryOrder:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}


- (int)queryDefaultAccountByDefaultCustomerId {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSLog(@"defaultCustomerId: %@", self.mId);
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mId forKey:@"customerId"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QueryDefaultAccount";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            NSLog(@"responseEntity: %@", responseEntity);
            int status = execStatus;
            
            @try {
                
                if (0 == status) {
                    if (nil != responseEntity) {
                        
                        int code = [[responseEntity objectForKey:@"code"] intValue];
                        if (0 != code) {
                            NSDictionary* message = [responseEntity objectForKey:@"message"];
                            NSLog(@"Customer::queryDefaultAccountByCustomerId:message=%@", message);
                            
                            status = code;
                        }
                        //                        self.mAccountId = ?;
                    } else {
                        status = MappActorFinishStatusNetwork;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Customer::queryDefaultAccountByCustomerId:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                //                if (nil != delegate && [delegate respondsToSelector:@selector(queryOrderFinished:)]) {
                //                    dispatch_async(dispatch_get_main_queue(), ^ {
                //                        [delegate queryOrderFinished:status];
                //                    });
                //                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Customer::queryDefaultAccountByCustomerId:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)queryServiceRequestCategoryWithSubscriberId:(NSString *)subscriberId andCategoryId:(NSString *)categoryId andLevel:(int)level andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:subscriberId forKey:@"subscriberId"];
        if (categoryId == nil || [categoryId isEqualToString:@""]) {
            [busiParams setObject:[NSNumber numberWithInt:0] forKey:@"categoryLevel"];  //root level
        } else {
            [busiParams setObject:categoryId forKey:@"categoryId"];
            [busiParams setObject:[NSNumber numberWithInt:level] forKey:@"categoryLevel"];
        }
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"GetProblemCategory";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"%s::%s:responseEntity: %@", __FILE__, __func__, responseEntity);
            
            NSArray *categoryArray = nil;
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        NSDictionary *respMsg = [responseEntity objectForKey:@"respMsg"];
                        categoryArray = [respMsg objectForKey:@"categoryArray"];
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"%s::%s:message=%@", __FILE__,__func__, message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s::%s:exception=%@",__FILE__, __func__, [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(queryServiceRequestCategoryFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate queryServiceRequestCategoryFinished:status andInfo:categoryArray];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s::%s:exception=%@", __FILE__,  __func__, [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)createServiceRequestWithRequestInfo:(NSDictionary *)requestInfo andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setDictionary:requestInfo];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"CreateCustomerProblem";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"%s::%s:responseEntity: %@", __FILE__, __func__, responseEntity);
            
            NSString *problemId = nil;
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        NSDictionary *respMsg = [responseEntity objectForKey:@"respMsg"];
                        problemId = [respMsg objectForKey:@"problemId"];
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"%s::%s:message=%@", __FILE__,__func__, message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s::%s:exception=%@",__FILE__, __func__, [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(createServiceRequestFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate createServiceRequestFinished:status andInfo:problemId];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s::%s:exception=%@", __FILE__,  __func__, [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)modifyServiceRequestWithRequestId:(NSString *)requestId andState:(int)state andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mId forKey:@"customerId"];
        [busiParams setObject:requestId forKey:@"problemId"];
        [busiParams setObject:[NSNumber numberWithInt:state] forKey:@"status"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"ModifyCustomerProblem";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"%s::%s:responseEntity: %@", __FILE__, __func__, responseEntity);
            
            NSString *problemId = nil;
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        NSDictionary *respMsg = [responseEntity objectForKey:@"respMsg"];
                        problemId = [respMsg objectForKey:@"problemId"];
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"%s::%s:message=%@", __FILE__,__func__, message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s::%s:exception=%@",__FILE__, __func__, [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(modifyServiceRequestFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate modifyServiceRequestFinished:state andInfo:problemId];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s::%s:exception=%@", __FILE__,  __func__, [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)queryUsageDetailWithSubscriberId:(NSString *)subscriberId andType:(int)type andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mId forKey:@"customerId"];
        [busiParams setObject:[Session sharedSession].mCurrentAccount.mId forKey:@"accountId"];
        [busiParams setObject:subscriberId forKey:@"subscriberId"];
        [busiParams setObject:[NSNumber numberWithInt:type] forKey:@"type"];
        [busiParams setObject:startDate forKey:@"startDate"];
        [busiParams setObject:endDate forKey:@"endDate"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QueryUsageDetail";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"%s ::responseEntity: %@", __func__, responseEntity);
            
            NSDictionary *respMsg = nil;
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        respMsg = [responseEntity objectForKey:@"respMsg"];
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"%s ::message=%@", __func__ ,message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s :exception=%@",__func__, [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(queryUsageDetailFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate queryUsageDetailFinished:status andInfo:respMsg];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s:exception=%@", __func__, [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)getHisBillingStatementWithAccountId:(NSString *)accountId andType:(int)type andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:accountId forKey:@"accountId"];
        [busiParams setObject:[NSNumber numberWithInt:type] forKey:@"type"];
        [busiParams setObject:startDate forKey:@"startDate"];
        [busiParams setObject:endDate forKey:@"endDate"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"GetHisBillingStatement";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"%s ::responseEntity: %@", __func__, responseEntity);
            
            NSArray *billingStatementArray = nil;
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        NSDictionary *respMsg = [responseEntity objectForKey:@"respMsg"];
                        billingStatementArray = [respMsg objectForKey:@"billingStatementArray"];
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"%s ::message=%@", __func__ ,message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s :exception=%@",__func__, [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(getHisBillingStatementFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate getHisBillingStatementFinished:status andInfo:billingStatementArray];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s:exception=%@", __func__, [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)queryMyServiceRequestWithAccountId:(NSString *)accountId andState:(int)state andBeginDate:(NSString *)beginDate andEndDate:(NSString *)endDate andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mId forKey:@"customerId"];
        [busiParams setObject:accountId forKey:@"accountId"];
        [busiParams setObject:[NSNumber numberWithInt:status] forKey:@"status"];
        [busiParams setObject:beginDate forKey:@"startDate"];
        [busiParams setObject:endDate forKey:@"endDate"];
        [busiParams setObject:[NSNumber numberWithInt:0] forKey:@"pageSize"];
        [busiParams setObject:[NSNumber numberWithInt:0] forKey:@"offSet"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QueryCustomerProblem";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"Customer::queryMyServiceRequestWithAccountId:responseEntity: %@", responseEntity);
            
            NSArray *problemArray = nil;
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        NSDictionary *respMsg = [responseEntity objectForKey:@"respMsg"];
                        problemArray = [respMsg objectForKey:@"problemArray"];
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"Customer::queryMyServiceRequestWithAccountId:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Customer::queryMyServiceRequestWithAccountId:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(queryMyServiceRequestFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate queryMyServiceRequestFinished:status andInfo:problemArray];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Customer::queryMyServiceRequestWithAccountId:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)queryServiceRequestDetailWithRequestId:(NSString *)requestId andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:requestId forKey:@"problemId"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QueryCustomerProblemDetail";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"Customer::queryServiceRequestDetailWithRequestId:responseEntity: %@", responseEntity);
            
            NSDictionary *respMsg = nil;
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        respMsg = [responseEntity objectForKey:@"respMsg"];
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"Customer::queryServiceRequestDetailWithRequestId:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Customer::queryServiceRequestDetailWithRequestId:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(queryServiceRequestDetailFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate queryServiceRequestDetailFinished:status andInfo:respMsg];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Customer::queryServiceRequestDetailWithRequestId:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)getMyBillWithAccountId:(NSString *)accountId andType:(int)type andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:accountId forKey:@"accountId"];
        [busiParams setObject:[NSNumber numberWithInt:type] forKey:@"type"];
        [busiParams setObject:startDate forKey:@"startDate"];
        [busiParams setObject:endDate forKey:@"endDate"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"GetBillingStatement";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"Customer::getMyBillWithAccount:responseEntity: %@", responseEntity);
            
            NSArray *billingStatementArray = nil;
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        NSDictionary *respMsg = [responseEntity objectForKey:@"respMsg"];
                        billingStatementArray = [respMsg objectForKey:@"billingStatementArray"];
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"Customer::getMyBillWithAccount:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Customer::getMyBillWithAccount:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(getMyBillFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate getMyBillFinished:status andInfo:billingStatementArray];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Customer::getMyBillWithAccount:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)getDetailedBillWithSubscriberId:(NSString *)subscriberId andBeginDate:(NSString *)beginDate andEndDate:(NSString *)endDate andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mId forKey:@"customerId"];
        [busiParams setObject:subscriberId forKey:@"subscriberId"];
        [busiParams setObject:beginDate forKey:@"startDate"];
        [busiParams setObject:endDate forKey:@"endDate"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"GetBillingStatementDetail";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"Customer::getDetailedBillWithSubscriberId:responseEntity: %@", responseEntity);
            
            NSString *fileUrl = nil;
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        NSDictionary *respMsg = [responseEntity objectForKey:@"respMsg"];
                        fileUrl = [respMsg objectForKey:@"fileUrl"];
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"Customer::getDetailedBillWithSubscriberId:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Customer::getDetailedBillWithSubscriberId:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(getDetailedBillFinished:andFileUrl:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate getDetailedBillFinished:status andFileUrl:fileUrl];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Customer::getDetailedBillWithSubscriberId:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)getStatementWithAccountId:(NSString *)accountId andType:(int)type andBeginMonth:(NSString *)beginMonth andEndMonth:(NSString *)endMonth andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:accountId forKey:@"accountId"];
        [busiParams setObject:[NSNumber numberWithInt:type] forKey:@"type"];
        [busiParams setObject:beginMonth forKey:@"startMonth"];
        [busiParams setObject:endMonth forKey:@"endMonth"];
        [busiParams setObject:[NSNumber numberWithInt:0] forKey:@"pageSize"];
        [busiParams setObject:[NSNumber numberWithInt:0] forKey:@"offSet"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QueryAccountStatement";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"Customer::getStatementWithAccountId:responseEntity: %@", responseEntity);
            
            NSArray *transactionArray = nil;
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        NSDictionary *respMsg = [responseEntity objectForKey:@"respMsg"];
                        transactionArray = [respMsg objectForKey:@"transactionArray"];
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"Customer::getStatementWithAccountId:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Customer::getStatementWithAccountId:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(getStatementFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate getStatementFinished:status andInfo:transactionArray];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Customer::getStatementWithAccountId:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (NSArray *)getTransferable {
    NSMutableArray *itemList = [NSMutableArray arrayWithCapacity:0];

    Account *currentAccount = [Session sharedSession].mCurrentAccount;
    
#if 1
    for (Account *subAccount in currentAccount.mSubAccounts) {
        TransferableItem* item = [[TransferableItem alloc] init];
        
        item.mItemId = subAccount.mId;
        item.mSubscriberId = subAccount.mPaidSubscriber.mId;
        item.mSubscriberName = subAccount.mPaidSubscriber.mName;
        item.mTotalAmount = subAccount.mTotalAmount;
        item.mUsedAmount = subAccount.mUsedAmount;
        item.mRemainAmount = subAccount.mRemainAmount;
        item.mUnit = UnitForMoney;
        item.mOriginalItem = subAccount;

        [itemList addObject:item];
    }
#endif
    
    for (Account *subAccount in currentAccount.mSubAccounts) {
        for (Product *currentProduct in subAccount.mPaidSubscriber.mProducts) {
            for (ProductResource *resource in currentProduct.mResources) {
                
                TransferableItem *item = [[TransferableItem alloc] init];
                item.mItemId = resource.mResourceId;
                item.mItemName = resource.mName;
                item.mSubscriberId = subAccount.mPaidSubscriber.mId;
                item.mSubscriberName = subAccount.mPaidSubscriber.mName;
                item.mTotalAmount = resource.mTotal;
                item.mUsedAmount = resource.mUsed;
                item.mRemainAmount = resource.mRemain;
                item.mUnit = resource.mUnit;
                item.mTypeCode = resource.mTypeCode;
                item.mOriginalItem = resource;
                
                [itemList addObject:item];
            }
        }
    }
    
    NSLog(@"Customer::getTransferable:itemListCount: %lu", (unsigned long)[itemList count]);
    [Session sharedSession].mTransferables = (NSArray *)itemList;
    
    return itemList;
}

@end
