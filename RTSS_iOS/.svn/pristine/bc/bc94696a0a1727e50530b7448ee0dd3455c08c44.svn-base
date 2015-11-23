//
//  TransferTransaction.h
//  RTSS
//
//  Created by Lyu Ming on 11/15/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MappActor.h"
#import "User.h"

typedef NS_ENUM(NSInteger, TransferUserStatus) {
    UserStatusNormal=0,
    UserStatusPeerSelected,
    UserStatusPeerAccepted,
    UserStatusPeerRejected,
    UserStatusTransferBegin,
    UserStatusTransferSuccessful,
    UserStatusTransferFailed,
    UserStatusTransferFinish
};

@interface TransferTransaction : MappActor

@property (nonatomic, retain) User* mMe;
@property (nonatomic, retain) User* mPeer;
@property (nonatomic, retain) NSDictionary* mPeerInfo;

+ (TransferTransaction*)sharedTransferTransaction;
+ (void)destroyTransferTransaction;

- (int)create:(User *)user longitude:(double)longitude latitude:(double)latitude andOptions:(NSDictionary *)options;
- (int)join:(User *)user longitude:(double)longitude latitude:(double)latitude andOptions:(NSDictionary *)options;

- (int)queryPeerInfo;

- (NSArray*)getUsers;

- (int)select:(User *)user;
- (int)update:(User *)user transactionStatus:(int)transactionStatus;

- (void)close;

@end
