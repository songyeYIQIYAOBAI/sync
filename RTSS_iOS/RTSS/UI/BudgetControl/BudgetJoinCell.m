//
//  BudgetJoinCell.m
//  RTSS
//
//  Created by 加富董 on 15/2/2.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BudgetJoinCell.h"
#import "CommonUtils.h"
#import "RTSSAppDefine.h"
#import "RTSSAppStyle.h"

#define JOIN_CELL_PADDING_X_LEFT 12.0
#define JOIN_CELL_PADDING_X_RIGHT 12.0
#define JOIN_CELL_LABEL_SPACE_X 5.0
#define JOIN_CELL_ICON_SPACE_X 5.0

#define JOIN_CELL_LABEL_FONT_SIZE 14.0

#define JOIN_CELL_ICON_WIDTH 27.0
#define JOIN_CELL_ICON_HEIGHT 27.0

#define JOIN_CELL_ARROW_WIDTH 20.0
#define JOIN_CELL_ARROW_HEIGHT 20.0

@interface BudgetJoinCell () {
    CGSize availableSize;
}

@end


@implementation BudgetJoinCell

@synthesize joinMethodIcon;
@synthesize joinMethodLabel;
@synthesize arrowImageView;

#pragma mark dealloc
- (void)dealloc {
    [joinMethodIcon release];
    [arrowImageView release];
    [super dealloc];
}

#pragma mark init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)size {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        availableSize = size;
        [self initViews];
    }
    return self;
}

#pragma mark load views
- (void)initViews {
    //method label
    CGRect labelRect = CGRectMake(JOIN_CELL_PADDING_X_LEFT, 0.0, availableSize.width - JOIN_CELL_PADDING_X_LEFT - JOIN_CELL_PADDING_X_RIGHT - JOIN_CELL_ARROW_WIDTH - JOIN_CELL_ICON_SPACE_X - JOIN_CELL_ICON_WIDTH - JOIN_CELL_LABEL_SPACE_X, availableSize.height - SEPERATOR_LINE_HEIGHT);
    joinMethodLabel = [CommonUtils labelWithFrame:labelRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[RTSSAppStyle getRTSSFontWithSize:JOIN_CELL_LABEL_FONT_SIZE] tag:0];
    joinMethodLabel.textAlignment = NSTextAlignmentLeft;
    joinMethodLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:joinMethodLabel];
    
    //icon
    CGRect iconRect = CGRectMake(CGRectGetMaxX(joinMethodLabel.frame) + JOIN_CELL_LABEL_SPACE_X, (availableSize.height - JOIN_CELL_ICON_HEIGHT - SEPERATOR_LINE_HEIGHT) / 2.0, JOIN_CELL_ICON_WIDTH, JOIN_CELL_ICON_HEIGHT);
    joinMethodIcon = [[UIImageView alloc] initWithFrame:iconRect];
    joinMethodIcon.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:joinMethodIcon];
    
    //arrow image
    CGRect arrowRect = CGRectMake(availableSize.width - JOIN_CELL_PADDING_X_RIGHT - JOIN_CELL_ARROW_WIDTH, (availableSize.height - JOIN_CELL_ARROW_HEIGHT - SEPERATOR_LINE_HEIGHT) / 2.0, JOIN_CELL_ARROW_WIDTH, JOIN_CELL_ARROW_HEIGHT);
    arrowImageView = [[UIImageView alloc] initWithFrame:arrowRect];
    [self.contentView addSubview:arrowImageView];
    
    //seperator line
    CGRect lineRect = CGRectMake(0.0, availableSize.height - SEPERATOR_LINE_HEIGHT, availableSize.width, SEPERATOR_LINE_HEIGHT);
    UIImageView *sepImageView = [[UIImageView alloc] initWithFrame:lineRect];
    sepImageView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self.contentView addSubview:sepImageView];
    [sepImageView release];
}

@end
