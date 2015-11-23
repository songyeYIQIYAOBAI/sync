//
//  MyUsageTableViewCell.h
//  RTSS
//
//  Created by 蔡杰Alan on 14-11-28.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsageModel.h"

@interface MyUsageTableViewCell : UITableViewCell

//动态生成count数量的label
-(void)dynamicInstallLabelWithCount:(NSInteger)count AllEmpty:(BOOL)empty;

-(void)showTitle:(NSArray*)typeList;

-(void)showUserDayWithDictionay:(NSDictionary*)datDictionary;

-(void)setBackgroundViewColor:(UIColor*)color;

@end
