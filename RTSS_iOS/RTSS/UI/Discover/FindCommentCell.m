//
//  FindCommentCell.m
//  RTSS
//
//  Created by Jaffer on 15/4/2.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "FindCommentCell.h"
#import "RTSSAppStyle.h"
#import "CommonUtils.h"

@implementation FindCommentCell

@synthesize comFromIconImageView,comFromNickLabel,comDateLabel;
@synthesize comContentLabel,comSepImageView,comFrame;

#pragma mark dealloc
- (void)dealloc {
    [comFromIconImageView release];
    [comSepImageView release];
    [comFrame release];
    
    [super dealloc];
}

#pragma mark init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadViews];
    }
    return self;
}

- (void)loadViews {
    comFromIconImageView = [[PortraitImageView alloc] initWithFrame:CGRectZero image:nil borderColor:[[RTSSAppStyle currentAppStyle] portraitBorderColor] borderWidth:1.0];
    comFromIconImageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:comFromIconImageView];
    
    comFromNickLabel = [CommonUtils labelWithFrame:CGRectZero text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[UIFont systemFontOfSize:COMMENT_CELL_FROM_NICK_LABEL_FONT_SIZE] tag:0];
    comFromNickLabel.textAlignment = NSTextAlignmentLeft;
    comFromNickLabel.lineBreakMode = NSLineBreakByWordWrapping;
    comFromNickLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:comFromNickLabel];
    
    comDateLabel = [CommonUtils labelWithFrame:CGRectZero text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[UIFont systemFontOfSize:COMMENT_CELL_FROM_DATE_LABEL_FONT_SIZE] tag:0];
    comDateLabel.textAlignment = NSTextAlignmentRight;
    comDateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    comDateLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:comDateLabel];
    
    comContentLabel = [CommonUtils labelWithFrame:CGRectZero text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[UIFont systemFontOfSize:COMMENT_CELL_CONTENT_LABEL_FONT_SIZE] tag:0];
    comContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    comContentLabel.textAlignment = NSTextAlignmentLeft;
    comContentLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:comContentLabel];
    
    comSepImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    comSepImageView.backgroundColor = [[RTSSAppStyle currentAppStyle] turboBoostUnfoldBgColor];
    [self.contentView addSubview:comSepImageView];
}

@end
