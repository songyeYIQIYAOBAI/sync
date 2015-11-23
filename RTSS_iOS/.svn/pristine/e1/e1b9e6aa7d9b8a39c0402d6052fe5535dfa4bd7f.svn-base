//
//  BudgetHistoryCell.m
//  RTSS
//
//  Created by 加富董 on 15/2/3.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BudgetHistoryCell.h"
#import "PortraitImageView.h"
#import "RTSSAppDefine.h"
#import "RTSSAppStyle.h"
#import "CommonUtils.h"
#import "ImageUtils.h"

#define HISTORY_CELL_PADDING_X_LEFT 12.0
#define HISTORY_CELL_PADDING_X_RIGHT 12.0
#define HISTORY_CELL_PORTRAIT_SPACE_X 6.0
#define HISTORY_CELL_LABEL_SPACE_Y 2.0

#define HISTORY_CELL_PORTRAIT_WIDTH 38.0
#define HISTORY_CELL_PORTRAIT_HEIGHT 38.0

#define HISTORY_CELL_NAME_LABEL_FONT_SIZE 14.0
#define HISTORY_CELL_NAME_LABEL_HEIGTH 15.0
#define HISTORY_CELL_LABEL_OFFSET_Y 12.0

#define HISTORY_CELL_USAGE_LABEL_FONT_SIZE 14.0
#define HISTORY_CELL_USAGE_LABEL_HEIGHT 15.0

#define HISTORY_CELL_PROGRESS_VIEW_HEIGHT 8.0


@interface BudgetHistoryCell () {
    CGSize availableSize;
}

@end

@implementation BudgetHistoryCell

@synthesize memberPortraitImageView;
@synthesize memberNameNumLabel;
@synthesize memberProgressView;
@synthesize memberUsageLabel;

#pragma mark dealloc
- (void)dealloc {
    [memberProgressView release];
    [memberPortraitImageView release];
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

#pragma mark init view
- (void)initViews {
    //portrait
    CGRect portraitRect = CGRectMake(HISTORY_CELL_PADDING_X_LEFT, (availableSize.height - HISTORY_CELL_PORTRAIT_HEIGHT - SEPERATOR_LINE_HEIGHT) / 2.0, HISTORY_CELL_PORTRAIT_WIDTH, HISTORY_CELL_PORTRAIT_HEIGHT);
    memberPortraitImageView = [[PortraitImageView alloc] initWithFrame:portraitRect image:nil borderColor:[[RTSSAppStyle currentAppStyle] portraitBorderColor] borderWidth:1.0];
    memberPortraitImageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:memberPortraitImageView];
    
    //name num label
    CGRect nameNumRect = CGRectMake(CGRectGetMaxX(memberPortraitImageView.frame) + HISTORY_CELL_PORTRAIT_SPACE_X, HISTORY_CELL_LABEL_OFFSET_Y, availableSize.width - CGRectGetMaxX(memberPortraitImageView.frame) - HISTORY_CELL_PORTRAIT_SPACE_X - HISTORY_CELL_PADDING_X_RIGHT, HISTORY_CELL_NAME_LABEL_HEIGTH);
    memberNameNumLabel = [CommonUtils labelWithFrame:nameNumRect text:nil textColor:nil textFont:[RTSSAppStyle getRTSSFontWithSize:HISTORY_CELL_USAGE_LABEL_FONT_SIZE] tag:0];
    memberNameNumLabel.textAlignment = NSTextAlignmentLeft;
    memberNameNumLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:memberNameNumLabel];
    
    //usage label
    CGRect usageRect = CGRectMake(CGRectGetMaxX(memberPortraitImageView.frame) + HISTORY_CELL_PORTRAIT_SPACE_X, HISTORY_CELL_LABEL_OFFSET_Y, availableSize.width - CGRectGetMaxX(memberPortraitImageView.frame) - HISTORY_CELL_PORTRAIT_SPACE_X - HISTORY_CELL_PADDING_X_RIGHT, HISTORY_CELL_USAGE_LABEL_HEIGHT);
    memberUsageLabel = [CommonUtils labelWithFrame:usageRect text:nil textColor:nil textFont:[RTSSAppStyle getRTSSFontWithSize:HISTORY_CELL_USAGE_LABEL_FONT_SIZE] tag:0];
    memberUsageLabel.textAlignment = NSTextAlignmentRight;
    memberUsageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:memberUsageLabel];
    
    //progress view
//    CGRect progressBgRect = CGRectMake(CGRectGetMaxX(memberPortraitImageView.frame) + HISTORY_CELL_PORTRAIT_SPACE_X, CGRectGetMaxY(memberNameNumLabel.frame) + HISTORY_CELL_LABEL_SPACE_Y, availableSize.width - CGRectGetMaxX(memberPortraitImageView.frame) - HISTORY_CELL_PORTRAIT_SPACE_X - HISTORY_CELL_PADDING_X_RIGHT, HISTORY_CELL_PROGRESS_VIEW_HEIGHT);
    CGRect progressBgRect = CGRectMake(CGRectGetMaxX(memberPortraitImageView.frame) + HISTORY_CELL_PORTRAIT_SPACE_X, CGRectGetMaxY(memberNameNumLabel.frame) + HISTORY_CELL_LABEL_SPACE_Y, availableSize.width - CGRectGetMaxX(memberPortraitImageView.frame) - HISTORY_CELL_PORTRAIT_SPACE_X - HISTORY_CELL_PADDING_X_RIGHT, HISTORY_CELL_PROGRESS_VIEW_HEIGHT);
    UIView *progressView = [[UIView alloc] initWithFrame:progressBgRect];
    progressView.backgroundColor = [UIColor clearColor];
    progressView.layer.borderColor = [[RTSSAppStyle currentAppStyle] portraitBorderColor].CGColor;
    progressView.layer.borderWidth = 1.0;
    [self.contentView addSubview:progressView];
    [progressView release];
    
    CGRect progressRect = CGRectMake(0.0, 3.0, CGRectGetWidth(progressView.frame), CGRectGetHeight(progressView.frame));
    memberProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    memberProgressView.frame = progressRect;
    memberProgressView.transform = CGAffineTransformMakeScale(1.0, 3.0);
    
    CGSize imageSize = CGSizeMake(CGRectGetWidth(progressRect), HISTORY_CELL_PROGRESS_VIEW_HEIGHT * 2);
    UIImage *progressImage = [ImageUtils createImageWithColor:[[RTSSAppStyle currentAppStyle] commonGreenButtonHighlightColor] size:imageSize];
    memberProgressView.progressImage = progressImage;
    
    UIImage *trackImage = [ImageUtils createImageWithColor:[[RTSSAppStyle currentAppStyle] commonGreenButtonNormalColor] size:imageSize];
    memberProgressView.trackImage = trackImage;
    
    memberProgressView.progressTintColor = [[RTSSAppStyle currentAppStyle] commonGreenButtonNormalColor];
    memberProgressView.trackTintColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    
    [progressView addSubview:memberProgressView];
    
    //seperator line
    CGRect lineRect = CGRectMake(0.0, availableSize.height - SEPERATOR_LINE_HEIGHT, availableSize.width, SEPERATOR_LINE_HEIGHT);
    UIImageView *sepImageView = [[UIImageView alloc] initWithFrame:lineRect];
    sepImageView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;

    [self.contentView addSubview:sepImageView];
    [sepImageView release];
}

@end
