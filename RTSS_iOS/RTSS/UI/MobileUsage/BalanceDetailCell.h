//
//  BalanceDetailCell.h
//  RTSS
//
//  Created by tiger on 14-11-29.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobileUsageModel.h"

@interface BalanceDetailCell : UITableViewCell

@property(nonatomic, retain)MobileUsageModel * model;
@property(nonatomic, readonly)UILabel * retainLabel;

+(CGFloat)heightForTitle:(MobileUsageModel*)model;

@end
