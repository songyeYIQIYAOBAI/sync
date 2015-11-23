//
//  QuickTransferCell.m
//  RTSS
//
//  Created by 加富董 on 14-11-3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "QuickTransferCell.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"
#import "PortraitImageView.h"
#import "User.h"
#import "Cache.h"

#pragma mark --
#pragma mark QuickTransferCell class
#pragma mark --

#define VIEW_PADDING_X 20.f
#define VIEW_PADDING_Y 10.f
#define VIEW_SPACE_X 5.f
#define VIEW_SPACE_Y 0.f
#define CELL_HEIGHT 51.f
#define PORTRAIT_WIDTH 40.f
#define PORTRAIT_HEIGHT 40.f
#define CELL_LABEL_HEIGHT 16.f
#define SELECT_BUTTON_PADDING_X 5.f
#define SELECT_BUTTON_WIDTH 32.f
#define SELECT_BUTTON_HEIGHT 32.f

@implementation QuickTransferCell

@synthesize delegate;
@synthesize selectButton;
@synthesize personPortraitImageView;
@synthesize personNameLable;
@synthesize personPhoneLable;
@synthesize cellAvailableSize;
@synthesize seperatorLine;
@synthesize selectType;
@synthesize userData;

#pragma mark dealloc
- (void)dealloc {
    [personPortraitImageView release];
    [seperatorLine release];
    [userData release];
    [super dealloc];
}

#pragma mark init views
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)size selectType:(SelectType)type {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        selectType = type;
        cellAvailableSize = size;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    //protrait
    personPortraitImageView = [[PortraitImageView alloc] initWithFrame:CGRectMake(VIEW_PADDING_X, (cellAvailableSize.height - PORTRAIT_HEIGHT) / 2.f, PORTRAIT_WIDTH, PORTRAIT_HEIGHT) image:[UIImage imageNamed:@"friends_default_icon"] borderColor:[[RTSSAppStyle currentAppStyle] portraitBorderColor] borderWidth:1.f];
    personPortraitImageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:personPortraitImageView];
    
    //select button
    if (selectType == SelectTypeByMultiple) {
        CGRect buttonRect = CGRectMake(cellAvailableSize.width - SELECT_BUTTON_PADDING_X - SELECT_BUTTON_WIDTH, (cellAvailableSize.height - SEPERATOR_LINE_HEIGHT - SELECT_BUTTON_HEIGHT) / 2.f , SELECT_BUTTON_WIDTH,SELECT_BUTTON_HEIGHT);
        selectButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:buttonRect title:nil imageNormal:[UIImage imageNamed:@"common_checked_d.png"] imageHighlighted:nil imageSelected:[UIImage imageNamed:@"common_checked_a.png"] addTarget:self action:@selector(selectButtonClicked:) tag:0];
        [self.contentView addSubview:selectButton];
    }
    
    //name
    CGFloat selectViewOccupyWidth = selectType == SelectTypeByMultiple ? SELECT_BUTTON_WIDTH + SELECT_BUTTON_PADDING_X + VIEW_SPACE_X : 0.f;
    CGRect nameLabelRect = CGRectMake(CGRectGetMaxX(personPortraitImageView.frame) + VIEW_SPACE_X, VIEW_PADDING_Y, cellAvailableSize.width - CGRectGetMaxX(personPortraitImageView.frame)- VIEW_SPACE_X - selectViewOccupyWidth, CELL_LABEL_HEIGHT);
    personNameLable = [CommonUtils labelWithFrame:nameLabelRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[UIFont systemFontOfSize:14.f] tag:0];
    personNameLable.backgroundColor = [UIColor clearColor];
    personNameLable.textAlignment = NSTextAlignmentLeft;
    personNameLable.lineBreakMode = NSLineBreakByTruncatingTail;
    personNameLable.numberOfLines = 1;
    [self.contentView addSubview:personNameLable];
        
    //phone
    CGRect phoneNumRect = CGRectMake(CGRectGetMinX(nameLabelRect), CGRectGetMaxY(nameLabelRect) + VIEW_SPACE_Y, CGRectGetWidth(nameLabelRect), CGRectGetHeight(nameLabelRect));
    personPhoneLable = [CommonUtils labelWithFrame:phoneNumRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[UIFont systemFontOfSize:14.f] tag:0];
    personPhoneLable.backgroundColor = [UIColor clearColor];
    personPhoneLable.textAlignment = NSTextAlignmentLeft;
    personPhoneLable.lineBreakMode = NSLineBreakByTruncatingTail;
    personPhoneLable.numberOfLines = 1;
    [self.contentView addSubview:personPhoneLable];
    
    /*横向并列
    //name
    CGRect nameLabelRect = CGRectMake(CGRectGetMaxX(personPortraitImageView.frame) + VIEW_SPACE_X, (cellAvailableSize.height - CELL_LABEL_HEIGHT) / 2.f, cellAvailableSize.width - CGRectGetMaxX(personPortraitImageView.frame)- VIEW_SPACE_X, CELL_LABEL_HEIGHT);
    personNameLable = [CommonUtils labelWithFrame:nameLabelRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[UIFont systemFontOfSize:16.f] tag:0];
    personNameLable.backgroundColor = [UIColor clearColor];
    personNameLable.textAlignment = NSTextAlignmentLeft;
    personNameLable.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:personNameLable];
    
    //phone
    CGRect phoneNumRect = CGRectMake(CGRectGetMinX(nameLabelRect), (cellAvailableSize.height - CELL_LABEL_HEIGHT) / 2.f, CGRectGetWidth(nameLabelRect) - VIEW_PADDING_X, CGRectGetHeight(nameLabelRect));
    personPhoneLable = [CommonUtils labelWithFrame:phoneNumRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[UIFont systemFontOfSize:12.f] tag:0];
    personPhoneLable.backgroundColor = [UIColor clearColor];
    personPhoneLable.textAlignment = NSTextAlignmentRight;
    personPhoneLable.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:personPhoneLable];
    */

    //seperator line
    seperatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, cellAvailableSize.height - SEPERATOR_LINE_HEIGHT, cellAvailableSize.width, SEPERATOR_LINE_HEIGHT)];
    seperatorLine.image = [UIImage imageNamed:@"common_separator_line"];
    [self.contentView addSubview:seperatorLine];
}

#pragma mark button clicked
- (void)selectButtonClicked:(UIButton *)button {
    button.selected = !button.selected;
    if (delegate && [delegate conformsToProtocol:@protocol(QuickTransferCellDelegate)] && [delegate respondsToSelector:@selector(quickTransferCell:didClickSelectedButton:)]) {
        [delegate quickTransferCell:self didClickSelectedButton:selectButton];
    }
}

@end

#pragma mark --
#pragma mark CommonAddFriendsCell class
#pragma mark --

#define ACCESSORY_IMAGEVIEW_WIDTH 20.f
#define ACCESSORY_IMAGEVIEW_HEIGHT 20.f

@interface CommonAddFriendsCell () {
    CGSize        cellAvailableSize;
}

@end

@implementation CommonAddFriendsCell

@synthesize messageLable;
@synthesize accessoryImageView;
@synthesize portraitImageView;

#pragma mark init views
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)size {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cellAvailableSize = size;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    //portrait
    portraitImageView = [[PortraitImageView alloc] initWithFrame:CGRectMake(VIEW_PADDING_X, (cellAvailableSize.height - PORTRAIT_HEIGHT) / 2.f, PORTRAIT_WIDTH, PORTRAIT_HEIGHT) image:nil borderColor:[[RTSSAppStyle currentAppStyle] portraitBorderColor] borderWidth:1.f];
    portraitImageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:portraitImageView];
    
    //text label
    CGRect labelRect = CGRectMake(CGRectGetMaxX(portraitImageView.frame) + VIEW_SPACE_X, 0.f, cellAvailableSize.width - CGRectGetMaxX(portraitImageView.frame) - VIEW_PADDING_X - ACCESSORY_IMAGEVIEW_WIDTH - VIEW_SPACE_X - 5.f ,cellAvailableSize.height);
    messageLable = [CommonUtils labelWithFrame:labelRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[UIFont systemFontOfSize:16.f] tag:0];
    messageLable.backgroundColor = [UIColor clearColor];
    messageLable.textAlignment = NSTextAlignmentLeft;
    messageLable.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:messageLable];
    
    //accessory image
    accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(messageLable.frame) + 10.f, (cellAvailableSize.height - ACCESSORY_IMAGEVIEW_HEIGHT) / 2.f, ACCESSORY_IMAGEVIEW_WIDTH, ACCESSORY_IMAGEVIEW_HEIGHT)];
    [self.contentView addSubview:accessoryImageView];
    
    //seperator line
    UIImageView *seperatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, cellAvailableSize.height - 1.f, cellAvailableSize.width, 1.f)];
    seperatorLine.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self.contentView addSubview:seperatorLine];
    [seperatorLine release];
}

#pragma mark dealloc
- (void)dealloc {
    [accessoryImageView release];
    [portraitImageView release];
    [super dealloc];
}

@end











