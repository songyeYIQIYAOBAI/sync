//
//  ServiceRequestCell.h
//  RTSS
//
//  Created by 蔡杰Alan on 15-1-27.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ServiceRequestCell;
@protocol ServiceRequestCellDelegate <NSObject>

-(void)tapActionWithserviceRequest:(ServiceRequestCell*)cell;

@end

@interface ServiceRequestCell : UITableViewCell

@property(nonatomic,retain)UIImageView *bgImageView;

@property(nonatomic,retain)UILabel  *dateLabel;
@property(nonatomic,assign)UIButton *showButton;
@property(nonatomic,retain)UILabel  *idLabel;
@property(nonatomic,retain)UILabel  *titleLabel;
@property(nonatomic,retain)UILabel  *statusLabel;

@property(assign,nonatomic)id<ServiceRequestCellDelegate>delegate;
+(CGFloat)serviceRequestCellFixedHeight;

-(void)setCellBlackColor:(UIColor*)color;

-(void)updateData:(NSDictionary*)dic;
-(void)addLastLine;
-(void)removeLastLine;
@end
