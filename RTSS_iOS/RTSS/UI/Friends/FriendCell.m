//
//  FriendCell.m
//  RTSS
//
//  Created by 加富董 on 14-10-28.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "FriendCell.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"
#import "PortraitImageView.h"
#import "RTSSAppDefine.h"

#define VIEW_PADDING_X 20.f
#define VIEW_PADDING_Y 10.f
#define VIEW_SPACE_X 5.f
#define PORTRAIT_WIDTH 40.f
#define PORTRAIT_HEIGHT 40.f
#define INDEX_VIEW_WIDTH 10.f

@interface FriendCell ()

@end

@implementation FriendCell

@synthesize friendPortraitImageView;
@synthesize friendNameLabel;
@synthesize seperatorLineImageView;
@synthesize cellAvailableSize;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)size
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cellAvailableSize = size;
        [self initViews];
    }
    return self;
}

#pragma mark init views
- (void)initViews {
    //portrait
    CGRect portraitRect = CGRectMake(VIEW_PADDING_X, (cellAvailableSize.height - PORTRAIT_HEIGHT) / 2.f, PORTRAIT_WIDTH, PORTRAIT_HEIGHT);
    friendPortraitImageView = [[PortraitImageView alloc] initWithFrame:portraitRect image:[UIImage imageNamed:@"friends_default_icon"] borderColor:[[RTSSAppStyle currentAppStyle] portraitBorderColor] borderWidth:1.f];
    friendPortraitImageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:friendPortraitImageView];
    
    //name
    CGRect nameLabelRect = CGRectMake(CGRectGetMaxX(friendPortraitImageView.frame) + VIEW_SPACE_X, VIEW_PADDING_Y, cellAvailableSize.width - CGRectGetMaxX(friendPortraitImageView.frame) - VIEW_SPACE_X - INDEX_VIEW_WIDTH, cellAvailableSize.height - VIEW_PADDING_Y * 2.f);
    friendNameLabel = [CommonUtils labelWithFrame:nameLabelRect text:nil textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[UIFont systemFontOfSize:16.f] tag:0];
    friendNameLabel.backgroundColor = [UIColor clearColor];
    friendNameLabel.textAlignment = NSTextAlignmentLeft;
    friendNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:friendNameLabel];
    
    //seperator line
    CGRect seperatorRect = CGRectMake(0.f, cellAvailableSize.height - SEPERATOR_LINE_HEIGHT, cellAvailableSize.width, SEPERATOR_LINE_HEIGHT);
    seperatorLineImageView = [[UIImageView alloc] initWithFrame:seperatorRect];
    seperatorLineImageView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self.contentView addSubview:seperatorLineImageView];
}

#pragma mark dealloc
- (void)dealloc {
    [friendPortraitImageView release];
    [seperatorLineImageView release];
    [super dealloc];
}

@end
