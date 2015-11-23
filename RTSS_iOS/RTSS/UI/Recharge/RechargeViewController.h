//
//  RechargeViewController.h
//  RTSS
//
//  Created by 加富董 on 14/11/26.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BasicViewController.h"

typedef NS_ENUM(NSInteger, ContentType) {
    ContentTypeRecharge,
    ContentTypeMyPlan,
};

@interface RechargeViewController : BasicViewController

@property (nonatomic, assign) ContentType contentType;

@end
