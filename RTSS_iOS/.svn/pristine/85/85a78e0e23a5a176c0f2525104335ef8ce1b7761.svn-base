//
//  Account.m
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "define.h"
#import "Account.h"
#import "MappClient.h"
#import "EventItem.h"
#import "Events.h"
#import "User.h"
#import "Friends.h"
#import "Session.h"
#import "DateUtils.h"

extern BOOL ppUrlGenerateWithoutMapp; //__PP_URL_GENERATE_WITHOUT_MAPP__

extern NSString* xApiKey;
extern NSString* ppUrlGenerator;
extern NSString* rtssChannel;
extern NSString* topupProduct;
extern NSString* topupAccountCharName;
extern NSString* topupAccountCharValue;

@interface Account ()

- (int)topupWithMapp:(long long)amount delegate:(id<MappActorDelegate>)delegate;
- (int)topupWithoutMapp:(long long)amount delegate:(id<MappActorDelegate>)delegate;

- (NSString*)createBody:(long long)amount tranRefNum:(NSString*)tranRefNum;

@end

@implementation Account

@synthesize mId;
@synthesize mMyCustomer;
@synthesize mParentAccount;
@synthesize mSubAccounts;
@synthesize mPaidSubscriber;
@synthesize mPaidType;
@synthesize mTotalAmount;
@synthesize mRemainAmount;
@synthesize mUsedAmount;
@synthesize mStatus;
@synthesize mValidDate;
@synthesize mExpiryDate;





- (id)init {
    if (self = [super init]) {
        self.mSubAccounts = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        self.mMyCustomer = [Session sharedSession].mMyCustomer;
    }
    
    return self;
}

- (void)dealloc {
    [mId release];
    [mMyCustomer release];
    [mParentAccount release];
    [mSubAccounts release];
    [mPaidSubscriber release];
    [mValidDate release];
    [mExpiryDate release];
    
    [super dealloc];
}

- (int)sync:(id<MappActorDelegate>)delegate {
    return 0;
}

- (void)createFromJsonObject:(NSObject*)jsonObject {
    NSDictionary* monetaryBucket = [(NSDictionary*)jsonObject objectForKey:@"monetaryBucket"];
    long long originalAmount = [[monetaryBucket objectForKey:@"originalAmount"] longLongValue];
    long long amount = [[monetaryBucket objectForKey:@"amount"] longLongValue];
    NSString* expiryDate = [monetaryBucket objectForKey:@"expiryDate"];
    NSLog(@"Account::createFromJsonObject:originalAmount=%lld, amount=%lld, expiryDate=%@", originalAmount, amount, expiryDate);
    
    self.mTotalAmount = originalAmount;
    self.mRemainAmount = amount;
    self.mExpiryDate = expiryDate;
}

- (int)transferFrom:(NSString *)from andTo:(NSString *)to andAmount:(long long)amount andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:from forKey:@"donorId"];
        [busiParams setObject:to forKey:@"recipientId"];
        [busiParams setObject:[NSNumber numberWithInt:1] forKey:@"transactionType"];
        
        NSMutableDictionary *donorResInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [donorResInfo setObject:[NSNumber numberWithLongLong:amount] forKey:@"amount"];
        [donorResInfo setObject:[NSNumber numberWithInt:2] forKey:@"measureId"];
        [busiParams setObject:donorResInfo forKey:@"donorResInfo"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"TransferTransfrom";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"Account::transferFrom:responseEntity: %@", responseEntity);
            @try {
                if (0 == status) {
                    int code = [[requestEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
//                        NSDictionary *respMsg = [requestEntity objectForKey:@"respMsg"];

                    } else {
                        NSDictionary* message = [requestEntity objectForKey:@"message"];
                        NSLog(@"Account::transferFrom:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Account::transferFrom:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(transferBalanceFinished:result:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate transferBalanceFinished:status result:nil];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Account::transferFrom:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)transferBalance:(long long)amount toPeer:(NSString*)peerServiceId delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mMyCustomer.mId forKey:@"orgCustomerId"];
        [busiParams setObject:self.mId forKey:@"orgServiceId"];
        [busiParams setObject:peerServiceId forKey:@"targetServiceId"];
        [busiParams setObject:[NSNumber numberWithLongLong:amount] forKey:@"amount"];
        [busiParams setObject:[NSNumber numberWithInt:2] forKey:@"measureId"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"TransferBalance";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            NSDictionary* result = nil;
            @try {
                
                if (0 == status) {
                    int code = MappActorFinishStatusInternalError;
                    if (nil != [responseEntity objectForKey:@"code"] && 0 == (code = [[responseEntity objectForKey:@"code"] intValue])) {
                        result = [responseEntity objectForKey:@"respMsg"];
                        
                        long long balancePreTransfer = [[result objectForKey:@"preBalance"] longLongValue];
                        long long balancePostTransfer = [[result objectForKey:@"posBalance"] longLongValue];
                        NSString* validityDate = [result objectForKey:@"validityDate"];
                        long long charge = [[result objectForKey:@"processingFee"] longLongValue];
                        long long serverSaidAmount = [[result objectForKey:@"amount"] longLongValue];
                        NSLog(@"Account::transferBalance:balancePreTransfer=%lld, balancePostTransfer=%lld, validityDate=%@, charge=%lld, serverSaidAmount=%lld", balancePreTransfer, balancePostTransfer, validityDate, charge, serverSaidAmount);
                        
//                        self.mAmount = balancePostTransfer;
                        
                        @try {
                            EventItem* event = [[EventItem alloc] init];
                            event.mDescription = @"balance transfer";
                            event.mPeerPhoneNumber = peerServiceId;
                            event.mTimeStamp = time(NULL);
                            event.mType = EventTypeBalanceTransferOut;
                            
                            NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:0];
                            [parameters setObject:[NSNumber numberWithLongLong:amount] forKey:@"amount"];
                            [parameters setObject:self.mId forKey:@"serviceId"];
                            [parameters setObject:peerServiceId forKey:@"targetServiceId"];
                            [parameters setObject:[NSNumber numberWithInt:status] forKey:@"status"];
                            event.mParameters = parameters;
                            
                            [[Events sharedEvents] addEvent:event];
                            [event release];
                        }
                        @catch (NSException *exception) {
                            NSLog(@"Account::transferBalance:exception=%@", [exception description]);
                        }
                        
                        @try {
                            User* user = [[User alloc] init];
                            user.mId = peerServiceId;
                            user.mName = peerServiceId;
                            user.mPhoneNumber = peerServiceId;
                            
                            [[Friends shareFriends] add:user];
                            [user release];
                        }
                        @catch (NSException *exception) {
                            NSLog(@"Account::transferBalance:exception=%@", [exception description]);
                        }
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"Account::transferBalance:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Account::transferBalance:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(transferBalanceFinished:result:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate transferBalanceFinished:status result:result];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Account::transferBalance:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)topup:(long long)amount delegate:(id<MappActorDelegate>)delegate {
    return YES == ppUrlGenerateWithoutMapp ? [self topupWithoutMapp:amount delegate:delegate] : [self topupWithMapp:amount delegate:delegate];
}

- (int)topupWithMapp:(long long)amount delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mMyCustomer.mId forKey:@"customerId"];
        [busiParams setObject:mId forKey:@"accountId"];
        [busiParams setObject:[NSNumber numberWithInt:1] forKey:@"type"];
        [busiParams setObject:[NSNumber numberWithLongLong:amount] forKey:@"amount"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"DoTopUp";
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
                        NSLog(@"Account::topup:returnUrl=%@", returnUrl);
                        
                        payParams = returnUrl;
                        
                        @try {
                            EventItem* event = [[EventItem alloc] init];
                            event.mDescription = @"topup";
                            event.mPeerPhoneNumber = self.mId;
                            event.mTimeStamp = time(NULL);
                            event.mType = EventTypeTopup;
                            
                            NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:0];
                            [parameters setObject:[NSNumber numberWithLongLong:amount] forKey:@"amount"];
                            [parameters setObject:self.mId forKey:@"serviceId"];
                            [parameters setObject:[NSNumber numberWithInt:status] forKey:@"status"];
                            event.mParameters = parameters;
                            
                            [[Events sharedEvents] addEvent:event];
                            [event release];
                        }
                        @catch (NSException *exception) {
                            NSLog(@"Account::transferBalance:exception=%@", [exception description]);
                        }
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"Account::topup:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Account::topup:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(topupFinished:payParams:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate topupFinished:status payParams:payParams];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Account::topup:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)topupWithoutMapp:(long long)amount delegate:(id<MappActorDelegate>)delegate {
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
                    if (nil != [responseEntity objectForKey:@"code"] && 0 == (code = [[responseEntity objectForKey:@"code"] intValue])) {
                        NSDictionary* respMsg = [responseEntity objectForKey:@"respMsg"];
                        
                        NSString* tranRefNum = [respMsg objectForKey:@"tranRefNum"];
                        NSLog(@"Account::topup:tranRefNum=%@", tranRefNum);
                        
                        NSString* body = [self createBody:amount tranRefNum:tranRefNum];
                        
                        NSMutableDictionary* header = [NSMutableDictionary dictionaryWithCapacity:0];
                        [header setObject:@"application/xml" forKey:@"Content-Type"];
                        [header setObject:xApiKey forKey:@"X-API-KEY"];
                        
                        NSString* returnURL = [[MappClient sharedMappClient] callWebService:ppUrlGenerator body:body header:header];
                        NSLog(@"ur == %@",returnURL);
                        if (nil != returnURL && 0 < [returnURL length]){
                            payParams = returnURL;
                            status = code;
                        } else {
                            status = MappActorFinishStatusInternalError;
                        }
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"Account::topup:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Account::topup:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(topupFinished:payParams:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate topupFinished:status payParams:payParams];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Account::topup:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (NSString*)createBody:(long long)amount tranRefNum:(NSString*)tranRefNum {
    NSString* body = nil;
    
    @try {

        int type = 1;
        
        NSMutableString* xmlData = [NSMutableString stringWithCapacity:0];
        [xmlData appendString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:rep=\"http://r4g.ril.com/2014/replenishBalance.xsd\">"];
        [xmlData appendString:@"<soapenv:Header />"];
        [xmlData appendString:@"<soapenv:Body>"];
        [xmlData appendString:@"<rep:replenishBalanceRequest>"];
        [xmlData appendString:@"<rep:ReplenishmentOrderHeader>"];
        [xmlData appendFormat:@"<rep:RechargeOrderRefNo>%@</rep:RechargeOrderRefNo>", tranRefNum];
        [xmlData appendFormat:@"<rep:TransactionDateTime>%@</rep:TransactionDateTime>",
            [DateUtils getStringDateByDate:[NSDate date] dateFormat:@"yyyy-MM-dd'T'HH:mm:ss"]];
        [xmlData appendFormat:@"<rep:Channel>%@</rep:Channel>", rtssChannel];
        
        NSString* token = [Session sharedSession].mToken;
        if (nil != token && 0 < [token length]) {
            [xmlData appendFormat:@"<rep:SSOID>%@</rep:SSOID>", token];
        }
        
        [xmlData appendString:@"</rep:ReplenishmentOrderHeader>"];
        [xmlData appendString:@"<rep:PaymentDetails>"];
        [xmlData appendString:@"<rep:ModeOfPayment>06</rep:ModeOfPayment>"];
        [xmlData appendString:@"</rep:PaymentDetails>"];
        [xmlData appendString:@"<rep:ReplenishmentOrderLineItem>"];
        [xmlData appendFormat:@"<rep:ProductID>%@</rep:ProductID>", topupProduct];
        [xmlData appendFormat:@"<rep:Amount>%.2f</rep:Amount>", amount * 1.0 / 100];
        
        if (1 == type) {
            [xmlData appendString:@"<rep:ListofAccounts>"];
            [xmlData appendString:@"<rep:Account>"];
            [xmlData appendFormat:@"<rep:AccountID>%@</rep:AccountID>", mId];
            [xmlData appendString:@"</rep:Account>"];
            [xmlData appendString:@"</rep:ListofAccounts>"];
        }
        
        [xmlData appendString:@"<rep:Product>"];
        [xmlData appendString:@"<rep:Identifier>"];
        
        if (1 == type) {
            Account* subAccount = [[Session sharedSession].mCurrentAccount.mSubAccounts objectAtIndex:0];
            [xmlData appendFormat:@"<rep:Value>%@</rep:Value>", subAccount.mId];
        } else {
            [xmlData appendFormat:@"<rep:Value>%@</rep:Value>", mId];
        }
        
        [xmlData appendString:@"</rep:Identifier>"];
        [xmlData appendString:@"<rep:Service>"];
        [xmlData appendString:@"<rep:Identifier/>"];
        [xmlData appendString:@"</rep:Service>"];
        [xmlData appendString:@"</rep:Product>"];
         
        if (1 == type) {
            [xmlData appendString:@"<rep:Characteristics>"];
            [xmlData appendString:@"<rep:Characteristic>"];
            [xmlData appendFormat:@"<rep:Name>%@</rep:Name>", topupAccountCharName];
            [xmlData appendFormat:@"<rep:Value>%@</rep:Value>", topupAccountCharValue];
            [xmlData appendString:@"</rep:Characteristic>"];
            [xmlData appendString:@"</rep:Characteristics>"];
        }
             
        [xmlData appendString:@"</rep:ReplenishmentOrderLineItem>"];
        [xmlData appendString:@"</rep:replenishBalanceRequest>"];
        [xmlData appendString:@"</soapenv:Body>"];
        [xmlData appendString:@"</soapenv:Envelope>"];
        
        body = xmlData;
        NSLog(@"Account::createBody:body=%@", body);
    }
    @catch (NSException *exception) {
        NSLog(@"Account::createBody:exception=%@", [exception description]);
    }
    
    return body;
}

- (int)queryChargeWithTransactionType:(int)transactionType andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mId forKey:@"resourceId"];
        [busiParams setObject:[NSNumber numberWithInt:transactionType] forKey:@"transactionType"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QueryProcessingFee";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"%s::%s:responseEntity: %@", __FILE__, __func__, responseEntity);
            
            double value = 0;
            @try {
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        NSDictionary *respMsg = [responseEntity objectForKey:@"respMsg"];
                        value = [[respMsg objectForKey:@"value"] doubleValue];
                        
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
                if (nil != delegate && [delegate respondsToSelector:@selector(queryChargeFinished:andInfo:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate queryChargeFinished:status andInfo:value];
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

@end
