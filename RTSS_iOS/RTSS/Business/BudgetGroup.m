//
//  BudgetGroup.m
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "BudgetGroup.h"
#import "Subscriber.h"
#import "MappClient.h"
#import "Session.h"
#import "define.h"

@interface BudgetGroup ()

- (int)updateProperty:(NSString*)property value:(NSString*)value delegate:(id<MappActorDelegate>)delegate;

@end

@implementation BudgetGroup

@synthesize mGroupId;
@synthesize mGroupName;
@synthesize mType;
@synthesize mIcon;
@synthesize mGroupBudget;
@synthesize mUnit;
@synthesize mTargetAccountId;
@synthesize mTargetProductId;
@synthesize mTargetResourceId;
@synthesize mTargetName;
@synthesize mOwnerId;
@synthesize mMembers;
@synthesize mMemberBudgets;

- (void)dealloc {
    [mGroupId release];
    
    [mGroupName release];
    
    [mIcon release];
    
    [mTargetAccountId release];
    
    [mTargetProductId release];
    
    [mTargetResourceId release];
    
    [mTargetName release];
    
    [mOwnerId release];
    
    [mMembers release];
    
    [mMemberBudgets release];
    
    [super dealloc];
}

- (instancetype)init {
    self = [super init];
    
    mMembers = [[NSMutableArray alloc] initWithCapacity:0];
    mMemberBudgets = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    return self;
}

- (void)addMember:(Subscriber *)member {
    if (member == nil) {
        NSLog(@"BudgetGroup::addMember:member is nil");
        return;
    }
    
    BOOL hasTheMember = NO;
    for (Subscriber *obj in mMembers) {
        if ([obj.mId isEqualToString:member.mId] == YES) {
            hasTheMember = YES;
        }
    }
    
    if (hasTheMember == NO) {
        [mMembers addObject:member];
        
        {
//            MemberBudget *memberBudget = [[MemberBudget alloc] init];
//            memberBudget.mSubscriberId = member.mSubscriberId;
//            memberBudget.mBudget = 0;
//            memberBudget.mBarred = NO;
//            memberBudget.mNotification = 0;
//            [self.mMemberBudgets setObject:memberBudget forKey:memberBudget.mSubscriberId];
//            [memberBudget release];
        }
    }
}
- (void)removeMember:(Subscriber *)member {
    if (member == nil) {
        NSLog(@"BudgetGroup::removeMember:member is nil");
        return;
    }
    
    for (Subscriber *obj in mMembers) {
        if ([obj.mId isEqualToString:member.mId] == YES) {
            [mMembers removeObject:member];
            break;
        }
    }
}
- (void)queryUsage {
}

- (void)updateIcon:(NSString*)icon {
    self.mIcon = icon;
}

- (int)updatePortrait:(NSData *)portrait delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSString* name = [NSString stringWithFormat:@"portrait_%@_%016lld.png", self.mGroupId, (long long)time(NULL)];
        [self upload:name mimeType:@"image/png" data:portrait callback:^(int execStatus, NSString* uploadId) {
            int status = execStatus;
            
            @try {
                if (0 == status) {
                    status = [self updateProperty:@"pro.user.icon" value:uploadId delegate:delegate];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"User::updateProperty:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            
            if (0 != status) {
                if (nil != delegate && [delegate respondsToSelector:@selector(updatePropertyFinished:propertyUrl:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate updatePropertyFinished:status propertyUrl:nil];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"User::updateProperty:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)updateProperty:(NSString*)property value:(NSString*)value delegate:(id<MappActorDelegate>)delegate {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mGroupId forKey:@"userId"];
        [busiParams setObject:property forKey:@"name"];
        [busiParams setObject:value forKey:@"value"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"UpdateUserPro";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            NSString* propertyUrl = nil;
            @try {
                
                if (0 == status) {
                    if (nil != responseEntity) {
                        int code = [[responseEntity objectForKey:@"code"] intValue];
                        if (0 == code) {
                            NSDictionary* respMsg = [responseEntity objectForKey:@"respMsg"];
                            propertyUrl = [respMsg objectForKey:@"iconUrl"];
                            NSLog(@"User::updateProperty:propertyUrl=%@", propertyUrl);
                            
                            self.mIcon = propertyUrl;
                            
                            [[Session sharedSession] save];
                        } else {
                            NSDictionary* message = [responseEntity objectForKey:@"message"];
                            NSLog(@"User::updateProperty:message=%@", message);
                            
                            status = code;
                        }
                    } else {
                        status = MappActorFinishStatusNetwork;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"User::updateProperty:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                if (nil != delegate && [delegate respondsToSelector:@selector(updatePropertyFinished:propertyUrl:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [delegate updatePropertyFinished:status propertyUrl:propertyUrl];
                    });
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"User::updateProperty:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

@end
