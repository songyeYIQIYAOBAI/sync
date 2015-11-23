//
//  Subscriber.m
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "define.h"
#import "Subscriber.h"
#import "MappClient.h"
#import "RSAUtil.h"
#import "GTMBase64.h"
#import "SBJSON.h"
#import "UserDefaults.h"
#import "Product.h"
#import "ProductResource.h"
#import "ProductOffer.h"
#import "ProductResource.h"
#import "Cache.h"
#import "FileUtils.h"
#import "TransferableItem.h"
#import "RuleManager.h"

#define __KEY_SUBSCRIBER_CUSTOMERID__ @"SUBSCRIBER_CUSTOMERID"
#define __KEY_SUBSCRIBER_NAME__ @"SUBSCRIBER_NAME"
#define __KEY_SUBSCRIBER_PORTRAIT__ @"SUBSCRIBER_PORTRAIT"
#define __KEY_SUBSCRIBER_PROPERTY_UPDATETIME__ @"SUBSCRIBER_PROPERTY_UPDATETIME"

#define __KEY_SUBSCRIBER_MDN__ @"SUBSCRIBER_MDN"
#define __KEY_SUBSCRIBER_PASSWORD__ @"SUBSCRIBER_PASSWORD"

#define __KEY_SUBSCRIBER_MAINPRODUCT__ @"SUBSCRIBER_MAINPRODUCT"
#define __KEY_SUBSCRIBER_PRODUCTS__ @"SUBSCRIBER_PRODUCTS"
#define __KEY_SUBSCRIBER_NEGOTIABLE_PRODUCTOFFERS__ @"SUBSCRIBER_NEGOTIABLE_PRODUCTOFFERS"
#define __KEY_SUBSCRIBER_NONEGOTIABLE_PRODUCTOFFERS__ @"SUBSCRIBER_NONEGOTIABLE_PRODUCTOFFERS"
#define __KEY_SUBSCRIBER_PRODUCTOFFERS_UPDATETIME__ @"SUBSCRIBER_PRODUCTOFFERS_UPDATETIME"


@interface Subscriber ()<MappActorDelegate>

//获取瓶子可切换数据
- (NSArray *)getTransferable;

@end

@implementation Subscriber

@synthesize mId;
@synthesize mServiceType;
@synthesize mPaidType;
@synthesize mName;
@synthesize mProducts;
@synthesize mDefaultAccount;
@synthesize mMyCustomer;

- (void)dealloc{
    [mId release];
    [mServiceType release];
    [mName release];
    [mProducts release];
    [mDefaultAccount release];
    [mMyCustomer release];
    
    [super dealloc];
}

- (int)sync:(id<MappActorDelegate>)delegate {
    self.mMyCustomer = [Session sharedSession].mMyCustomer;
    
    int status = MappActorFinishStatusOK;
    @try{
        NSMutableArray *requestEntityList = [NSMutableArray array];
        
        //build mSubscriber requirement
        NSMutableDictionary* busiParamsForSubscriber = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParamsForSubscriber setObject:self.mId forKey:@"subscriberId"];
        
        NSString* transactionIdForSubscriber = [MappClient generateTransactionId];
        
        NSString* busiCodeForSubscriber = @"QueryProductInst";
        NSMutableDictionary* requestEntityForSubscriber = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntityForSubscriber setObject:busiParamsForSubscriber forKey:@"busiParams"];
        [requestEntityForSubscriber setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntityForSubscriber setObject:busiCodeForSubscriber forKey:@"busiCode"];
        [requestEntityForSubscriber setObject:transactionIdForSubscriber forKey:@"transactionId"];
        
        [requestEntityList addObject:requestEntityForSubscriber];
        //end of build mSubscriber requirement
        
        //build default account's params
        NSMutableDictionary* busiParamsForDefaultAccount = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParamsForDefaultAccount setObject:mDefaultAccount.mId forKey:@"condition"];
        [busiParamsForDefaultAccount setObject:[NSNumber numberWithInt:2] forKey:@"conditionType"];
        if (self.mPaidType == 1) {
            [busiParamsForDefaultAccount setObject:[NSNumber numberWithInt:1] forKey:@"type"];   //pre paid
        } else {
            [busiParamsForDefaultAccount setObject:[NSNumber numberWithInt:2] forKey:@"type"];   //suf paid
        }
        
        NSString* transactionIdForDefaultAccount = [MappClient generateTransactionId];
        
        NSString* busiCodeForDefaultAccount = @"QueryBalance";
        NSMutableDictionary* requestEntityForDefaultAccount = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntityForDefaultAccount setObject:busiParamsForDefaultAccount forKey:@"busiParams"];
        [requestEntityForDefaultAccount setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntityForDefaultAccount setObject:busiCodeForDefaultAccount forKey:@"busiCode"];
        [requestEntityForDefaultAccount setObject:transactionIdForDefaultAccount forKey:@"transactionId"];
        
        [requestEntityList addObject:requestEntityForDefaultAccount];
        
        //end of build default account's params
        
        [self executeWithRequestEntityList:requestEntityList callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"%s :responseEntity: %@", __FUNCTION__, responseEntity);
            @try {
                if (0 == status) {
                    //for account
                    NSDictionary *defaultAccountResponseEntity = [responseEntity objectForKey:transactionIdForDefaultAccount];
                    NSLog(@"Subscriber::sync:defaultAccountResponseEntity: %@", defaultAccountResponseEntity);
                    if (nil != defaultAccountResponseEntity) {
                        int code = [[defaultAccountResponseEntity objectForKey:@"code"] intValue];
                        if (0 == code) {
                            NSDictionary *respMsg = [defaultAccountResponseEntity objectForKey:@"respMsg"];
                            NSDictionary *quantity = [respMsg objectForKey:@"quantity"];
                            
                            //get defaultAccount as rightAccount
                            Account *rightAccount = [self mDefaultAccount];
                            
                            rightAccount.mTotalAmount = [self longLongValueForObject:[quantity objectForKey:@"totalAmount"]];
                            rightAccount.mRemainAmount = [self longLongValueForObject:[quantity objectForKey:@"remainAmount"]];
                            rightAccount.mUsedAmount = [self longLongValueForObject:[quantity objectForKey:@"usedAmount"]];
                            
//                            rightAccount.mTypeCode = [[quantity objectForKey:@"typeCode"] intValue];
                            //                                        rightAccount.mStatus = [[quantity objectForKey:@"status"] intValue];
                            //                                        rightAccount.mValidDate = [quantity objectForKey:@"validDate"];
                            
                            //for subscriber
                            NSDictionary *subscriberResponseEntity = [responseEntity objectForKey:transactionIdForSubscriber];
                            NSLog(@"Subscriber::sync:subscriberResponseEntity: %@", subscriberResponseEntity);
                            if (nil != subscriberResponseEntity) {
                                int code = [[subscriberResponseEntity objectForKey:@"code"] intValue];
                                if (0 == code) {
                                    NSDictionary *respMsg = [subscriberResponseEntity objectForKey:@"respMsg"];
                                    NSArray *prodInstArray = [respMsg objectForKey:@"prodInstArray"];
                                    NSMutableArray *productArr = [NSMutableArray arrayWithCapacity:0];
                                    for (NSDictionary *dic in prodInstArray) {
                                        Product *product = [[Product alloc] init];
                                        product.mId = [dic objectForKey:@"prodInstId"];
                                        product.mName = [dic objectForKey:@"prodName"];
                                        product.mStartDate = [dic objectForKey:@"startDate"];
                                        product.mEndDate = [dic objectForKey:@"endDate"];
                                        
                                        //add resources
                                        NSArray *prodResArray = [dic objectForKey:@"prodResArray"];
                                        NSMutableArray *resourceArr = [NSMutableArray arrayWithCapacity:0];
                                        for (NSDictionary *resourceDic in prodResArray) {
                                            ProductResource *resource = [[ProductResource alloc] init];
                                            resource.mResourceId = [resourceDic objectForKey:@"resourceId"];
                                            resource.mName = [resourceDic objectForKey:@"resName"];
                                            
                                            
                                            resource.mTotal = [self longLongValueForObject:[resourceDic objectForKey:@"totalAmount"]];
                                            resource.mUsed = [self longLongValueForObject:[resourceDic objectForKey:@"usedAmount"]];
                                            resource.mRemain = [self longLongValueForObject:[resourceDic objectForKey:@"remainAmount"]];
                                            resource.mUnit = [self intValueForObject:[resourceDic objectForKey:@"measureId"]];
                                            resource.mTypeCode = [self intValueForObject:[resourceDic objectForKey:@"typeCode"]];
                                            resource.mUnitPrice = [self doubleValueForObject:[resourceDic objectForKey:@"unitPrice"]];
                                            
                                            [resourceArr addObject:resource];
                                            [resource release];
                                        }
                                        product.mResources = (NSArray *)resourceArr;
                                        
                                        [productArr addObject:product];
                                        [product release];
                                    }
                                    self.mProducts = (NSArray *)productArr;
                                    
                                    //获取瓶子可切换数据
                                    [self getTransferable];
                                    
                                    //更新TTRule
                                    RuleManager *ruleManager = [RuleManager sharedRuleManager];
                                    [ruleManager updateTTRulesWithDelegate:self];
                                    
                                    self.runLoopEnd = YES;
                                } else {
                                    NSDictionary* message = [responseEntity objectForKey:@"message"];
                                    NSLog(@"Subscriber::sync:message=%@", message);
                                    
                                    status = code;
                                }
                            } else {
                                status = MappActorFinishStatusInternalError;
                            }
                            //end of subscriber
                            
                        } else {
                            NSDictionary* message = [defaultAccountResponseEntity objectForKey:@"message"];
                            NSLog(@"Subscriber::sync:message=%@", message);
                            
                            status = code;
                        }
                    } else {
                        status = MappActorFinishStatusInternalError;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Subscriber::sync:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(subscriberSyncFinished:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate subscriberSyncFinished:status];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Subscriber::sync:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
}

- (void)updateTTRulesFinished:(NSInteger)status andInfo:(NSDictionary *)info {
    NSLog(@"Success:: %s and Status: %d", __func__, status);
}

//获取瓶子可切换数据
- (NSArray *)getTransferable {
    NSMutableArray *itemList = [NSMutableArray arrayWithCapacity:0];
    
    Account *currentAccount = self.mDefaultAccount;
    
#if 1
    TransferableItem* item = [[TransferableItem alloc] init];
    
    item.mItemId = currentAccount.mId;
    item.mSubscriberId = currentAccount.mPaidSubscriber.mId;
    item.mSubscriberName = currentAccount.mPaidSubscriber.mName;
    item.mTotalAmount = currentAccount.mTotalAmount;
    item.mUsedAmount = currentAccount.mUsedAmount;
    item.mRemainAmount = currentAccount.mRemainAmount;
    item.mUnit = UnitForMoney;
    item.mTypeCode = 1==currentAccount.mPaidType?1:2;
    item.mOriginalItem = currentAccount;
    
    [itemList addObject:item];
#endif
    
    for (Product *currentProduct in currentAccount.mPaidSubscriber.mProducts) {
        for (ProductResource *resource in currentProduct.mResources) {
            
            TransferableItem *item = [[TransferableItem alloc] init];
            item.mItemId = resource.mResourceId;
            item.mItemName = resource.mName;
            item.mSubscriberId = currentAccount.mPaidSubscriber.mId;
            item.mSubscriberName = currentAccount.mPaidSubscriber.mName;
            item.mTotalAmount = resource.mTotal;
            item.mUsedAmount = resource.mUsed;
            item.mRemainAmount = resource.mRemain;
            item.mUnit = resource.mUnit;
            item.mTypeCode = resource.mTypeCode;
            item.mOriginalItem = resource;
            
            [itemList addObject:item];
        }
    }
    
    NSLog(@"Customer::getTransferable:itemListCount: %lu", (unsigned long)[itemList count]);
    [Session sharedSession].mTransferables = (NSArray *)itemList;
    
    return itemList;
}

- (void)createFromJsonObject:(NSObject *)jsonObject {
    NSMutableArray* products = [NSMutableArray arrayWithCapacity:0];
    
    NSArray* plansList = [(NSDictionary*)jsonObject objectForKey:@"plansList"];
    for (NSDictionary* planInstance in plansList) {
        
        Product* product = [[Product alloc] init];
        product.mServiceId = self.mId;
        [product createFromJsonObject:planInstance];
        
        [products addObject:product];
        [product release];
    }
    
    self.mProducts = products;
}

- (int)queryMyServiceRequestWithState:(int)state andBeginDate:(NSString *)beginDate andEndDate:(NSString *)endDate andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mId forKey:@"subscriberId"];
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
            NSLog(@"%s: %@",__func__, responseEntity);
            
            NSArray *problemArray = nil;
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        NSDictionary *respMsg = [responseEntity objectForKey:@"respMsg"];
                        problemArray = [respMsg objectForKey:@"problemArray"];
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"%s:message=%@",__func__, message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s:exception=%@",__func__, [exception description]);
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
        NSLog(@"%s:exception=%@", __func__,[exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)querySpeededUpAppsWithDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mId forKey:@"subscriberId"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QuerySpeededUpApps";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"%s: %@",__func__, responseEntity);
            
            NSMutableArray *gAppsList = [NSMutableArray arrayWithCapacity:0];
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        NSDictionary *respMsg = [responseEntity objectForKey:@"respMsg"];
                        NSArray *appsList = [respMsg objectForKey:@"appsList"];
                        for (NSDictionary *item in appsList) {
                            AppsInfo *appInfo = [[AppsInfo alloc] init];
                            appInfo.mAppId = [item objectForKey:@"appId"];
                            appInfo.mName = [item objectForKey:@"name"];
                            appInfo.mIconUrl = [item objectForKey:@"iconUrl"];
                            appInfo.mSpeededUp = [self intValueForObject:[item objectForKey:@"speededUp"]];
                            appInfo.mPriority = [self intValueForObject:[item objectForKey:@"priority"]];
                            [gAppsList addObject:appInfo];
                            [appInfo release];
                        }
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"%s:message=%@",__func__, message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s:exception=%@",__func__, [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(querySpeededUpAppsFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate querySpeededUpAppsFinished:status andInfo:gAppsList];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s:exception=%@", __func__,[exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)querySpeededUpProductWithAppId:(NSString *)appId andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:appId forKey:@"appId"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QuerySpeededUpProduct";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"%s: %@",__func__, responseEntity);
            
            NSMutableArray *gProdList = [NSMutableArray arrayWithCapacity:0];
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        NSDictionary *respMsg = [responseEntity objectForKey:@"respMsg"];
                        NSArray *prodList = [respMsg objectForKey:@"prodList"];
                        
                        for (NSDictionary* offer in prodList) {
                            ProductOffer* productOffer = [[ProductOffer alloc] init];
                            [productOffer createFromJsonObject:offer];
                            
                            [gProdList addObject:productOffer];
                            [productOffer release];
                        }
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"%s:message=%@",__func__, message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s:exception=%@",__func__, [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(querySpeededUpProductFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate querySpeededUpProductFinished:status andInfo:gProdList];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s:exception=%@", __func__,[exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)queryAppsPriorityWithDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mId forKey:@"subscriberId"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QueryAppsPriority";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"%s: %@",__func__, responseEntity);
            
            NSMutableArray *gAppsList = [NSMutableArray arrayWithCapacity:0];
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        NSDictionary *respMsg = [responseEntity objectForKey:@"respMsg"];
                        NSArray *appsList = [respMsg objectForKey:@"appsList"];
                        for (NSDictionary *item in appsList) {
                            AppsInfo *appInfo = [[AppsInfo alloc] init];
                            appInfo.mAppId = [item objectForKey:@"appId"];
                            appInfo.mName = [item objectForKey:@"name"];
                            appInfo.mIconUrl = [item objectForKey:@"iconUrl"];
                            appInfo.mSpeededUp = [self intValueForObject:[item objectForKey:@"speededUp"]];
                            appInfo.mPriority = [self intValueForObject:[item objectForKey:@"priority"]];
                            [gAppsList addObject:appInfo];
                            [appInfo release];
                        }
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"%s:message=%@",__func__, message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s:exception=%@",__func__, [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(queryAppsPriorityFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate queryAppsPriorityFinished:status andInfo:gAppsList];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s:exception=%@", __func__,[exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)setAppsPriorityWithAppsList:(NSArray *)appsList andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    NSMutableArray *gAppsList = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *gAppsDic = nil;
    for (AppsInfo *appsInfo in appsList) {
        gAppsDic = [NSMutableDictionary dictionary];
        
        [gAppsDic setObject:appsInfo.mAppId forKey:@"appId"];
        [gAppsDic setObject:appsInfo.mName forKey:@"name"];
        [gAppsDic setObject:appsInfo.mIconUrl forKey:@"iconUrl"];
        [gAppsDic setObject:[NSNumber numberWithInt:appsInfo.mSpeededUp] forKey:@"speededUp"];
        [gAppsDic setObject:[NSNumber numberWithInt:appsInfo.mPriority] forKey:@"priority"];
        
        [gAppsList addObject:gAppsDic];
    }
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mId forKey:@"subscriberId"];
        [busiParams setObject:gAppsList forKey:@"appsList"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"SetAppsPriority";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"%s: %@",__func__, responseEntity);
            
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        NSDictionary *respMsg = [responseEntity objectForKey:@"respMsg"];
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"%s:message=%@",__func__, message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s:exception=%@",__func__, [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(setAppsPriorityFinished:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate setAppsPriorityFinished:status];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s:exception=%@", __func__,[exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

@end