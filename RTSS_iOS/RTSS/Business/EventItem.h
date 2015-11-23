//
//  EventItem.h
//  RTSS
//
//  Created by Lyu Ming on 11/20/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <time.h>

typedef NS_ENUM(NSInteger, EventType) {
    EventTypeTopup=1,
    EventTypeRecharge,
    EventTypeBalanceTransferOut,
    EventTypeBalanceTransferIn
};

@interface EventItem : NSObject

@property (nonatomic, assign) int               mEventId;
@property (nonatomic, assign) int               mType;
@property (nonatomic, retain) NSString*         mPeerPhoneNumber;
@property (nonatomic, retain) NSString*         mDescription;
@property (nonatomic, assign) long              mTimeStamp;
@property (nonatomic, retain) NSDictionary*     mParameters;

@end
