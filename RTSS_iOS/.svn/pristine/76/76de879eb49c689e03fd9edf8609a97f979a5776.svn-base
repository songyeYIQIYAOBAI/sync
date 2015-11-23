//
//  TransferTransaction.m
//  RTSS
//
//  Created by Lyu Ming on 11/15/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "TransferTransaction.h"
#import "MappClient.h"
#import "Session.h"
#import "RTSSNotificationCenter.h"
#import "define.h"

#define __TRANSACTION_IDLE_TIME__ 30

static TransferTransaction* _instance = nil;

@interface TransferTransaction () {
    double _longitude;
    double _latitude;
    
    BOOL _active;
    BOOL _keepWorking;
    int _mode;
    
    long _lastActive;
    
    int _lastStatus;
    
    NSMutableDictionary* _userRegistry;
    NSMutableArray* _users;
}

- (void)monitorTransaction;
- (int)queryUser;
- (int)queryStatus:(NSString*)subscriberId;

@end

@implementation TransferTransaction

@synthesize mMe;
@synthesize mPeer;
@synthesize mPeerInfo;

+ (TransferTransaction*)sharedTransferTransaction {
    @synchronized (self) {
        if (nil == _instance) {
            _instance = [[TransferTransaction alloc] init];
        }
    }
    
    return _instance;
}

+ (void)destroyTransferTransaction {
    @synchronized (self) {
        [_instance release];
        _instance = nil;
    }
}

- (id)init {
    if (self = [super init]) {
        _active = NO;
        _keepWorking = NO;
        _mode = 0;
        
        _lastActive = 0;
        
        _userRegistry = [[NSMutableDictionary alloc] initWithCapacity:0];
        _users = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)dealloc {
    [mMe release];
    [mPeer release];
    [mPeerInfo release];
    
    [_userRegistry release];
    [_users release];
    
    [super dealloc];
}

- (int)create:(User *)user longitude:(double)longitude latitude:(double)latitude andOptions:(NSDictionary *)options {
    int status = MappActorFinishStatusOK;
    
    @try {
        
        if (YES == _active) {
            return MappActorFinishStatusTransactionExist;
        }
        
        [_userRegistry removeAllObjects];
        [_users removeAllObjects];
        
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:user.mId forKey:@"userId"];
        [busiParams setObject:[NSNumber numberWithInt:0] forKey:@"type"];
        
        NSMutableDictionary* markInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [markInfo setObject:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
        [markInfo setObject:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
        [busiParams setObject:markInfo forKey:@"markInfo"];
        
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [userInfo setObject:user.mId forKey:@"id"];
        [userInfo setObject:user.mName forKey:@"name"];
        [userInfo setObject:user.mPortrait forKey:@"portrait"];
        [busiParams setObject:userInfo forKey:@"userInfo"];
        
        [busiParams setObject:options forKey:@"optionInfo"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"JoinGroupSession";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            @try {
                
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (nil != responseEntity && 0 == code) {
                        self.mMe = user;
                        
                        _longitude = longitude;
                        _latitude = latitude;
                        
                        _mode = 0;
                        _active = YES;
                        _keepWorking = YES;
                        [self monitorTransaction];
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"TransferTransaction::create:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"TransferTransaction::create:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [[RTSSNotificationCenter standardRTSSNotificationCenter] postNotificationWithType:RTSSNotificationTypeTransactionCreated object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:status] forKey:@"status"]];
                });
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"TransferTransaction::create:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)join:(User *)user longitude:(double)longitude latitude:(double)latitude andOptions:(NSDictionary *)options {
    int status = MappActorFinishStatusOK;
    
    @try {
        
        if (YES == _active) {
            return MappActorFinishStatusTransactionExist;
        }
        
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:user.mId forKey:@"userId"];
        [busiParams setObject:[NSNumber numberWithInt:1] forKey:@"type"];
        
        NSMutableDictionary* markInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [markInfo setObject:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
        [markInfo setObject:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
        [busiParams setObject:markInfo forKey:@"markInfo"];
        
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [userInfo setObject:user.mId forKey:@"id"];
        [userInfo setObject:user.mName forKey:@"name"];
        [userInfo setObject:user.mPortrait forKey:@"portrait"];
        [busiParams setObject:userInfo forKey:@"userInfo"];
        
        [busiParams setObject:options forKey:@"optionInfo"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"JoinGroupSession";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            @try {
                
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (nil != responseEntity && 0 == code) {
                        
                        self.mMe = user;
                        
                        _mode = 1;
                        _active = YES;
                        _keepWorking = YES;
                        [self monitorTransaction];
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"TransferTransaction::join:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"TransferTransaction::join:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [[RTSSNotificationCenter standardRTSSNotificationCenter] postNotificationWithType:RTSSNotificationTypeTransactionJoined object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:status] forKey:@"status"]];
                });
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"TransferTransaction::join:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)queryPeerInfo {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        
        if (0 == _mode) {
            [busiParams setObject:self.mPeer.mId forKey:@"userId"];
            [busiParams setObject:[NSNumber numberWithInt:0] forKey:@"type"];
        } else {
            [busiParams setObject:self.mMe.mId forKey:@"userId"];
            [busiParams setObject:[NSNumber numberWithInt:1] forKey:@"type"];
        }
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QuerySessionInfo";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            @try {
                
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (nil != responseEntity && 0 == code) {
                        NSDictionary* respMsg = [responseEntity objectForKey:@"respMsg"];
                        
                        NSDictionary* userInfo = [respMsg objectForKey:@"userInfo"];
                        NSString* userId = [userInfo objectForKey:@"id"];
                        NSString* userName = [userInfo objectForKey:@"name"];
                        NSString* portrait = [userInfo objectForKey:@"portrait"];
                        NSLog(@"TransferTransaction::queryPeerInfo:id=%@, name=%@, portrait=%@", userId, userName, portrait);
                        
                        User* user = [[User alloc] init];
                        user.mId = userId;
                        user.mName = userName;
                        user.mPortrait = portrait;
                        self.mPeer = user;
                        [user release];
                        
                        NSDictionary* options = [respMsg objectForKey:@"optionInfo"];
                        NSLog(@"TransferTransaction::queryPeerInfo:options=%@", [options description]);
                        self.mPeerInfo = options;
                        
                        _lastActive = time(NULL);
                        
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            [[RTSSNotificationCenter standardRTSSNotificationCenter] postNotificationWithType:RTSSNotificationTypePeerInfoReady object:nil userInfo:nil];
                        });
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"TransferTransaction:queryPeerInfo:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"TransferTransaction:queryPeerInfo:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"TransferTransaction:queryPeerInfo:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (NSArray*)getUsers {
    NSMutableArray* subscribers = nil;
    
    @synchronized (_users) {
        subscribers = [NSMutableArray arrayWithArray:_users];
        [_users removeAllObjects];
    }
    
    return subscribers;
}

- (int)queryUser {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        
        NSMutableDictionary* markInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [markInfo setObject:[NSNumber numberWithDouble:_longitude] forKey:@"longitude"];
        [markInfo setObject:[NSNumber numberWithDouble:_latitude] forKey:@"latitude"];
        [busiParams setObject:markInfo forKey:@"markInfo"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QuerySessionUsers";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            @try {
                
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (nil != responseEntity && 0 == code) {
                        NSDictionary* respMsg = [responseEntity objectForKey:@"respMsg"];
                        
                        @synchronized (_users) {
                            NSArray* userList = [respMsg objectForKey:@"userInfoList"];
                            for (NSDictionary* userItem in userList) {
                                
                                NSDictionary* userInfo = [userItem objectForKey:@"userInfo"];
                                NSString* userId = [userInfo objectForKey:@"id"];
                                NSString* userName = [userInfo objectForKey:@"name"];
                                NSString* portrait = [userInfo objectForKey:@"portrait"];
                                NSLog(@"TransferTransaction::queryUser:id=%@, name=%@, portrait=%@", userId, userName, portrait);
                                
                                if (nil == [_userRegistry objectForKey:userId]) {
                                    User* user = [[User alloc] init];
                                    user.mId = userId;
                                    user.mName = userName;
                                    user.mPortrait = portrait;
                                    
                                    [_userRegistry setObject:user forKey:userId];
                                    [_users addObject:user];
                                    [user release];
                                }
                            }
                            
                            if (0 < [_users count]) {
                                _lastActive = time(NULL);
                                
                                NSLog(@"TransferTransaction::queryUser:notify new users=%@", [_users description]);
                                dispatch_async(dispatch_get_main_queue(), ^ {
                                    [[RTSSNotificationCenter standardRTSSNotificationCenter] postNotificationWithType:RTSSNotificationTypeUserJoined object:nil userInfo:nil];
                                });
                            }
                        }
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"TransferTransaction:queryUser:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"TransferTransaction:queryUser:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"TransferTransaction:queryUser:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)queryStatus:(NSString *)userId {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:userId forKey:@"userId"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"QuerySessionStatus";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            @try {
                
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (nil != responseEntity && 0 == code) {
                        NSDictionary* respMsg = [responseEntity objectForKey:@"respMsg"];
                        
                        int transactionStatus = [[respMsg objectForKey:@"status"] intValue];
                        NSLog(@"TransferTransaction::queryStatus:transactionStatus=%d", transactionStatus);
                        
                        if (_lastStatus != transactionStatus) {
                            _lastStatus = transactionStatus;
                            
                            _lastActive = time(NULL);
                            
                            NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
                            [userInfo setObject:[NSNumber numberWithInt:transactionStatus] forKey:@"transactionStatus"];
                            
                            if ((UserStatusPeerAccepted == transactionStatus || UserStatusPeerRejected == transactionStatus) && 0 == _mode) {
                                
                                dispatch_async(dispatch_get_main_queue(), ^ {
                                    [[RTSSNotificationCenter standardRTSSNotificationCenter]
                                     postNotificationWithType:RTSSNotificationTypePeerStatusUpdated object:nil
                                     userInfo:userInfo];
                                });
                                
                            } else if (UserStatusPeerSelected == transactionStatus && 1 == _mode) {
                                
                                dispatch_async(dispatch_get_main_queue(), ^ {
                                    [[RTSSNotificationCenter standardRTSSNotificationCenter]
                                     postNotificationWithType:RTSSNotificationTypeMyStatusUpdated object:nil
                                     userInfo:userInfo];
                                });
                                
                            } else if ((UserStatusTransferSuccessful == transactionStatus || UserStatusTransferFailed == transactionStatus) && 1 == _mode) {
                                
                                dispatch_async(dispatch_get_main_queue(), ^ {
                                    [[RTSSNotificationCenter standardRTSSNotificationCenter]
                                     postNotificationWithType:RTSSNotificationTypeMyStatusUpdated object:nil
                                     userInfo:userInfo];
                                });
                                
                            }
                        }
                        
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"TransferTransaction::queryStatus:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"TransferTransaction::queryStatus:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"TransferTransaction::queryStatus:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (int)select:(User *)user {
    int status = MappActorFinishStatusOK;
    
    [self update:user transactionStatus:UserStatusPeerSelected];
    
    return status;
}

- (int)update:(User *)user transactionStatus:(int)transactionStatus {
    int status = MappActorFinishStatusOK;
    
    @try {
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:self.mMe.mId forKey:@"userId"];
        [busiParams setObject:user.mId forKey:@"targetUserId"];
        [busiParams setObject:[NSNumber numberWithInt:transactionStatus] forKey:@"status"];
        
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSString* busiCode = @"UpdateSessionStatus";
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            
            @try {
                
                if (0 == status) {
                    int code = [[responseEntity objectForKey:@"code"] intValue];
                    if (0 == code) {
                        if (0 == _mode && UserStatusPeerSelected == transactionStatus) {
                            self.mPeer = user;
                        }
                    } else {
                        NSDictionary* message = [responseEntity objectForKey:@"message"];
                        NSLog(@"TransferTransaction::update:message=%@", message);
                        
                        status = code;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"TransferTransaction::update:exception=%@", [exception description]);
                status = MappActorFinishStatusInternalError;
            }
            @finally {
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [[RTSSNotificationCenter standardRTSSNotificationCenter] postNotificationWithType:RTSSNotificationTypeUserStatusUpdated object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:status] forKey:@"status"]];
                });
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"TransferTransaction::update:exception=%@", [exception description]);
        status = MappActorFinishStatusInternalError;
    }
    
    return status;
}

- (void)close {
    if (YES == _active) {
        if (1 == _mode) {
            [self update:mMe transactionStatus:UserStatusTransferFinish];
        }
        
        _keepWorking = NO;
        _active = NO;
        [_userRegistry removeAllObjects];
        
        [mMe release];
        mMe = nil;
        
        [mPeer release];
        mPeer = nil;
        
        NSLog(@"TransferTransaction::close");
    }
}

- (void)monitorTransaction {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        @try {
            
            _lastActive = time(NULL);
            
            while (YES == _keepWorking) {
                
                if (0 == _mode) {
                    [self queryUser];
                    
                    if (nil != mPeer) {
                        [self queryStatus:mPeer.mId];
                    }
                } else {
                    [self queryStatus:mMe.mId];
                }
                
                if (time(NULL) - _lastActive > __TRANSACTION_IDLE_TIME__) {
                    _lastActive = time(NULL);
                    
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [[RTSSNotificationCenter standardRTSSNotificationCenter] postNotificationWithType:RTSSNotificationTypeTransactionIdle object:nil userInfo:nil];
                    });
                    
                    NSLog(@"TransferTransaction::run:*********IDLE********");
                }
                
                sleep(1);
            }
            
            _active = NO;
        }
        @catch (NSException *exception) {
            NSLog(@"TransferTransaction::monitorTransaction:exception=%@", [exception description]);
        }
    });
}

@end
