//
//  TransferHistoryCell.h
//  EasyTT
//
//  Created by 加富董 on 14-10-22.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitImageView.h"

@class EventItem;

#define CELL_DEFAULT_HEIGHT 65.0
#define VIEW_PADDING_X_MIN 6.0
#define VIEW_PADDING_X_MAX 26.0
#define VIEW_PADDING_Y_TOP 5.0
#define VIEW_PADDING_Y_BOTTOM 5.0
#define VIEW_PADDING_Y_TOP_IN_DES 11.0
#define VIEW_PADDING_Y_BOTTOM_IN_DES 15.0
#define VIEW_SPACING_Y_IN_DES 0.0
#define VIEW_SPACING_X_MIN 14.0
#define VIEW_SPACING_X_MAX 24.0
#define VIEW_SPACING_X_ICON 5.0
#define VIEW_SPACING_X_PRICE 6.0
#define VIEW_SPACING_X_FROM_TO 2.0
#define VIEW_UNAVAILABLE_WIDTH 15.0
#define MAX_VIEW_HEIGHT 1000.f

#define TRANSFER_DATE_LABEL_FONT_SIZE 14.f
#define TRANSFER_DATE_LABEL_WIDTH 120.f
#define TRANSFER_DATE_LABEL_HEIGHT 20.f

#define USER_ICON_WIDTH 50.f
#define USER_ICON_HEIGHT 50.f

#define DES_DEFAULT_HEIGHT 55.0

#define TEXT_DEFAULT_FONG_SIZE 12.0

#define PRICE_LABEL_FONT_SIZE  15.0
#define PRICE_LABEL_HEIGHT 15.0

#define FROM_TO_LABEL_WIDTH 35.0
#define FROM_TO_LABEL_HEIGHT 15.0

#define PRICE_LABEL_MAX_WIDTH 80.0


typedef NS_ENUM(NSInteger, TransferDirection) {
    TransferDirectionFromMe,
    TransferDirectionFromOther
};

typedef NS_ENUM(NSInteger, ViewSpaceX) {
    ViewSpaceXLeft,
    ViewSpaceXRight
};

@interface TransferHistoryCell : UITableViewCell

@property (nonatomic,readonly) PortraitImageView     *transferUserIcon;
@property (nonatomic,readonly) UIImageView           *transferDesImageView;
@property (nonatomic,readonly) UILabel               *priceLabel;
@property (nonatomic,readonly) UILabel               *fromLabel;
@property (nonatomic,readonly) UILabel               *toLabel;
@property (nonatomic,readonly) UILabel               *fromDescriptLabel;
@property (nonatomic,readonly) UILabel               *toDescriptLabel;
@property (nonatomic,assign)   CGSize                availableSize;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)size;

- (CGFloat)getViewSpacingX:(ViewSpaceX)leftOrRight direction:(TransferDirection)direction;

+ (CGFloat)calculateCellHeightByHistoryData:(EventItem *)historyModel availableSize:(CGSize)aviSize;

@end

