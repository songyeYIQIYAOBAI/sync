//
//  MyServicesTableView.h
//  RTSS
//
//  Created by 宋野 on 14-11-14.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QuickOrderItemView.h"

@protocol MyServicesTableViewDelegate <NSObject>

- (void)myServicesTableViewDidSelectRowWithIndexPath:(NSIndexPath *)indexPath Tag:(NSInteger)indx;

@end

@interface MyServicesTableView : UIView
@property (nonatomic ,retain)NSMutableArray * sections;
@property (nonatomic ,retain)NSMutableArray * rows;
@property (nonatomic ,assign)id<MyServicesTableViewDelegate> delegate;

- (void)reloadData;

@end

@interface MyServicesTableViewCell : UITableViewCell
@property (nonatomic ,retain)QuickOrderItemView * quickItemView;

@end
