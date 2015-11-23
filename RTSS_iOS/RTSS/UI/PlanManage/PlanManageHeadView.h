//
//  PlanManageHeadView.h
//  RTSS
//
//  Created by tiger on 14-11-3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlanManageDropDownView.h"
#import "PlanManageModel.h"

@interface PlanManageHeadView : UIView <PlanManageDropDownViewDelegate>

@property(nonatomic, assign)id delegate;

-(void)setHeadInfoModel:(PlanManageHeadModel *)headInfo;

@end
