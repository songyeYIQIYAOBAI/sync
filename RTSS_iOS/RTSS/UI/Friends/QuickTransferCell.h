//
//  QuickTransferCell.h
//  RTSS
//
//  Created by 加富董 on 14-11-3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickTransferViewController.h"
#import "PortraitImageView.h"

@class User;
@class QuickTransferCell;

@protocol  QuickTransferCellDelegate <NSObject>

@optional

- (void)quickTransferCell:(QuickTransferCell *)cell didClickSelectedButton:(UIButton *)selButton;

@end

@interface QuickTransferCell : UITableViewCell

@property (nonatomic, assign) id <QuickTransferCellDelegate> delegate;
@property (nonatomic, readonly) UIButton *selectButton;
@property (nonatomic, readonly) PortraitImageView *personPortraitImageView;
@property (nonatomic, readonly) UILabel *personNameLable;
@property (nonatomic, readonly) UILabel *personPhoneLable;
@property (nonatomic, assign)   CGSize  cellAvailableSize;
@property (nonatomic, readonly) UIImageView *seperatorLine;
@property (nonatomic, assign) SelectType selectType;
@property (nonatomic, retain) User *userData;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)size selectType:(SelectType)type;

@end


@interface CommonAddFriendsCell : UITableViewCell

@property (nonatomic, retain) UILabel *messageLable;
@property (nonatomic, retain) UIImageView *accessoryImageView;
@property (nonatomic, retain) UIImageView *portraitImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)size;

@end


