//
//  UserInfoComponentView.h
//  EasyTT
//
//  Created by shengyp on 14-10-10.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UserInfoItemViewStyle) {
	UserInfoItemViewStyleDefault,
	UserInfoItemViewStyleButton,
    UserInfoItemViewStyleTextFieldIn,
    UserInfoItemViewStyleTextFieldOut,
    UserInfoItemViewStyleTextFieldInWithButton,
    UserInfoItemViewStyleTextFieldOutWithButton,
};

typedef NS_ENUM(NSInteger, UserInfoComponentViewType) {
	UserInfoComponentViewTypeLogin,
	UserInfoComponentViewTypeForgotUserID,
    UserInfoComponentViewTypeForgotOTP,
	UserInfoComponentViewTypeModifPw,
    UserInfoComponentViewTypeRequestOTP,
    UserInfoComponentViewTypeActivation
};

@interface TimerButton : UIButton

- (void)start;

- (void)start:(NSString*)title resend:(NSString*)resendTitle;

- (BOOL)isStart;

- (void)stop;

- (void)stop:(NSString*)resendTitle;

@end

@interface UserInfoItemView : UIView
{
	UIImageView* spaceLineView;
}

@property(nonatomic, assign)UserInfoItemViewStyle currentStyle;

@property(nonatomic, readonly) UILabel*         itemTitleLabel;
@property(nonatomic, readonly) UILabel*         itemValueLabel;
@property(nonatomic, readonly) UILabel*         itemErrorLabel;
@property(nonatomic, readonly) UITextField*     itemTextField;
@property(nonatomic, readonly) UIButton*        itemButton;
@property(nonatomic, readonly) UIButton*        itemHelpButton;

@property(nonatomic, readonly) BOOL             expanding;

@property(nonatomic, assign, setter=setItemSeparateImage:)UIImage* itemSeparateImage;

@property(nonatomic, assign, setter=setSeparate:)BOOL isSeparate;

@property(nonatomic, assign, setter=setItemTitleText:) NSString* itemTitleText;

- (id)initWithFrame:(CGRect)frame style:(UserInfoItemViewStyle)style;

- (void)refreshItemViewFrame;

@end

@interface UserInfoComponentView : UIView

@property(nonatomic, readonly)UserInfoItemView* userNameItemView;
@property(nonatomic, readonly)UserInfoItemView* pwItemView;
@property(nonatomic, readonly)UserInfoItemView* mdnItemView;
@property(nonatomic, readonly)UserInfoItemView* otpItemView;

@property(nonatomic, readonly)UserInfoItemView* oldPwItemView;
@property(nonatomic, readonly)UserInfoItemView* lastPwItemView;
@property(nonatomic, readonly)UserInfoItemView* confirmPwItemView;

@property(nonatomic, assign)UserInfoComponentViewType currentType;

- (id)initWithFrame:(CGRect)frame type:(UserInfoComponentViewType)type;

- (void)refreshInfoComponentView:(UserInfoItemView*)itemView completion:(void (^)(BOOL finished))completion;

- (BOOL)showUserInfoComponentKeyboard;

- (BOOL)dismissUserInfoComponentKeyboard;

@end
