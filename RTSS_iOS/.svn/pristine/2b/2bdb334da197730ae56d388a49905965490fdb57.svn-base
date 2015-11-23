//
//  BudgetAddMembersCell.m
//  RTSS
//
//  Created by 加富董 on 15/2/2.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BudgetAddMembersCell.h"
#import "CommonUtils.h"
#import "PortraitImageView.h"
#import "RTSSAppDefine.h"
#import "RTSSAppStyle.h"

#define ADD_CELL_PADDING_X_LEFT 12.0
#define ADD_CELL_PADDING_X_RIGHT 12.0
#define ADD_CELL_ICON_SPCAE_X 16.0
#define ADD_CELL_LABEL_SPACE_X 5.0

#define ADD_CELL_ICON_WIDTH 40.0
#define ADD_CELL_ICON_HEIGHT 40.0

#define ADD_CELL_TEXT_LABEL_FONT_SIZE 14.0

#define ADD_CELL_ARROW_WIDTH 20.0
#define ADD_CELL_ARROW_HEIGHT 20.0

@interface BudgetAddMembersCell () {
    CGSize availableSize;
}

@end

@implementation BudgetAddMembersCell

@synthesize iconImageView;
@synthesize methodTextLable;
@synthesize arrowImageView;

#pragma mark dealloc
- (void)dealloc {
    [iconImageView release];
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
    //method icon
    CGRect iconRect = CGRectMake(ADD_CELL_PADDING_X_LEFT, (availableSize.height - ADD_CELL_ICON_HEIGHT - SEPERATOR_LINE_HEIGHT) / 2.0, ADD_CELL_ICON_WIDTH, ADD_CELL_ICON_HEIGHT);
    iconImageView = [[PortraitImageView alloc] initWithFrame:iconRect image:nil borderColor:[[RTSSAppStyle currentAppStyle] portraitBorderColor] borderWidth:1.0];
    iconImageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:iconImageView];
    
    //text label
    CGRect lableRect = CGRectMake(CGRectGetMaxX(iconImageView.frame) + ADD_CELL_ICON_SPCAE_X, 0.0, availableSize.width - CGRectGetMaxX(iconImageView.frame) - ADD_CELL_ICON_SPCAE_X - ADD_CELL_PADDING_X_RIGHT - ADD_CELL_ARROW_WIDTH - ADD_CELL_LABEL_SPACE_X, availableSize.height - SEPERATOR_LINE_HEIGHT);
    methodTextLable = [CommonUtils labelWithFrame:lableRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[RTSSAppStyle getRTSSFontWithSize:ADD_CELL_TEXT_LABEL_FONT_SIZE] tag:0];
    methodTextLable.textAlignment = NSTextAlignmentLeft;
    methodTextLable.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:methodTextLable];
    
    //arrow image
    CGRect arrowRect = CGRectMake(availableSize.width - ADD_CELL_PADDING_X_RIGHT - ADD_CELL_ARROW_WIDTH, (availableSize.height - ADD_CELL_ARROW_HEIGHT - SEPERATOR_LINE_HEIGHT) / 2.0, ADD_CELL_ARROW_WIDTH, ADD_CELL_ARROW_HEIGHT);
    arrowImageView = [[UIImageView alloc] initWithFrame:arrowRect];
    [self.contentView addSubview:arrowImageView];
    
    //seperator line
    CGRect sepRect = CGRectMake(0.0, availableSize.height - SEPERATOR_LINE_HEIGHT, availableSize.width   , SEPERATOR_LINE_HEIGHT);
    UIImageView *seperatorImageView = [[UIImageView alloc] initWithFrame:sepRect];
    seperatorImageView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self.contentView addSubview:seperatorImageView];
    [seperatorImageView release];
}

@end
