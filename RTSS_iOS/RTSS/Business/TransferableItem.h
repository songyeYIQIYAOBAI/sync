//
//  TransferableItem.h
//  librtss
//
//  Created by 刘艳峰 on 4/16/15.
//  Copyright (c) 2015 Ming Lyu. All rights reserved.
//

#import "ITransferable.h"
@class Subscriber;
#import "ProductResource.h"

@interface TransferableItem:NSObject <ITransferable>

@property (nonatomic, retain) NSString *mItemId;
@property (nonatomic, retain) NSString *mItemName;
@property (nonatomic, retain) NSString *mSubscriberId;
@property (nonatomic, assign) long long mTotalAmount;
@property (nonatomic, assign) long long mUsedAmount;
@property (nonatomic, assign) long long mRemainAmount;
@property (nonatomic, assign) MeasureUnit mUnit;

@property (nonatomic, retain) NSString *mSubscriberType;
@property (nonatomic, retain) NSString *mSubscriberName;
@property (nonatomic, retain) NSString *mExtraInfo;

@property (nonatomic, assign) int mTypeCode;

@property (nonatomic, retain) NSObject *mOriginalItem;

@end
