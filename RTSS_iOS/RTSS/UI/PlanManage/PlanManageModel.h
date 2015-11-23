//
//  PlanManageHeadModel.h
//  RTSS
//
//  Created by tiger on 14-11-3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanManageHeadModel : NSObject

@property(nonatomic, retain)UIImage * headImage;
@property(nonatomic, retain)NSString * name;
@property(nonatomic, retain)NSString * phone;
@property(nonatomic, retain)NSString * balance;
@property(nonatomic, retain)NSString * tariff;
@property(nonatomic, retain)NSString * money;
@property(nonatomic, retain)NSMutableArray * serviceArray;

@end



