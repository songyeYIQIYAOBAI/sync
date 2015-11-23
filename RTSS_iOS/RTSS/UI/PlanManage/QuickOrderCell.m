//
//  QuickOrderCell.m
//  RTSS
//
//  Created by 加富董 on 14/11/14.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "QuickOrderCell.h"
#import "PlanManageModel.h"
#import "ProductResource.h"
#import "RTSSAppStyle.h"
#import "ProductOffer.h"

#define ORDER_VIEW_BORDER_WIDHT 1.f
#define ORDER_VIEW_CORNER_RADIUS 6.f

@interface QuickOrderCell () {
    QuickOrderItemView *orderView;
}

@end


@implementation QuickOrderCell

@synthesize productOffer;
@synthesize delegate;
@synthesize cellIndexPath;

#pragma mark init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)availableSize {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViewsByAvailableSize:availableSize];
    }
    return self;
}

#pragma mark init views
- (void)initViewsByAvailableSize:(CGSize)size {
    orderView = [[QuickOrderItemView alloc] initWithFrame:CGRectMake(0.f, 0.f, size.width, size.height)];
    orderView.layer.borderColor = [RTSSAppStyle currentAppStyle].textFieldBorderColor.CGColor;
    orderView.layer.borderWidth = ORDER_VIEW_BORDER_WIDHT;
    orderView.layer.cornerRadius = ORDER_VIEW_CORNER_RADIUS;
    orderView.layer.masksToBounds = YES;
    [orderView.actionButton addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [orderView.selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:orderView];
}

#pragma mark layout by data 
- (void)layoutCellSubviewsByResourceData:(ProductOffer *)offerData type:(QuickOrderType)orderType cellIndex:(NSIndexPath *)index {
    self.cellIndexPath = index;
    [orderView layoutSubviewsByProductOffer:offerData type:orderType];
}

#pragma mark button clicked method
- (void)actionButtonClicked:(UIButton *)button {
    if (delegate && [delegate conformsToProtocol:@protocol(QuickOrderCellDelegate)] && [delegate respondsToSelector:@selector(quickOrderCell:actionButtonClickedAtIndexPath:)]) {
        {
            [delegate quickOrderCell:self actionButtonClickedAtIndexPath:cellIndexPath];
        }
    }
}

- (void)selectButtonClicked:(UIButton *)button {
    if (delegate && [delegate conformsToProtocol:@protocol(QuickOrderCellDelegate)] && [delegate respondsToSelector:@selector(quickOrderCell:didSelectCellAtIndexPath:)]) {
        [delegate quickOrderCell:self didSelectCellAtIndexPath:cellIndexPath];
    }
}

#pragma mark selected
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark dealloc
- (void)dealloc {
    [cellIndexPath release];
    [productOffer release];
    [orderView release];
    [super dealloc];
}

@end
