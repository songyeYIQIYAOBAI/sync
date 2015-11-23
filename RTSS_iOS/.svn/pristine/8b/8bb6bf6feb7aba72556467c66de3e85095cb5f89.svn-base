//
//  FindCommentCellFrame.m
//  RTSS
//
//  Created by Jaffer on 15/4/2.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "FindCommentCellFrame.h"
#import "CommonUtils.h"
#import "FindCommentCell.h"

#define COMMENT_CELL_PADDING_X_LEFT 10.0
#define COMMENT_CELL_PADDING_X_RIGHT 10.0
#define COMMENT_CELL_PADDING_Y_TOP 8.0

#define COMMENT_CELL_FROM_ICON_WIDTH 40.0
#define COMMENT_CELL_FROM_ICON_HEIGHT 40.0
#define COMMENT_CELL_FROM_ICON_LEFT_SPACE 5.0
#define COMMENT_CELL_FROM_ICON_TOP_SPACE 5.0

#define COMMENT_CELL_FROM_NICK_LABEL_HEIGHT 40.0
#define COMMENT_CELL_FROM_NICK_LABEL_LEFT_SPACE 5.0
#define COMMENT_CELL_FROM_NICK_LABEL_RIGHT_SPACE 5.0
#define COMMENT_CELL_FROM_NICK_LABEL_TOP_SPACE 5.0

#define COMMENT_CELL_DATE_LABEL_HEIGHT 40.0
#define COMMENT_CELL_DATE_LABEL_WIDTH 120.0
#define COMMENT_CELL_DATE_LABEL_RIGHT_SPACE 5.0
#define COMMENT_CELL_DATE_LABEL_TOP_SPACE 5.0

#define COMMENT_CELL_CONTENT_LABEL_LEFT_SPACE 10.0
#define COMMENT_CELL_CONTENT_LABEL_RIGHT_SPACE 10.0
#define COMMENT_CELL_CONTENT_LABEL_TOP_SPACE 10.0
#define COMMENT_CELL_CONTENT_LABEL_DEFAULT_HEIGHT 10.0

#define COMMENT_CELL_SEP_LEFT_SPACE 0.0
#define COMMENT_CELL_SEP_RIGHT_SPACE 0.0
#define COMMENT_CELL_SEP_TOP_SPACE 10.0
#define COMMENT_CELL_SEP_HEIGHT 1.0


@interface FindCommentCellFrame ()

@property (nonatomic, assign) CGFloat cellWidth;

@end

@implementation FindCommentCellFrame

@synthesize commentFromIconRect,commentFromNickRect,commentDateRect;
@synthesize commentContentRect,commentModel,cellWidth;
@synthesize cellHeight,commentSepRect;

#pragma mark dealloc
- (void)dealloc {
    [commentModel release];
    
    [super dealloc];
}

#pragma mark init
- (instancetype)initWithAvailalbeWidth:(CGFloat)width {
    if (self = [super init]) {
        cellWidth = width;
    }
    return self;
}

#pragma mark calculate
- (void)calculateViewFramesByCommentData:(FindItemCommentModel *)comment {
    if (nil == comment || comment == commentModel) {
        return;
    }
    
    [commentModel release];
    commentModel = [comment retain];
    
    commentFromIconRect = CGRectMake(COMMENT_CELL_PADDING_X_LEFT + COMMENT_CELL_FROM_ICON_LEFT_SPACE, COMMENT_CELL_PADDING_Y_TOP + COMMENT_CELL_FROM_ICON_TOP_SPACE, COMMENT_CELL_FROM_ICON_WIDTH, COMMENT_CELL_FROM_ICON_HEIGHT);
    
    commentFromNickRect = CGRectMake(CGRectGetMaxX(commentFromIconRect) + COMMENT_CELL_FROM_NICK_LABEL_LEFT_SPACE, COMMENT_CELL_PADDING_Y_TOP + COMMENT_CELL_FROM_NICK_LABEL_TOP_SPACE, cellWidth - CGRectGetMaxX(commentFromIconRect) - COMMENT_CELL_FROM_NICK_LABEL_LEFT_SPACE - COMMENT_CELL_FROM_NICK_LABEL_RIGHT_SPACE - COMMENT_CELL_DATE_LABEL_WIDTH - COMMENT_CELL_DATE_LABEL_RIGHT_SPACE - COMMENT_CELL_PADDING_X_RIGHT, COMMENT_CELL_FROM_NICK_LABEL_HEIGHT);
    
    commentDateRect = CGRectMake(CGRectGetMaxX(commentFromNickRect) + COMMENT_CELL_FROM_NICK_LABEL_RIGHT_SPACE, COMMENT_CELL_PADDING_Y_TOP + COMMENT_CELL_DATE_LABEL_TOP_SPACE, COMMENT_CELL_DATE_LABEL_WIDTH, COMMENT_CELL_DATE_LABEL_HEIGHT);
    
    CGFloat contentWidth = cellWidth - COMMENT_CELL_PADDING_X_LEFT - COMMENT_CELL_CONTENT_LABEL_LEFT_SPACE - COMMENT_CELL_PADDING_X_RIGHT - COMMENT_CELL_CONTENT_LABEL_RIGHT_SPACE;
    CGSize contentSize = [CommonUtils calculateTextSize:commentModel.commentContent constrainedSize:CGSizeMake(contentWidth, CGFLOAT_MAX) textFont:[UIFont systemFontOfSize:COMMENT_CELL_CONTENT_LABEL_FONT_SIZE] lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat contentHeight = contentSize.height > COMMENT_CELL_CONTENT_LABEL_DEFAULT_HEIGHT ? contentSize.height : COMMENT_CELL_CONTENT_LABEL_DEFAULT_HEIGHT;
    commentContentRect = CGRectMake(COMMENT_CELL_PADDING_X_LEFT + COMMENT_CELL_CONTENT_LABEL_LEFT_SPACE, CGRectGetMaxY(commentFromIconRect) + COMMENT_CELL_CONTENT_LABEL_TOP_SPACE, contentWidth, contentHeight);
    
    CGFloat sepLineWidth = cellWidth - COMMENT_CELL_PADDING_X_LEFT - COMMENT_CELL_PADDING_X_RIGHT - COMMENT_CELL_SEP_LEFT_SPACE - COMMENT_CELL_SEP_RIGHT_SPACE;
    commentSepRect = CGRectMake(COMMENT_CELL_PADDING_X_LEFT + COMMENT_CELL_SEP_LEFT_SPACE, CGRectGetMaxY(commentContentRect) + COMMENT_CELL_SEP_TOP_SPACE, sepLineWidth, COMMENT_CELL_SEP_HEIGHT);

    cellHeight = CGRectGetMaxY(commentSepRect);
}


@end
