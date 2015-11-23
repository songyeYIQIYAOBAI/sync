//
//  ProductResource.m
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "ProductResource.h"
#import "MappClient.h"
#import "define.h"

#define __KEY_FREERESOURCE_PRODUCTID__ @"FREERESOURCE_PRODUCTID"
#define __KEY_FREERESOURCE_RESOURCEID__ @"FREERESOURCE_RESOURCEID"
#define __KEY_FREERESOURCE_NAME__ @"FREERESOURCE_NAME"
#define __KEY_FREERESOURCE_TOTAL__ @"FREERESOURCE_TOTAL"
#define __KEY_FREERESOURCE_REMAIN__ @"FREERESOURCE_REMAIN"
#define __KEY_FREERESOURCE_USED__ @"FREERESOURCE_USED"
#define __KEY_FREERESOURCE_UNIT__ @"FREERESOURCE_UNIT"

@implementation ProductResource

@synthesize mOfferId;
@synthesize mProductId;
@synthesize mResourceId;
@synthesize mName;
@synthesize mTotal;
@synthesize mUsed;
@synthesize mRemain;
@synthesize mExpiryDate;
@synthesize mUnit;

@synthesize mTypeCode;

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (void)dealloc{
    [mOfferId release];
    [mProductId release];
    [mResourceId release];
    [mName release];
    [mExpiryDate release];
    
    [super dealloc];
}

- (void)createFromJsonObject:(NSObject *)jsonObject {
    long long originalAmount = [[(NSDictionary*)jsonObject objectForKey:@"originalAmount"] longLongValue];
    long long amount = [[(NSDictionary*)jsonObject objectForKey:@"amount"] longLongValue];
    NSString* expiryDate = [(NSDictionary*)jsonObject objectForKey:@"expiryDate"];
    int unit = [[(NSDictionary*)jsonObject objectForKey:@"measureId"] intValue];
    NSLog(@"ProductResource::createFromJsonObject:originalAmount=%lld, amount=%lld, expiryDate=%@, unit=%d", originalAmount, amount, expiryDate, unit);
    
    self.mTotal = originalAmount;
    self.mRemain = amount;
    self.mExpiryDate = expiryDate;
    self.mUnit = unit;
}

- (int)queryChargeWithTransactionType:(int)transactionType andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mResourceId forKey:@"resourceId"];
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

- (int)transformWithSubscriberId:(NSString *)orignalId To:(NSString *)targetId withOrignalAmount:(long long)orignalAmount withTargetAmount:(long long)targetAmount andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:orignalId forKey:@"donorId"];
        [busiParams setObject:orignalId forKey:@"recipientId"];
        [busiParams setObject:[NSNumber numberWithInt:3] forKey:@"transactionType"];
        
        NSMutableDictionary *donorResInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [donorResInfo setObject:self.mResourceId forKey:@"resId"];
        [donorResInfo setObject:[NSNumber numberWithLongLong:orignalAmount] forKey:@"amount"];
        [donorResInfo setObject:[NSNumber numberWithInt:self.mUnit] forKey:@"measureId"];
        [busiParams setObject:donorResInfo forKey:@"donorResInfo"];
        
        NSMutableDictionary *recipientResInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [recipientResInfo setObject:targetId forKey:@"resId"];
        [recipientResInfo setObject:[NSNumber numberWithLongLong:targetAmount] forKey:@"amount"];
        
        for (id obj in [Session sharedSession].mTransferables) {
            if ([obj isKindOfClass:[ProductResource class]]) {
                ProductResource *targetResource = (ProductResource *)obj;
                if ([targetResource.mResourceId isEqualToString:targetId]) {
                    [recipientResInfo setObject:[NSNumber numberWithInt:targetResource.mUnit] forKey:@"measureId"];
                }
            }
        }
        
        [busiParams setObject:recipientResInfo forKey:@"recipientResInfo"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"TransferTransfrom";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSLog(@"ProductResource::transformTo:responseEntity: %@", responseEntity);
            NSDictionary *respMsg = nil;
            @try {
                if (0 == status) {
                    int code = [[requestEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        respMsg = [requestEntity objectForKey:@"respMsg"];
                        
                    } else {
                        NSDictionary* message = [requestEntity objectForKey:@"message"];
                        NSLog(@"ProductResource::transformTo:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"ProductResource::transformTo:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(transferBalanceFinished:result:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate transferBalanceFinished:status result:respMsg];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"ProductResource::transformTo:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)transferFrom:(NSString *)from andTo:(NSString *)to andAmount:(long long)amount andDelegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:from forKey:@"donorId"];
        [busiParams setObject:to forKey:@"recipientId"];
        [busiParams setObject:[NSNumber numberWithInt:2] forKey:@"transactionType"];
        
        NSMutableDictionary *donorResInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [donorResInfo setObject:self.mResourceId forKey:@"resId"];
        [donorResInfo setObject:[NSNumber numberWithLongLong:amount] forKey:@"amount"];
        [donorResInfo setObject:[NSNumber numberWithInt:self.mUnit] forKey:@"measureId"];
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
            NSLog(@"ProductResource::transferFrom:responseEntity: %@", responseEntity);
            NSDictionary *respMsg = nil;
            @try {
                if (0 == status) {
                    int code = [[requestEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        respMsg = [requestEntity objectForKey:@"respMsg"];
                        
                    } else {
                        NSDictionary* message = [requestEntity objectForKey:@"message"];
                        NSLog(@"ProductResource::transferFrom:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"ProductResource::transferFrom:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(transferBalanceFinished:result:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate transferBalanceFinished:status result:respMsg];
                    });
                }
            }
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"ProductResource::transferFrom:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

@end
