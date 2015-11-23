//
//  PayViewController.h
//  RTSS
//
//  Created by 蔡杰Alan on 14-12-5.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BasicViewController.h"

@protocol PaymentActionDelegate <NSObject>

@optional
- (void)paymentActionSucceed;

- (void)paymentActionFailed;

- (void)paymentActionBackWithPaymentStatus:(BOOL)succeed;

- (void)paymentActionBackWithPaymentStatus:(BOOL)succeed andParameters:(NSDictionary*)parameters;

@end

@interface PayViewController : BasicViewController
@property(nonatomic, copy) NSString *payUrlString;
@property(nonatomic, copy) NSString* payAction;
@property(nonatomic, copy) NSString* payFor;
@property(nonatomic, assign) id <PaymentActionDelegate> delegate;

+ (void)showPayResult:(NSDictionary*)payResult inController:(UIViewController*)controller delegate:(id)delegate;

@end
