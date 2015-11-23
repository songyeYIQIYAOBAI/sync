//
//  ProductResourceView.m
//  RTSS
//
//  Created by 加富董 on 14/11/14.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "ProductResourceView.h"
#import "ProductResource.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"
#import "RTSSAppDefine.h"

#define VIEW_PADDING_X 0.f
#define VIEW_SPACE_X 0.f
#define RESOURCE_ICON_VIEW_WIDTH 20.f
#define RESOURCE_ICON_VIEW_HEIGHT 20.f
#define RESORUCE_AMOUNT_VIEW_HEIGHT 20.f
#define RESOURCE_AMOUNT_LABEL_FONT_SIZE 12.f

#define ICON_NAME_FOR_DATA_AMOUNT            @"personcenter_cell_phone"
#define ICON_NAME_FOR_MONEY                  @"personcenter_cell_packageserve"
#define ICON_NAME_FOR_TIME                   @"personcenter_cell_name"
#define ICON_NAME_FOR_MESSAGE_AMOUNT         @"personcenter_cell_headimage"

@interface ProductResourceView () {
    
}

@end

@implementation ProductResourceView

#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame productResourceData:(ProductResource *)productResource {
    if (self = [super initWithFrame:frame]) {
        [self initViewsByData:productResource];
    }
    return self;
}

#pragma mark layout views
- (void)initViewsByData:(ProductResource *)resource {
    //bg
    self.backgroundColor = [UIColor clearColor];
    
    //icon
    CGRect iconRect = CGRectZero;
    if (resource.mUnit > 0) {
        iconRect = CGRectMake(VIEW_PADDING_X, (CGRectGetHeight(self.frame) - RESOURCE_ICON_VIEW_HEIGHT) / 2.f, RESOURCE_ICON_VIEW_WIDTH, RESOURCE_ICON_VIEW_HEIGHT);
        UIImageView *resourceIcon = [[UIImageView alloc] initWithFrame:iconRect];
        
        [resourceIcon setImage:[self getResourceIconNameByType:resource.mTypeCode]];
        [self addSubview:resourceIcon];
        [resourceIcon release];
    }
    
    //amount
    if (resource.mTotal > 0) {
        CGRect countRect = CGRectMake(CGRectGetMaxX(iconRect) + VIEW_SPACE_X, (CGRectGetHeight(self.frame) - RESORUCE_AMOUNT_VIEW_HEIGHT) / 2.f, CGRectGetWidth(self.frame) - CGRectGetMaxX(iconRect) - VIEW_SPACE_X, RESORUCE_AMOUNT_VIEW_HEIGHT);
        NSString *countStr = [self formatResourceAmount:resource];
        UILabel *countLabel = [CommonUtils labelWithFrame:countRect text:countStr textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[RTSSAppStyle getRTSSFontWithSize:RESOURCE_AMOUNT_LABEL_FONT_SIZE] tag:0];
        countLabel.adjustsFontSizeToFitWidth = YES;
        countLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:countLabel];
    }
}



-(UIImage*)getResourceIconNameByType:(int)type {
    switch (type) {
        case 1:
            return [UIImage imageNamed:@"quickorder_voice_icon"];
            break;
        case 2:
            return [UIImage imageNamed:@"quickorder_sms_icon"];
            break;
        case 3:
            return [UIImage imageNamed:@"quickorder_data_icon"];
            break;
        case 4:
            return [UIImage imageNamed:@"quickorder_spotify_icon"];
            break;
        case 5:
            return [UIImage imageNamed:@"quickorder_wifi_icon"];
        default:
            return [UIImage imageNamed:@"quickorder_voice_icon"];
            break;
    }
}

- (NSString *)formatResourceAmount:(ProductResource *)productResource {
    NSString *amountStr = nil;
    MeasureUnit type = productResource.mUnit;
    switch (type) {
       
        case UnitForMoney:
            amountStr = [CommonUtils formatMoneyWithPenny:productResource.mTotal decimals:0 unitEnable:NO];
            break;
        case UnitForDataAmount:
        case UnitForTime:
        case UnitForMessageAmount:
            amountStr = [CommonUtils formatResourcesWithValue:productResource.mTotal unit:type decimals:0 unitEnable:NO];
            break;
        default:
            break;
    }
    return amountStr;
}

#pragma mark dealloc
- (void)dealloc {
    [super dealloc];
}

@end
