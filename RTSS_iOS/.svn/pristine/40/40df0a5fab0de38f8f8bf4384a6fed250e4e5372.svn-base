//
//  OrderPreviewCell.h
//  RTSS
//
//  Created by 加富董 on 14/11/28.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderInfoModel;

#define ORDER_PREVIEW_CELL_DEFAULT_HEIGHT 50.0

@interface OrderPreviewCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier defaultAvailableSize:(CGSize)size;

- (void)layoutSubviewsByOrderInfoData:(OrderInfoModel *)orderInfo showSeperateLine:(BOOL)show;

+ (CGFloat)calculateCellHeightByCellData:(OrderInfoModel *)dataModel defaultAvailableSize:(CGSize)defaultSize;

@end
