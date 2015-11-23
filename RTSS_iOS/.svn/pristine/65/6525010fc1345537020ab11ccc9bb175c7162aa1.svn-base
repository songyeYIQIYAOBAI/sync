//
//  OrderPreviewCell.m
//  RTSS
//
//  Created by 加富董 on 14/11/28.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "OrderPreviewCell.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"
#import "OrderInfoModel.h"
#import "RTSSAppDefine.h"

#define SEPERATE_LINE_HEIGHT 2.0
#define TITLE_LABEL_WIDTH 100.0
#define VIEW_PADDING_X 14.0
#define VIEW_PADDING_Y 10.0
#define VIEW_SPACING_X 10.0
#define TEXT_FONT_SIZE 16.0


@interface OrderPreviewCell () {
    UILabel *infoTitleLabel;
    UILabel *infoContentLabel;
    UIImageView *seperatorLineImageView;
    CGSize cellAvailableSize;
}

@end

@implementation OrderPreviewCell

#pragma mark dealloc 
- (void)dealloc {
    [super dealloc];
}

#pragma mark init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier defaultAvailableSize:(CGSize)size {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        cellAvailableSize = size;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    //title label
    CGRect titleFrme = CGRectMake(VIEW_PADDING_X, VIEW_PADDING_Y, TITLE_LABEL_WIDTH, cellAvailableSize.height - VIEW_PADDING_Y * 2);
    infoTitleLabel = [CommonUtils labelWithFrame:titleFrme text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE] tag:0];
    infoTitleLabel.backgroundColor = [UIColor clearColor];
    infoTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:infoTitleLabel];
    
    //content label
    CGRect contentFrame = CGRectMake(CGRectGetMaxX(infoTitleLabel.frame) + VIEW_SPACING_X, VIEW_PADDING_Y, cellAvailableSize.width - VIEW_PADDING_X * 2 - TITLE_LABEL_WIDTH - VIEW_SPACING_X, cellAvailableSize.height - VIEW_PADDING_Y * 2);
    infoContentLabel = [CommonUtils labelWithFrame:contentFrame text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE] tag:0];
    infoContentLabel.textAlignment = NSTextAlignmentLeft;
    infoContentLabel.numberOfLines = 0;
    infoContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:infoContentLabel];
    
    //seperator line
    CGRect seperatorRect = CGRectMake(0.f, cellAvailableSize.height - SEPERATE_LINE_HEIGHT, cellAvailableSize.width, SEPERATE_LINE_HEIGHT);
    seperatorLineImageView = [[UIImageView alloc] initWithFrame:seperatorRect];
    seperatorLineImageView.image = [UIImage imageNamed:@"common_separator_line"];
    [self.contentView addSubview:seperatorLineImageView];
}

- (void)layoutSubviewsByOrderInfoData:(OrderInfoModel *)orderInfo showSeperateLine:(BOOL)show{
    //seperate line
    show ? seperatorLineImageView.hidden = NO : YES;
    
    //text
    if (orderInfo) {
        //title
        NSString *title = orderInfo.infoTitle;
        infoTitleLabel.text = title;
        if (orderInfo.titleColorStr && ![orderInfo.titleColorStr isEqualToString:@""]) {
            UIColor *textColor = [CommonUtils colorWithHexString:orderInfo.titleColorStr];
            infoTitleLabel.textColor = textColor;
        } else {
            infoTitleLabel.textColor = [[RTSSAppStyle currentAppStyle] textMajorColor];
        }
        
        //content
        NSString *content = orderInfo.infoContent;
        if ([CommonUtils objectIsValid:content]) {
            CGRect contentFrame = CGRectMake(CGRectGetMaxX(infoTitleLabel.frame) + VIEW_SPACING_X, VIEW_PADDING_Y, cellAvailableSize.width - VIEW_PADDING_X * 2 - TITLE_LABEL_WIDTH - VIEW_SPACING_X, cellAvailableSize.height - VIEW_PADDING_Y * 2);
            CGRect seperateFrame = CGRectMake(0.f, cellAvailableSize.height - SEPERATE_LINE_HEIGHT, cellAvailableSize.width, SEPERATE_LINE_HEIGHT);
            CGSize textSize = [CommonUtils calculateTextSize:content constrainedSize:CGSizeMake(CGRectGetWidth(contentFrame), CGFLOAT_MAX) textFontSize:TEXT_FONT_SIZE lineBreakMode:NSLineBreakByWordWrapping];
            if (textSize.height > CGRectGetHeight(contentFrame)) {
                //height
                contentFrame.size = textSize;
                infoContentLabel.frame = contentFrame;
                //seperate line
                CGRect lineFrame = seperatorLineImageView.frame;
                lineFrame.origin.y = CGRectGetMaxY(infoContentLabel.frame) + VIEW_PADDING_Y - SEPERATE_LINE_HEIGHT;
                seperatorLineImageView.frame = lineFrame;
            } else {
                //height
                infoContentLabel.frame = contentFrame;
                //seperate line
                seperatorLineImageView.frame = seperateFrame;
            }
            infoContentLabel.text = content;
            if (orderInfo.contentColorStr && ![orderInfo.contentColorStr isEqualToString:@""]) {
                UIColor *contentColor = [CommonUtils colorWithHexString:orderInfo.contentColorStr];
                infoContentLabel.textColor = contentColor;
            } else {
                infoContentLabel.textColor = [[RTSSAppStyle currentAppStyle] textSubordinateColor];
            }
        }
    }
}

#pragma mark height
+ (CGFloat)calculateCellHeightByCellData:(OrderInfoModel *)dataModel defaultAvailableSize:(CGSize)defaultSize {
    CGFloat cellHeight = ORDER_PREVIEW_CELL_DEFAULT_HEIGHT;
    if (dataModel) {
        NSString *contentText = dataModel.infoContent;
        if ([CommonUtils objectIsValid:contentText]) {
            CGSize contentSize = [CommonUtils calculateTextSize:contentText constrainedSize:CGSizeMake(defaultSize.width - VIEW_PADDING_X * 2 - VIEW_SPACING_X - TITLE_LABEL_WIDTH, CGFLOAT_MAX) textFontSize:TEXT_FONT_SIZE lineBreakMode:NSLineBreakByWordWrapping];
            if (contentSize.height > defaultSize.height - VIEW_PADDING_Y * 2) {
                cellHeight = VIEW_PADDING_Y * 2 + contentSize.height;
            }
        }
    }
    return cellHeight;
}

#pragma mark others
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
