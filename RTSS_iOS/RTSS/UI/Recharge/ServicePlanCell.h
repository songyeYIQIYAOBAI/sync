//
//  ServicePlanCell.h
//  RTSS
//
//  Created by 加富董 on 14/11/26.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeViewController.h"

#define SERVICE_PLAN_CELL_HEIGHT 55.0

@class ServicePlanCell;

@protocol  ServicePlanCellDelegate <NSObject>

- (void)servicePlanCell:(ServicePlanCell *)cell didClickedPurchaseButtonAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;

@end

@interface ServicePlanCell : UITableViewCell

@property(nonatomic,assign)id<ServicePlanCellDelegate>delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)size delegate:(id<ServicePlanCellDelegate>)del;

- (void)layoutSubviewsByData:(id)planData contentType:(ContentType)contentType atIndexPath:(NSIndexPath *)indexPath belongToTableView:(UITableView *)tableView showSeperateLine:(BOOL)show;

+ (CGFloat)getPlanCellHeightByData:(id)cellData contentType:(ContentType)contentType availableWidth:(CGFloat)totalWidth;

@end
