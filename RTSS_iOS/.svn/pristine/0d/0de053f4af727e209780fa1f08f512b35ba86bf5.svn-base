//
//  QuickOrderCell.h
//  RTSS
//
//  Created by 加富董 on 14/11/14.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickOrderItemView.h"

@class ProductOffer;
@class QuickOrderCell;

@protocol  QuickOrderCellDelegate <NSObject>

@optional
- (void)quickOrderCell:(QuickOrderCell *)orderCell actionButtonClickedAtIndexPath:(NSIndexPath *)indexPath;
- (void)quickOrderCell:(QuickOrderCell *)orderCell didSelectCellAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface QuickOrderCell : UITableViewCell

@property (nonatomic,retain)ProductOffer *productOffer;
@property (nonatomic,assign)id <QuickOrderCellDelegate> delegate;
@property (nonatomic, retain) NSIndexPath *cellIndexPath;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)availableSize;

- (void)layoutCellSubviewsByResourceData:(ProductOffer *)offerData type:(QuickOrderType)orderType cellIndex:(NSIndexPath *)index;


@end
