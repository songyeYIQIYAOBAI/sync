//
//  Product.m
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "define.h"
#import "Product.h"
#import "MappClient.h"
#import "Subscriber.h"
#import "UserDefaults.h"
#import "ProductResource.h"
#import "Customer.h"
#import "EventItem.h"
#import "Events.h"
#import "Session.h"

extern BOOL ppUrlGenerateWithoutMapp; // __PP_URL_GENERATE_WITHOUT_MAPP__

extern NSString* xApiKey;
extern NSString* ppUrlGenerator;
extern NSString* rtssChannel;

#define __KEY_PRODUCT_PRODUCTID__ @"PRODUCT_PRODUCTID"
#define __KEY_PRODUCT_OFFERID__ @"PRODUCT_OFFERID"
#define __KEY_PRODUCT_TYPE__ @"PRODUCT_TYPE"
#define __KEY_PRODUCT_NAME__ @"PRODUCT_NAME"
#define __KEY_PRODUCT_RESOURCES__ @"PRODUCT_RESOURCES"
#define __KEY_SUBSCRIBER_MAINPRODUCT__ @"SUBSCRIBER_MAINPRODUCT"

@interface Product ()

- (void)bindPrice;
- (void)queryDetail;
- (int)transfer:(NSString*)fromMdn to:(NSString*)toMdn ruleId:(int)ruleId times:(long)times delegate:(id<MappActorDelegate>)delegate;

- (int)rechargeWithoutMapp:(Customer *)customer
                 serviceId: (NSString *)serviceId
                    amount:(long long)amount
                  delegate:(id<MappActorDelegate>)delegate;
- (int)rechargeWithMapp:(Customer *)customer
              serviceId: (NSString *)serviceId
                 amount:(long long)amount
                payType:(int)payType
               delegate:(id<MappActorDelegate>)delegate;

- (NSString *)createBody:(Customer *)customer
            andServiceId:(NSString *)serviceId
               andAmount:(long long)amount
           andTranRefNum:(NSString *)tranRefNum;

@end

@implementation Product

@synthesize mId;
@synthesize mServiceId;
@synthesize mOfferId;
@synthesize mName;
@synthesize mPrice;
@synthesize mType;
@synthesize mAutoRenew;
@synthesize mStartDate;
@synthesize mEndDate;
@synthesize mResources;

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (void)dealloc{
    [mId release];
    [mOfferId release];
    [mName release];
    [mStartDate release];
    [mEndDate release];
    [mResources release];
    
    [super dealloc];
}

- (void)load {
    Product* product = [[UserDefaults standardUserDefaults] getUnarchiveObjcetWithKey:__KEY_SUBSCRIBER_MAINPRODUCT__];
    self.mOfferId = product.mOfferId;
    self.mId = product.mId;
    self.mName = product.mName;
    [self.mName retain];
    self.mType = product.mType;
    self.mResources = product.mResources;
}

- (void)save {
    [[UserDefaults standardUserDefaults] setArchiveDataWithObject:self forKey:__KEY_SUBSCRIBER_MAINPRODUCT__];
}

- (void)createFromJsonObject:(NSObject *)jsonObject {
    NSString* planId = [(NSDictionary*)jsonObject objectForKey:@"planId"];
    NSString* name = [(NSDictionary*)jsonObject objectForKey:@"name"];
    BOOL autoRenew = [[(NSDictionary*)jsonObject objectForKey:@"autoRenew"] boolValue];
    int type = [[(NSDictionary*)jsonObject objectForKey:@"type"] intValue];
    NSString* startDate = [(NSDictionary*)jsonObject objectForKey:@"startDate"];
    NSString* endDate = [(NSDictionary*)jsonObject objectForKey:@"endDate"];
    NSLog(@"Product::createFromJsonObject:planId=%@, name=%@, autoRenew=%@, type=%d, startDate=%@, endDate=%@",
                                planId, name, [[NSNumber numberWithBool:autoRenew] stringValue], type, startDate, endDate);
    
    self.mId = planId;
    self.mName = name;
    self.mType = type;
    self.mAutoRenew = autoRenew;
    self.mStartDate = startDate;
    self.mEndDate = endDate;
    
    NSMutableArray* resources = [NSMutableArray arrayWithCapacity:0];
    
    NSArray* balanceBuckets = [(NSDictionary*)jsonObject objectForKey:@"balanceBuckets"];
    for (NSDictionary* balanceBucket in balanceBuckets) {
        
        ProductResource* resource = [[ProductResource alloc] init];
        resource.mProductId = self.mId;
        [resource createFromJsonObject:balanceBucket];
        
        [resources addObject:resource];
        [resource release];
    }
    
    self.mResources = resources;
    
    [self queryDetail];
}

- (int)rechargeWithoutMapp:(Customer *)customer
                 serviceId: (NSString *)serviceId
                    amount:(long long)amount
                  delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:[NSNumber numberWithInt:1] forKey:@"transactionType"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"GetTransactionRefNum";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            NSString* payParams = nil;
            @try {
                
                if (0 == status) {
                    int code = MappActorFinishStatusInternalError;
                    if (nil != [responseEntity objectForKey:@"code"] && 0 == (code = [[responseEntity objectForKey:@"code"] intValue]))  {
                        NSDictionary* respMsg = [responseEntity  objectForKey:@"respMsg"];
                        
                        NSString* tranRefNum = [respMsg objectForKey:@"tranRefNum"];
                        NSLog(@"Product::recharge:tranRefNum=%@", tranRefNum);
                        
                        NSString *body = [self createBody:customer andServiceId:serviceId andAmount:amount andTranRefNum:tranRefNum];
                        
                        NSMutableDictionary* header = [NSMutableDictionary dictionaryWithCapacity:0];
                        [header setObject:@"application/xml" forKey:@"Content-Type"];
                        [header setObject:xApiKey forKey:@"X-API-KEY"];
                        
                        NSString* returnURL = [[MappClient sharedMappClient] callWebService:ppUrlGenerator body:body header:header];
                        if (nil != returnURL && 0 < [returnURL length]){
                            payParams = returnURL;
                            status = code;
                        } else {
                            status = MappActorFinishStatusInternalError;
                        }
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"Product::recharge:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Product::recharge:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(rechargeFinished:payParams:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate rechargeFinished:status payParams:payParams];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Product::recharge:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (NSString *)createBody:(Customer *)customer andServiceId:(NSString *)serviceId andAmount:(long long)amount andTranRefNum:(NSString *)tranRefNum {
    NSString *body = nil;
    @try {
        NSMutableString *xmlData = [[NSMutableString alloc] initWithCapacity:0];
        [xmlData appendString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:rep=\"http://r4g.ril.com/2014/replenishBalance.xsd\">"];
        [xmlData appendString:@"<soapenv:Header />"];
        [xmlData appendString:@"<soapenv:Body>"];
        [xmlData appendString:@"<rep:replenishBalanceRequest>"];
        [xmlData appendString:@"<rep:ReplenishmentOrderHeader>"];
        [xmlData appendString:@"<rep:RechargeOrderRefNo>"];
        [xmlData appendString:tranRefNum];
        [xmlData appendString:@"</rep:RechargeOrderRefNo>"];
        [xmlData appendString:@"<rep:TransactionDateTime>"];
        [xmlData appendString:[DateUtils getStringDateByDate:[NSDate date] dateFormat:@"yyyy-MM-dd'T'HH:mm:ss"]];
        [xmlData appendString:@"</rep:TransactionDateTime>"];
        [xmlData appendString:@"<rep:Channel>"];
        [xmlData appendString:rtssChannel];
        [xmlData appendString:@"</rep:Channel>"];
        
        NSString *token = [[Session sharedSession] mToken];
        if (nil != token && [token isEqualToString:@""] == NO) {
            [xmlData appendFormat:@"<rep:SSOID>%@</rep:SSOID>", token];
        }
        
        [xmlData appendString:@"</rep:ReplenishmentOrderHeader>"];
        [xmlData appendString:@"<rep:PaymentDetails>"];
        [xmlData appendString:@"<rep:ModeOfPayment>06</rep:ModeOfPayment>"];
        [xmlData appendString:@"</rep:PaymentDetails>"];
        [xmlData appendString:@"<rep:ReplenishmentOrderLineItem>"];
        [xmlData appendString:@"<rep:ProductID>"];
        [xmlData appendString:self.mId];
        [xmlData appendString:@"</rep:ProductID>"];
        [xmlData appendFormat:@"<rep:Amount>%.2f</rep:Amount>", amount * 1.0 / 100];
        [xmlData appendString:@"<rep:ListofAccounts>"];
        [xmlData appendString:@"<rep:Account>"];
        [xmlData appendString:@"<rep:AccountID>"];
        [xmlData appendFormat:@"%@", [Session sharedSession].mCurrentAccount.mId];
        [xmlData appendString:@"</rep:AccountID>"];
        [xmlData appendString:@"</rep:Account>"];
        [xmlData appendString:@"</rep:ListofAccounts>"];
        [xmlData appendString:@"<rep:Product>"];
        [xmlData appendString:@"<rep:Identifier>"];
        [xmlData appendString:@"<rep:Value>"];
        [xmlData appendFormat:@"%@", serviceId];
        [xmlData appendString:@"</rep:Value>"];
        [xmlData appendString:@"</rep:Identifier>"];
        [xmlData appendString:@"<rep:Service>"];
        [xmlData appendString:@"<rep:Identifier/>"];
        [xmlData appendString:@"</rep:Service>"];
        [xmlData appendString:@"</rep:Product>"];
        [xmlData appendString:@"</rep:ReplenishmentOrderLineItem>"];
        [xmlData appendString:@"</rep:replenishBalanceRequest>"];
        [xmlData appendString:@"</soapenv:Body>"];
        [xmlData appendString:@"</soapenv:Envelope>"];
        
        body = (NSString *)[xmlData copy];
        [xmlData release];
        NSLog(@"Product::createBody:body=%@", body);
    }
    @catch (NSException *exception) {
        NSLog(@"Product::createBody::exception: %@", exception.description);
    }
    
    return [body autorelease];
}

- (int)rechargeWithMapp:(Customer *)customer
                 serviceId: (NSString *)serviceId
                    amount:(long long)amount
                payType:(int)payType
               delegate:(id<MappActorDelegate>)delegate {
    
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:customer.mId forKey:@"customerId"];
        [busiParams setObject:[Session sharedSession].mCurrentAccount.mId forKey:@"accountId"];
        [busiParams setObject:serviceId forKey:@"serviceId"];
        [busiParams setObject:self.mId forKey:@"prodId"];
        [busiParams setObject:[NSNumber numberWithLongLong:amount] forKey:@"amount"];
        [busiParams setObject:[NSNumber numberWithInt:payType] forKey:@"payType"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"Recharge";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            NSString* payParams = nil;
            @try {
                
                if (0 == status) {
                    int code = MappActorFinishStatusInternalError;
                    if (nil != [responseEntity objectForKey:@"code"] && 0 == (code = [[responseEntity objectForKey:@"code"] intValue])) {
                        NSDictionary* respMsg = [responseEntity objectForKey:@"respMsg"];
                        
                        NSString* returnUrl = [respMsg objectForKey:@"returnURL"];
                        NSLog(@"Product::recharge:returnUrl=%@", returnUrl);
                        
                        payParams = returnUrl;
                        
                        @try {
                            EventItem* event = [[EventItem alloc] init];
                            event.mDescription = @"recharge";
                            event.mPeerPhoneNumber = serviceId;
                            event.mTimeStamp = time(NULL);
                            event.mType = EventTypeRecharge;
                            
                            NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:0];
                            [parameters setObject:[NSNumber numberWithLongLong:amount] forKey:@"amount"];
                            [parameters setObject:serviceId forKey:@"serviceId"];
                            [parameters setObject:[NSNumber numberWithInt:status] forKey:@"status"];
                            event.mParameters = parameters;
                            
                            [[Events sharedEvents] addEvent:event];
                            [event release];
                        }
                        @catch (NSException *exception) {
                            NSLog(@"Product::recharge:exception=%@", [exception description]);
                        }
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"Product::recharge:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Product::recharge:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(rechargeFinished:payParams:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate rechargeFinished:status payParams:payParams];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Product::recharge:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)recharge:(Customer*)customer
      serviceId:(NSString*)serviceId
         amount:(long long)amount
        payType:(int)payType
       delegate:(id<MappActorDelegate>)delegate {
    
    return YES == ppUrlGenerateWithoutMapp
            ? [self rechargeWithoutMapp:customer serviceId:serviceId amount:amount delegate:delegate]
            : [self rechargeWithMapp:customer serviceId:serviceId amount:amount payType:payType delegate:delegate];
}

- (int)transform:(int)fromResourceId to:(int)toResourceId amount:(long long)amount delegate:(id<MappActorDelegate>)delegate {
    int status = 0;
    
    
    return status;
}

- (int)transfer:(NSString*)toMdn resource:(int)resourceId amount:(long long)amount delegate:(id<MappActorDelegate>)delegate {
    int status = 0;
    
    
    return status;
}

- (int)transfer:(NSString*)fromMdn to:(NSString*)toMdn ruleId:(int)ruleId times:(long)times delegate:(id<MappActorDelegate>)delegate {
    int status = 0;
    
    
    return status;
}

- (void)bindPrice {
    @try {
        NSDictionary* detail = [[Session sharedSession] getProductOfferDetail:self.mId];
        if (nil != detail && 0 < [detail count]) {
            NSDictionary* priceInfo = [detail objectForKey:@"price"];
            long long price = [[priceInfo objectForKey:@"price"] longLongValue];
            NSLog(@"Product::bindPrice:price=%lld", price);
            self.mPrice = price;
        } else {
            [self queryDetail];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Product::bindPrice:exception=%@", [exception description]);
    }
}

- (void)queryDetail {

    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:[NSArray arrayWithObject:self.mId] forKey:@"prodIdArray"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QueryProductDetail";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            @try {
                
                if (0 == status) {
                    int code = MappActorFinishStatusInternalError;
                    if (nil != [responseEntity objectForKey:@"code"] && 0 == (code = [[responseEntity objectForKey:@"code"] intValue])) {
                        NSDictionary* respMsg = [responseEntity objectForKey:@"respMsg"];
                        NSArray* detailList = [respMsg objectForKey:@"planDetailList"];
                        NSDictionary* detail = [detailList objectAtIndex:0];
                        NSDictionary* priceInfo = [detail objectForKey:@"price"];
                        
                        long long price = [[priceInfo objectForKey:@"price"] longLongValue];
                        NSLog(@"Product::queryDetail:price=%lld", price);
                        self.mPrice = price;
                        
                        [[Session sharedSession] setProductOfferDetail:detail withOfferId:self.mId];
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"Product::queryDetail:message=%@", message);
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Product::queryDetail:exception=%@", [exception description]);
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Product::queryDetail:exception=%@", [exception description]);
    }
}

- (int)queryNegotiationFormulaWithDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mId forKey:@"prodId"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QueryNegotiationFormula";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"%s: %@",__func__, responseEntity);
            
            NSDictionary *respMsg = nil;
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        respMsg = [responseEntity objectForKey:@"respMsg"];
                        
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
                if (nil != delegate && [delegate respondsToSelector:@selector(queryNegotiationFormulaFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate queryNegotiationFormulaFinished:status andInfo:respMsg];
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
