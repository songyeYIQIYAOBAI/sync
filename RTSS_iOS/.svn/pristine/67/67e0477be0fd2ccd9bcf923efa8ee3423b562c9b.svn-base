//
//  FindShareCell.m
//  RTSS
//
//  Created by Jaffer on 15/4/3.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "FindShareCell.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"

#define SHARE_CELL_ICON_SPACE_X_LEFT 10.0
#define SHARE_CELL_ICON_WIDTH 40.0
#define SHARE_CELL_ICON_HEIGHT 40.0

#define SHARE_CELL_NAME_LABEL_SPACE_X_LEFT 10.0
#define SHARE_CELL_NAME_LABEL_HEIGHT 40.0
#define SHARE_CELL_NAME_LABEL_FONT_SIZE 14.0

#define SHARE_CELL_ARROW_WIDTH 20.0
#define SHARE_CELL_ARROW_HEIGHT 20.0
#define SHARE_CELL_ARROW_SPACE_X_LEFT 10.0
#define SHARE_CELL_ARROW_SPACE_X_RIGHT 10.0

#define SHARE_CELL_SEP_LINE_SPACE_X_LEFT 0.0
#define SHARE_CELL_SEP_LINE_SPACE_X_RIGHT 0.0
#define SHARE_CELL_SEP_LINE_HEIGHT 0.5

@implementation FindShareCell {
    CGSize availableSize;
}

@synthesize shareIconImageView,shareNameLabel,shareArrowImageView;
@synthesize shareSepLineImageView;

#pragma mark dealloc
- (void)dealloc {
    [shareIconImageView release];
    [shareArrowImageView release];
    [shareSepLineImageView release];
    
    [super dealloc];
}

#pragma mark init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)size {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        availableSize = size;
        [self loadViews];
    }
    return self;
}

#pragma mark load views
- (void)loadViews {
    //icon
    CGRect iconRect = CGRectMake(SHARE_CELL_ICON_SPACE_X_LEFT, (availableSize.height - SHARE_CELL_ICON_HEIGHT - SHARE_CELL_SEP_LINE_HEIGHT) / 2.0, SHARE_CELL_ICON_WIDTH, SHARE_CELL_ICON_HEIGHT);
    shareIconImageView = [[UIImageView alloc] initWithFrame:iconRect];
    [self.contentView addSubview:shareIconImageView];
    
    //name
    CGRect nameRect = CGRectMake(CGRectGetMaxX(iconRect) + SHARE_CELL_NAME_LABEL_SPACE_X_LEFT, (availableSize.height - SHARE_CELL_NAME_LABEL_HEIGHT - SHARE_CELL_SEP_LINE_HEIGHT) / 2.0, availableSize.width - CGRectGetMaxX(iconRect) - SHARE_CELL_NAME_LABEL_SPACE_X_LEFT - SHARE_CELL_ARROW_SPACE_X_RIGHT - SHARE_CELL_ARROW_WIDTH - SHARE_CELL_ARROW_SPACE_X_LEFT, SHARE_CELL_NAME_LABEL_HEIGHT);
    shareNameLabel = [CommonUtils labelWithFrame:nameRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[UIFont systemFontOfSize:14.0] tag:0];
    shareNameLabel.backgroundColor = [UIColor clearColor];
    shareNameLabel.textAlignment = NSTextAlignmentLeft;
    shareNameLabel.numberOfLines = 1;
    shareNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:shareNameLabel];
    
    //arrow
    CGRect arrowRect = CGRectMake(CGRectGetMaxX(nameRect) + SHARE_CELL_ARROW_SPACE_X_LEFT, (availableSize.height - SHARE_CELL_ARROW_HEIGHT - SHARE_CELL_SEP_LINE_HEIGHT) / 2.0, SHARE_CELL_ARROW_WIDTH, SHARE_CELL_ARROW_HEIGHT);
    shareArrowImageView = [[UIImageView alloc] initWithFrame:arrowRect];
    [self.contentView addSubview:shareArrowImageView];
    
    //sep
    CGRect sepRect = CGRectMake(SHARE_CELL_SEP_LINE_SPACE_X_LEFT, availableSize.height - SHARE_CELL_SEP_LINE_HEIGHT, availableSize.width - SHARE_CELL_SEP_LINE_SPACE_X_LEFT - SHARE_CELL_SEP_LINE_SPACE_X_RIGHT, SHARE_CELL_SEP_LINE_HEIGHT);
    shareSepLineImageView = [[UIImageView alloc] initWithFrame:sepRect];
    [self.contentView addSubview:shareSepLineImageView];
}

@end
