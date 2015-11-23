//
//  PriceRuleItem.h
//  RTSS
//
//  Created by 刘艳峰 on 15/2/7.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceRuleItem : NSObject

@property (nonatomic, copy) NSString *mResourceId;
@property (nonatomic, assign) long long mMinValue;
@property (nonatomic, assign) long long mMaxValue;

@end
