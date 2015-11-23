//
//  HomeViewController.h
//  RTSS
//
//  Created by shengyp on 14/10/21.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "HomeBottleView.h"
#import "ITransferable.h"

typedef NS_ENUM(NSInteger, HomeAlertControllerTag){
    HomeAlertControllerTagGiftTimeOut,
    HomeAlertControllerTagGiftSuccess,
    HomeAlertControllerTagTransferInput,
    HomeAlertControllerTagReceiveGift,
    HomeAlertControllerTagReceiveGiftSuccess,
    HomeAlertControllerTagRefuseGift,
    HomeAlertControllerTagFriendsGift
};

typedef NS_ENUM(NSInteger, HomeTransferTransactionStatus) {
    HomeTransferTransactionStatusDefault,
    HomeTransferTransactionStatusLocationFinished,
    HomeTransferTransactionStatusLocationFailed,
    HomeTransferTransactionStatusLocationException,
    HomeTransferTransactionStatusFriendsGift,
    HomeTransferTransactionStatusFriendsGiftSuccessful,
    HomeTransferTransactionStatusFriendsGiftFailed,
    HomeTransferTransactionStatusFriendsGiftFinish,
    HomeTransferTransactionStatusGiftBegin,
    HomeTransferTransactionStatusGifting,
    HomeTransferTransactionStatusGiftSuccessful,
    HomeTransferTransactionStatusGiftFailed,
    HomeTransferTransactionStatusGiftFinish,
    HomeTransferTransactionStatusReceiveBegin,
    HomeTransferTransactionStatusReceiving,
    HomeTransferTransactionStatusReceiveSuccessful,
    HomeTransferTransactionStatusReceiveFailed,
    HomeTransferTransactionStatusReceiveFinished,
    HomeTransferTransactionStatusException,
    HomeTransferTransactionStatusNetworkError,
    HomeTransferTransactionStatusSyncAccountFailed,
    HomeTransferTransactionStatusTimeOut
};

typedef NS_ENUM(NSInteger, HomeBottlePouringOutOrInStatus) {
    HomeBottlePouringInitial,
    HomeBottlePouringOutWaiting,
    HomeBottlePouringOutProceed,
    HomeBottlePouringOutFinish,
    
    HomeBottlePouringInWaiting,
    HomeBottlePouringInProceed,
    HomeBottlePouringInFinish
};

@class Account;
@class User;
@class ERadarItemView;

@interface HomeModel : NSObject

@property(nonatomic, readonly) NSInteger                    currentTransferIndex;
@property(nonatomic, retain) NSArray*                       currentTransferArray;
@property(nonatomic, retain) id<ITransferable>              currentTransfer;
@property(nonatomic, assign) long long                      currentTransferValue;

@property(nonatomic, retain) User*                          friendsGiftUser;

@property(nonatomic, retain) ERadarItemView*                singleSelectedItemView;
@property(nonatomic, retain) ERadarItemView*                defaultSelectedItemView;

@property(nonatomic, assign) HomeTransferTransactionStatus  currentTransferTransactionStatus;

- (void)clear;

- (id<ITransferable>)getTransferWithIndex:(NSInteger)index;

@end

@interface HomeViewController : BasicViewController

@end
