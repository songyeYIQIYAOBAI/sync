//
//  MemberBudget.h
//  RTSS
//
//  Created by 刘艳峰 on 15/2/6.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberBudget : NSObject

@property (nonatomic, copy) NSString *mSubscriberId;
@property (nonatomic, assign) long long mBudget;
@property (nonatomic, assign) float mNotification;
@property (nonatomic, assign) BOOL mBarred;

@end
