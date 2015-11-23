//
//  PriceNegotiationViewController.h
//  RTSS
//
//  Created by 蔡杰Alan on 15-2-3.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BasicViewController.h"
#import "TransationBaseViewController.h"
#import "CommonUtils.h"

@interface PriceNegotiationViewController : TransationBaseViewController

//初始化本地数据
-(void)loadProductResourceData:(NSArray*)productResources;

@property(nonatomic,retain)PriceRule *priceRule;

@property(nonatomic,assign)long long currentProductPrice;
@end
