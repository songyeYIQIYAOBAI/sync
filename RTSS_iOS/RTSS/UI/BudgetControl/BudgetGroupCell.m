//
//  BudgetGroupCell.m
//  RTSS
//
//  Created by 加富董 on 15/1/26.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BudgetGroupCell.h"
#import "PortraitImageView.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"

#define VIEW_PADDING_X_LEFT 10.0
#define VIEW_PADDING_X_RIGHT 14.0
#define VIEW_SPACE_X_DEFAULT 5.0
#define VIEW_SPACE_X_BEHIND_PORTRAIT_IMAGE 8.0

#define PORTRAIT_IMAGE_WIDTH 50.0
#define PORTRAIT_IMAGE_HEIGHT 50.0

#define NAME_LABEL_FONT_SIZE 14.0

#define HISTORY_BUTTON_WIDTH 28.0
#define HISTORY_BUTTON_HEIGHT 28.0

#define SEPERATOR_LINE_HEIGHT 2.0

@interface BudgetGroupCell ()

@property (nonatomic,assign) CGSize availableSize;

@end

@implementation BudgetGroupCell

@synthesize availableSize;
@synthesize groupHistoryButton;
@synthesize groupImageView;
@synthesize groupNameLabel;
@synthesize cellIndexPath;
@synthesize delegate;
@synthesize groupSeperatorImageView;

#pragma mark dealloc
- (void)dealloc {
    [groupSeperatorImageView release];
    [groupNameLabel release];
    [cellIndexPath release];
    cellIndexPath = nil;
    [super dealloc];
}

#pragma mark init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)size {
    [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.availableSize = size;
    [self loadSubViews];
    return self;
}


#pragma init views
- (void)loadSubViews {
    //portrait
    CGRect portraitRect = CGRectMake(VIEW_PADDING_X_LEFT, (availableSize.height - PORTRAIT_IMAGE_HEIGHT - SEPERATOR_LINE_HEIGHT) / 2.0, PORTRAIT_IMAGE_WIDTH, PORTRAIT_IMAGE_HEIGHT);
    groupImageView = [[PortraitImageView alloc] initWithFrame:portraitRect image:nil borderColor:[[RTSSAppStyle currentAppStyle] portraitBorderColor] borderWidth:1.0];
    groupImageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:groupImageView];
    
    //name
    CGRect nameRect = CGRectMake(CGRectGetMaxX(groupImageView.frame) + VIEW_SPACE_X_BEHIND_PORTRAIT_IMAGE, 0.0, availableSize.width - CGRectGetMaxX(groupImageView.frame) - VIEW_SPACE_X_BEHIND_PORTRAIT_IMAGE - VIEW_PADDING_X_RIGHT - HISTORY_BUTTON_WIDTH - VIEW_SPACE_X_DEFAULT, availableSize.height - SEPERATOR_LINE_HEIGHT);
    groupNameLabel = [CommonUtils labelWithFrame:nameRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[UIFont systemFontOfSize:NAME_LABEL_FONT_SIZE] tag:0];
    groupNameLabel.backgroundColor = [UIColor clearColor];
    groupNameLabel.textAlignment = NSTextAlignmentLeft;
    groupNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:groupNameLabel];
    
    //history
    CGRect historyRect = CGRectMake(availableSize.width - VIEW_PADDING_X_RIGHT - HISTORY_BUTTON_WIDTH, (availableSize.height - HISTORY_BUTTON_HEIGHT - SEPERATOR_LINE_HEIGHT) / 2.0, HISTORY_BUTTON_WIDTH, HISTORY_BUTTON_HEIGHT);
    groupHistoryButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:historyRect title:nil imageNormal:[UIImage imageNamed:@"common_rtss_launch_logo"] imageHighlighted:nil imageSelected:nil addTarget:self action:@selector(historyButtonClicked:) tag:0];
    [self.contentView addSubview:groupHistoryButton];
    
    //sepeartor
    CGRect seperatorRect = CGRectMake(0.0, availableSize.height - SEPERATOR_LINE_HEIGHT, availableSize.width, SEPERATOR_LINE_HEIGHT);
    groupSeperatorImageView = [[UIImageView alloc] initWithFrame:seperatorRect];
    groupSeperatorImageView.image = [UIImage imageNamed:@"common_separator_line"];
    [self.contentView addSubview:groupSeperatorImageView];
}

#pragma mark button clicked
- (void)historyButtonClicked:(UIButton *)historyButton {
    if (delegate && [delegate respondsToSelector:@selector(budgetGroupCellHistoryButtonDidClicked:)]) {
        [delegate budgetGroupCellHistoryButtonDidClicked:self];
    }
}

#pragma mark others
- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
