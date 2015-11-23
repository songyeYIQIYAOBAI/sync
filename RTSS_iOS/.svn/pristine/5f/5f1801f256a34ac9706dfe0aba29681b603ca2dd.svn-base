//
//  TransferHistoryCell.m
//  EasyTT
//
//  Created by 加富董 on 14-10-22.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "TransferHistoryCell.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"
#import "PortraitImageView.h"
#import "RTSSAppDefine.h"
#import "EventItem.h"

@implementation TransferHistoryCell

@synthesize transferUserIcon;
@synthesize transferDesImageView;
@synthesize priceLabel;
@synthesize fromLabel;
@synthesize toLabel;
@synthesize fromDescriptLabel;
@synthesize toDescriptLabel;
@synthesize availableSize;

#pragma mark -- dealloc
- (void) dealloc
{
    [transferUserIcon release];
    [transferDesImageView release];
    [super dealloc];
}

#pragma mark init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)size
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        availableSize = size;
        [self initViews];
    }
    return self;
}

- (void) initViews
{
    //des imageview
    transferDesImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:transferDesImageView];
    
    //price label
    priceLabel = [CommonUtils labelWithFrame:CGRectZero text:nil textColor:[RTSSAppStyle getFreeResourceColorWithIndex:0] textFont:[UIFont boldSystemFontOfSize:PRICE_LABEL_FONT_SIZE] tag:0];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    priceLabel.numberOfLines = 0;
    [transferDesImageView addSubview:priceLabel];
    
    //from label
    fromLabel = [CommonUtils labelWithFrame:CGRectZero text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[UIFont systemFontOfSize:TEXT_DEFAULT_FONG_SIZE] tag:0];
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.textAlignment = NSTextAlignmentRight;
    fromLabel.lineBreakMode = NSLineBreakByWordWrapping;
    fromLabel.numberOfLines = 1;
    [transferDesImageView addSubview:fromLabel];
    
    //to label
    toLabel = [CommonUtils labelWithFrame:CGRectZero text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[UIFont systemFontOfSize:TEXT_DEFAULT_FONG_SIZE] tag:0];
    toLabel.backgroundColor = [UIColor clearColor];
    toLabel.textAlignment = NSTextAlignmentRight;
    toLabel.lineBreakMode = NSLineBreakByWordWrapping;
    toLabel.numberOfLines = 1;
    [transferDesImageView addSubview:toLabel];
    
    //from des
    fromDescriptLabel = [CommonUtils labelWithFrame:CGRectZero text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[UIFont systemFontOfSize:TEXT_DEFAULT_FONG_SIZE] tag:0];
    fromDescriptLabel.backgroundColor = [UIColor clearColor];
    fromDescriptLabel.textAlignment = NSTextAlignmentLeft;
    fromDescriptLabel.lineBreakMode = NSLineBreakByCharWrapping;
    fromDescriptLabel.numberOfLines = 0;
    [transferDesImageView addSubview:fromDescriptLabel];
    
    //to des
    toDescriptLabel = [CommonUtils labelWithFrame:CGRectZero text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[UIFont systemFontOfSize:TEXT_DEFAULT_FONG_SIZE] tag:0];
    toDescriptLabel.backgroundColor = [UIColor clearColor];
    toDescriptLabel.textAlignment = NSTextAlignmentLeft;
    toDescriptLabel.lineBreakMode = NSLineBreakByCharWrapping;
    toDescriptLabel.numberOfLines = 0;
    [transferDesImageView addSubview:toDescriptLabel];
    
    //user icon
    transferUserIcon = [[PortraitImageView alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"friends_default_icon"] borderColor:[[RTSSAppStyle currentAppStyle] portraitBorderColor] borderWidth:1.f];
    transferUserIcon.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:transferUserIcon];
}

- (CGFloat)getViewSpacingX:(ViewSpaceX)leftOrRight direction:(TransferDirection)direction {
    CGFloat spaceX = 0.0;
    if (leftOrRight == ViewSpaceXLeft) {
        if (direction == TransferDirectionFromMe) {
            spaceX = VIEW_SPACING_X_MIN;
        } else {
            spaceX = VIEW_SPACING_X_MAX;
        }
    } else {
        if (direction == TransferDirectionFromMe) {
            spaceX = VIEW_SPACING_X_MAX;
        } else {
            spaceX = VIEW_SPACING_X_MIN;
        }
    }
    return spaceX;
}

#pragma mark calculate height
+ (CGFloat)calculateCellHeightByHistoryData:(EventItem *)historyModel availableSize:(CGSize)aviSize {
    //dircetion
    TransferDirection direction = TransferDirectionFromMe;
    if (historyModel.mType == EventTypeBalanceTransferOut) {
        direction = TransferDirectionFromMe;
    } else if (historyModel.mType == EventTypeBalanceTransferIn) {
        direction = TransferDirectionFromOther;
    }
   
    CGFloat desWidth = aviSize.width - VIEW_PADDING_X_MIN - VIEW_PADDING_X_MAX - USER_ICON_WIDTH - VIEW_SPACING_X_ICON;
    
    NSDictionary *parameters = historyModel.mParameters;
    
    //price label
    long long amount = 0;
    if ([CommonUtils objectIsValid:parameters]) {
        //<<<<<<<<
        //amount = (long long)[parameters objectForKey:SERVICE_AMOUNT_KEY];
    }
    NSString *price = [NSString stringWithFormat:@"%@%.2f",NSLocalizedString(@"Currency_Unit", nil),[CommonUtils formatMoneyFromPennyToYuan:amount]];
    CGSize priceSize = [CommonUtils calculateTextSize:price constrainedSize:CGSizeMake(CGFLOAT_MAX, PRICE_LABEL_HEIGHT) textFont:[UIFont boldSystemFontOfSize:PRICE_LABEL_FONT_SIZE] lineBreakMode:NSLineBreakByWordWrapping];
    if (priceSize.width > PRICE_LABEL_MAX_WIDTH) {
        priceSize.width = PRICE_LABEL_MAX_WIDTH;
    }
    
    CGFloat fromToDesAvaiWidth = desWidth - VIEW_SPACING_X_MIN - VIEW_SPACING_X_MAX - priceSize.width - VIEW_SPACING_X_PRICE - FROM_TO_LABEL_WIDTH - VIEW_SPACING_X_FROM_TO;

    CGFloat totalHeight = 0.;
    if (historyModel) {
        totalHeight = VIEW_PADDING_Y_TOP + VIEW_PADDING_Y_BOTTOM + VIEW_PADDING_Y_TOP_IN_DES + VIEW_PADDING_Y_BOTTOM_IN_DES + VIEW_SPACING_Y_IN_DES;
        NSString *fromDes = nil;
        if ([CommonUtils objectIsValid:parameters]) {
            //<<<<<<<
            /*
            if (direction == TransferDirectionFromMe) {
                fromDes = [NSString stringWithFormat:@"%@.%@",[[[RTSSAppStyle currentAppStyle] getServiceSourceWithServiceType:[parameters objectForKey:SERVICE_TYPE_KEY]] objectForKey:SERVICE_NAME_KEY],[parameters objectForKey:SERVICE_ID_KEY]];
            } else {
                fromDes = [NSString stringWithFormat:@"%@.%@",[[[RTSSAppStyle currentAppStyle] getServiceSourceWithServiceType:[parameters objectForKey:SERVICE_TYPE_SOURCE_KEY]] objectForKey:SERVICE_NAME_KEY],[parameters objectForKey:SERVICE_ID_SOURCE_KEY]];
            }
             */
        }
        CGSize fromDesSize = [CommonUtils calculateTextSize:fromDes constrainedSize:CGSizeMake(fromToDesAvaiWidth, CGFLOAT_MAX) textFontSize:TEXT_DEFAULT_FONG_SIZE lineBreakMode:NSLineBreakByCharWrapping];
        if (fromDesSize.height <= 0.) {
            fromDesSize.height = FROM_TO_LABEL_HEIGHT;
        }
        totalHeight += fromDesSize.height;
        
        NSString *toDes = nil;
        if ([CommonUtils objectIsValid:parameters]) {
            //<<<<<
            /*
            if (direction == TransferDirectionFromMe) {
                toDes = [parameters objectForKey:SERVICE_TARGET_ID_KEY];
            } else {
                toDes = [parameters objectForKey:SERVICE_ID_KEY];
            }
             */
        }
        CGSize toDesSize = [CommonUtils calculateTextSize:toDes constrainedSize:CGSizeMake(fromToDesAvaiWidth, CGFLOAT_MAX) textFontSize:TEXT_DEFAULT_FONG_SIZE lineBreakMode:NSLineBreakByCharWrapping];
        if (toDesSize.height <= 0.) {
            toDesSize.height = FROM_TO_LABEL_HEIGHT;
        }
        totalHeight += toDesSize.height;
    }
    return totalHeight;
}

#pragma mark -- other

@end
