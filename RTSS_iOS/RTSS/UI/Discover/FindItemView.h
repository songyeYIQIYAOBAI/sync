//
//  FindItemView.h
//  SJB2
//
//  Created by shengyp on 14-5-19.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindItemModel.h"

#define FindItemDescFont						[UIFont systemFontOfSize:14.0]

typedef NS_ENUM(NSInteger, ActionOptionType) {
    ActionOptionTypeComment = 1,
    ActionOptionTypeShare,
    ActionOptionTypePraise,
    ActionOptionTypeCollect
};

@interface TagButton : UIButton

@property (nonatomic, retain) FindTagModel *tagModel;

@end



@interface ActionOptionView : UIView

@property (nonatomic, readonly) UIButton *actionButton;
@property (nonatomic, readonly) UILabel *valueLabel;
@property (nonatomic, readonly) UIImageView *iconImageView;
@property (nonatomic, readonly) ActionOptionType actionType;
@property (nonatomic, retain, setter=setValue:) NSString *value;

@end



@interface ActionsPanelView : UIView

@property (nonatomic, readonly) ActionOptionView *commentView;
@property (nonatomic, readonly) ActionOptionView *shareView;
@property (nonatomic, readonly) ActionOptionView *praiseView;
@property (nonatomic, readonly) ActionOptionView *collectView;

@end



@class FindItemModel;
@interface FindItemView : UIView


@property(nonatomic, retain)UIImageView* itemIconImageView;
@property(nonatomic, retain)UIImageView* itemPicImageView;

@property(nonatomic, retain)UILabel* itemNameLabel;
@property(nonatomic, retain)UILabel* itemDateLabel;
@property(nonatomic, retain)UILabel* itemTitleLabel;

@property(nonatomic, retain)UITextView* itemDescriptionTextView;
@property(nonatomic, retain)UIButton* itemTypeButton;

@property (nonatomic, retain) UIImageView *itemTagImageView;
@property (nonatomic, retain) UIView *itemTagsView;
@property (nonatomic, retain) UIImageView *itemSepLineImageView;
@property (nonatomic, retain) ActionsPanelView *itemActionsPanelView;

@end
