//
//  MessageCell.m
//  EasyTT
//
//  Created by 加富董 on 14-10-24.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "MessageCell.h"
#import "CommonUtils.h"
#import "DateUtils.h"
#import "MessageItem.h"
#import "RTSSAppStyle.h"
#import "RTSSAppDefine.h"
#import "MessageBoxViewController.h"
#import "RTSSAppDefine.h"

@interface MessageCell ()

@end

@implementation MessageCell

@synthesize messageCategoryLabel;
@synthesize messageDateLabel;
@synthesize messageContentLabel;
@synthesize seperatorLineImageView;
@synthesize messageModel;
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

#pragma mark init view
- (void)initViews {
    //date label
    CGRect dateLabelRect = CGRectMake(cellAvailableSize.width - VIEW_PADDING_RIGHT_X - DATE_LABEL_WIDTH - ARROW_IMAGE_WIDTH, 8.f, DATE_LABEL_WIDTH, DATE_LABEL_HEIGHT);
    messageDateLabel = [CommonUtils labelWithFrame:dateLabelRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[RTSSAppStyle getRTSSFontWithSize:12.f] tag:0];
    messageDateLabel.backgroundColor = [UIColor clearColor];
    messageDateLabel.numberOfLines = 1;
    messageDateLabel.textAlignment = NSTextAlignmentRight;
    messageDateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:messageDateLabel];
    
    //category label
    CGRect categoryLabelRect = CGRectMake(VIEW_PADDING_LEFT_X, 5.f, cellAvailableSize.width - VIEW_PADDING_LEFT_X - DATE_LABEL_WIDTH - VIEW_PADDING_RIGHT_X - ARROW_IMAGE_WIDTH - VIEW_SPACE_X, CATEGORY_LABEL_HEIGHT);
    messageCategoryLabel = [CommonUtils labelWithFrame:categoryLabelRect text:nil textColor:[RTSSAppStyle currentAppStyle].messageNeverReadTextColor textFont:[RTSSAppStyle getRTSSFontWithSize:16.f] tag:1];
    messageCategoryLabel.backgroundColor = [UIColor clearColor];
    messageCategoryLabel.numberOfLines = 1;
    messageCategoryLabel.textAlignment = NSTextAlignmentLeft;
    messageCategoryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:messageCategoryLabel];
    
    //content label
    CGFloat availableWidth = cellAvailableSize.width - VIEW_PADDING_LEFT_X - VIEW_PADDING_RIGHT_X - ARROW_IMAGE_WIDTH + 5.f;
    CGRect contentLabelRect = CGRectMake(VIEW_PADDING_LEFT_X, CGRectGetMaxY(messageCategoryLabel.frame) + 3.f, availableWidth, CONTENT_LABEL_SINGLE_HEIGHT);
    messageContentLabel = [CommonUtils labelWithFrame:contentLabelRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[RTSSAppStyle getRTSSFontWithSize:12.f] tag:2];
    messageContentLabel.backgroundColor = [UIColor clearColor];
    messageContentLabel.numberOfLines = 1;
    messageContentLabel.textAlignment = NSTextAlignmentLeft;
    messageContentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    messageContentLabel.numberOfLines = 0;
    [self.contentView addSubview:messageContentLabel];
    
    //arrow image
    UIImageView *arrowimage = [[UIImageView alloc] initWithFrame:CGRectMake(cellAvailableSize.width - VIEW_PADDING_RIGHT_X - ARROW_IMAGE_WIDTH, 5.f, ARROW_IMAGE_WIDTH, ARROW_IMAGE_HEIGHT)];
    arrowimage.image = [UIImage imageNamed:@"common_next_arrow2"];
    [self.contentView addSubview:arrowimage];
    [arrowimage release];
    
    //seperator line
    CGRect seperateRect = CGRectMake(0.f, MESSAGE_CELL_HEIGHT - SEPERATOR_LINE_HEIGHT, cellAvailableSize.width, SEPERATOR_LINE_HEIGHT);
    seperatorLineImageView = [[UIImageView alloc] initWithFrame:seperateRect];
    seperatorLineImageView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
//    seperatorLineImageView.image = [UIImage imageNamed:@"common_separator_line"];
    [self.contentView addSubview:seperatorLineImageView];
}

- (void)layoutSubviewsByMessageData:(MessageItem *)messageData showSeperateLine:(BOOL)show
{
    if (!messageData) {
        return;
    }
    self.messageModel = messageData;
    
    //category label
    BOOL haveRead = messageModel.mHasRead;
    if (haveRead) {
        // 阅读过的颜色
        messageCategoryLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    } else {
        // 从未阅读的颜色
        messageCategoryLabel.textColor = [RTSSAppStyle currentAppStyle].messageNeverReadTextColor;
    }
    messageCategoryLabel.text = messageModel.mTitle;
    
    //date label
    messageDateLabel.text = [DateUtils getStringDateByDate:[NSDate dateWithTimeIntervalSince1970:messageModel.mTimeStamp/1000]];
    
    //content label
    messageContentLabel.text = messageModel.mContent;
    CGFloat availableWidth = cellAvailableSize.width - VIEW_PADDING_LEFT_X - VIEW_PADDING_RIGHT_X - ARROW_IMAGE_WIDTH + 5.f;
    CGSize textSize = CGSizeZero;
    
    if (SYSTEM_VERSION_FLOAT >= 7.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:[RTSSAppStyle getRTSSFontWithSize:12.0f],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        textSize = [messageModel.mContent boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CONTENT_LABEL_SINGLE_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
#else
        textSize = [abstractText sizeWithFont:[RTSSAppStyle getRTSSFontWithSize:12.0f] constrainedToSize:CGSizeMake(CGFLOAT_MAX, CONTENT_LABEL_SINGLE_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
#endif
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
        textSize = [abstractText sizeWithFont:[RTSSAppStyle getRTSSFontWithSize:12.0f] constrainedToSize:CGSizeMake(CGFLOAT_MAX, CONTENT_LABEL_SINGLE_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
#endif
    }
    CGRect textFrame = messageContentLabel.frame;
    if (textSize.width > availableWidth) {
        textFrame.size.height = CONTENT_LABEL_DOUBLE_HEIGHT;
        messageContentLabel.frame = textFrame;
    } else {
        textFrame.size.height = CONTENT_LABEL_SINGLE_HEIGHT;
        messageContentLabel.frame = textFrame;
    }
    
    //seperate
    seperatorLineImageView.hidden = show ? NO : YES;
}

#pragma mark dealloc
- (void)dealloc {
    self.seperatorLineImageView = nil;
    self.messageModel = nil;
    [super dealloc];
}

@end
