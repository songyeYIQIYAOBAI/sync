//
//  MessageCell.h
//  EasyTT
//
//  Created by 加富董 on 14-10-24.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import <UIKit/UIKit.h>

#define VIEW_PADDING_LEFT_X 10.f
#define VIEW_PADDING_RIGHT_X 5.f
#define VIEW_SPACE_X 5.f

#define DATE_LABEL_WIDTH 70.f
#define DATE_LABEL_HEIGHT 15.f

#define ARROW_IMAGE_WIDTH 20.f
#define ARROW_IMAGE_HEIGHT 20.f

#define CATEGORY_LABEL_HEIGHT 20.f

#define CONTENT_LABEL_SINGLE_HEIGHT 16.f
#define CONTENT_LABEL_DOUBLE_HEIGHT 32.f

@class MessageItem;

@interface MessageCell : UITableViewCell

@property (nonatomic,retain) UILabel *messageCategoryLabel;
@property (nonatomic,retain) UILabel *messageDateLabel;
@property (nonatomic,retain) UILabel *messageContentLabel;
@property (nonatomic,retain) UIImageView  *seperatorLineImageView;
@property (nonatomic,retain) MessageItem *messageModel;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) CGSize cellAvailableSize;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)size;

- (void)layoutSubviewsByMessageData:(MessageItem *)messageData showSeperateLine:(BOOL)show;

@end
