//
//  ProductOffer.m
//  RTSS
//
//  Created by Lyu Ming on 11/14/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "define.h"
#import "ProductOffer.h"
#import "MappClient.h"
#import "EventItem.h"
#import "Events.h"
#import "Session.h"

extern BOOL ppUrlGenerateWithoutMapp; // __PP_URL_GENERATE_WITHOUT_MAPP__

extern NSString* xApiKey;
extern NSString* ppUrlGenerator;
extern NSString* rtssChannel;

#define __KEY_PRODUCTOFFER_PRODUCTID__ @"PRODUCTOFFER_PRODUCTID"
#define __KEY_PRODUCTOFFER_OFFERID__ @"PRODUCTOFFER_OFFERID"
#define __KEY_PRODUCTOFFER_NEGOTIABLE__ @"PRODUCTOFFER_NEGOTIABLE"
#define __KEY_PRODUCTOFFER_NAME__ @"PRODUCTOFFER_NAME"
#define __KEY_PRODUCTOFFER_DESCRIPTION__ @"PRODUCTOFFER_DESCRIPTION"
#define __KEY_PRODUCTOFFER_PRICE__ @"PRODUCTOFFER_PRICE"
#define __KEY_PRODUCTOFFER_RESOURCES__ @"PRODUCTOFFER_RESOURCES"

@interface ProductOffer ()

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

@implementation ProductOffer

@synthesize mOfferId;
@synthesize mName;
@synthesize mDescription;
@synthesize mAutoRenew;
@synthesize mNegotiable;
@synthesize mType;
@synthesize mBillingType;
@synthesize mSubType;
@synthesize mPriceType;
@synthesize mPrice;
@synthesize mTaxable;
@synthesize mResources;

@synthesize mDetail;
@synthesize mOfferingTypeName;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.mNegotiable = [aDecoder decodeBoolForKey:__KEY_PRODUCTOFFER_NEGOTIABLE__];
    self.mName = [aDecoder decodeObjectForKey:__KEY_PRODUCTOFFER_NAME__];
    self.mDescription = [aDecoder decodeObjectForKey:__KEY_PRODUCTOFFER_DESCRIPTION__];
    self.mPrice = [aDecoder decodeInt64ForKey:__KEY_PRODUCTOFFER_PRICE__];
    self.mResources = [aDecoder decodeObjectForKey:__KEY_PRODUCTOFFER_RESOURCES__];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:mNegotiable forKey:__KEY_PRODUCTOFFER_NEGOTIABLE__];
    [aCoder encodeObject:mName forKey:__KEY_PRODUCTOFFER_NAME__];
    [aCoder encodeObject:mDescription forKey:__KEY_PRODUCTOFFER_DESCRIPTION__];
    [aCoder encodeInt64:mPrice forKey:__KEY_PRODUCTOFFER_PRICE__];
    [aCoder encodeObject:mResources forKey:__KEY_PRODUCTOFFER_RESOURCES__];
}

- (void)dealloc {
    [mOfferId release];
    [mName release];
    [mDescription release];
    [mResources release];
    
    [mDetail release];
    [mOfferingTypeName release];
    
    [super dealloc];
}

- (void)createFromJsonObject:(NSObject *)jsonObject {
    NSString* offerId = [(NSDictionary*)jsonObject objectForKey:@"offeringId"];
    NSString* name = [(NSDictionary*)jsonObject objectForKey:@"offeringName"];
    NSString* description = [(NSDictionary*)jsonObject objectForKey:@"offeringDesc"];
    BOOL autoRenew = [self boolValueForObject:[(NSDictionary*)jsonObject objectForKey:@"autoRenew"]];
    BOOL negotiable = [self boolValueForObject:[(NSDictionary*)jsonObject objectForKey:@"negotiable"]];
    int type = [self intValueForObject:[(NSDictionary*)jsonObject objectForKey:@"offeringTypeCode"]];
    NSString *offeringTypeName = [(NSDictionary *)jsonObject objectForKey:@"offeringTypeName"];
    int billingType = [self intValueForObject:[(NSDictionary*)jsonObject objectForKey:@"billingType"]];
    NSLog(@"ProductOffer::createFromJsonObject:offerId=%@, name=%@, description=%@, autoRenew=%@, negotiable=%@, type=%d, billingType=%d, offeringTypeName=%@", offerId, name, description, (YES == autoRenew ? @"YES" : @"NO"), (YES == negotiable ? @"YES" : @"NO"), type, billingType, offeringTypeName);
    
    NSDictionary* priceInfo = [(NSDictionary*)jsonObject objectForKey:@"price"];
    long price = [self intValueForObject:[priceInfo objectForKey:@"priceValue"]];
    
    NSArray *specArray = [(NSDictionary *)jsonObject objectForKey:@"specArray"];
    NSArray *locationArray = [(NSDictionary *)jsonObject objectForKey:@"locationArray"];
    self.mDetail = [NSDictionary dictionaryWithObjectsAndKeys:specArray, @"specArray", locationArray, @"locationArray", nil];
    
    self.mOfferId = offerId;
    self.mName = name;
    self.mDescription = description;
    self.mAutoRenew = autoRenew;
    self.mNegotiable = negotiable;
    self.mType = type;
    self.mOfferingTypeName= offeringTypeName;
    self.mBillingType = billingType;
    self.mPrice = price;
    
    //add resources
    NSMutableArray *resourceList = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *productSpecificationDic in specArray) {
        //当specType为1和2时，是account类型，需要过滤掉
        int specType = [[productSpecificationDic objectForKey:@"specType"] intValue];
//        if (specType == 1 || specType == 2) {
//            continue;
//        }

        NSArray *characteristicArr = [productSpecificationDic objectForKey:@"characteristics"];
        for (NSDictionary * characterDic in characteristicArr) {
            ProductResource *resource = [[ProductResource alloc] init];
            resource.mResourceId = [characterDic objectForKey:@"charId"];
            resource.mName = [characterDic objectForKey:@"charName"];
            resource.mTypeCode = specType;
            resource.mTotal = [self longLongValueForObject:[characterDic objectForKey:@"charValue"]];
            resource.mUnit = [self intValueForObject:[characterDic objectForKey:@"measureCode"]];
            [resourceList addObject:resource];
        }
        
    }
    self.mResources = (NSArray *)resourceList;
    //end of add resources
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

+ (int)rechargeWithoutMapp:(Customer *)customer offerList:(NSArray *)offerList delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    if (nil != delegate && [delegate respondsToSelector:@selector(rechargeFinished:payParams:)]) {
        dispatch_async(dispatch_get_main_queue(), ^ {
            [delegate rechargeFinished:status payParams:@"http://www.songye.com"];
        });
    }
    
    return status;
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
                        NSLog(@"ProductOffer::recharge:tranRefNum=%@", tranRefNum);
                        
                        NSString* body = [self createBody:customer andServiceId:serviceId andAmount:amount andTranRefNum:tranRefNum];
                        
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
                        NSLog(@"ProductOffer::recharge:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"ProductOffer::recharge:exception=%@", [exception description]);
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
        NSLog(@"ProductOffer::recharge:exception=%@", [exception description]);
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
        [xmlData appendString:self.mOfferId];
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
        NSLog(@"ProductOffer::createBody:body=%@", body);
    }
    @catch (NSException *exception) {
        NSLog(@"ProductOffer::createBody::exception: %@", exception.description);
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
        [busiParams setObject:self.mOfferId forKey:@"prodId"];
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
                        NSLog(@"ProductOffer::recharge:returnUrl=%@", returnUrl);
                        
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
                            NSLog(@"ProductOffer::recharge:exception=%@", [exception description]);
                        }
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"ProductOffer::recharge:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"ProductOffer::recharge:exception=%@", [exception description]);
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
        NSLog(@"ProductOffer::recharge:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

@end
