//
//  QuickOrderItemView.h
//  EasyTT
//
//  Created by tiger on 14-1-16.
//  Copyright (c) 2013年 lvming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QuickOrderType) {
    QuickOrderTypeNegotiation,
    QuickOrderTypeRecharge,
};

@class ProductOffer;

@interface QuickOrderItemView : UIView

@property(nonatomic,readonly)UIButton *actionButton;
@property(nonatomic,readonly)UIButton *selectButton;
@property(nonatomic,retain)ProductOffer *productOffer;

- (void)layoutSubviewsByProductOffer:(ProductOffer *)product type:(QuickOrderType)orderType;

@end
