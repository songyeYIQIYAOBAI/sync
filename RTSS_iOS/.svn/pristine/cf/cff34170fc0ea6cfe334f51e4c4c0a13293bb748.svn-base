//
//  TextInputView.h
//  RTSS
//
//  Created by Liuxs on 15-2-7.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerSuperView : UIView

@property (nonatomic, retain) UIPickerView       *pickerView;
@property (nonatomic, retain) UINavigationBar    *pickerDateToolbar;
@property (nonatomic, retain) NSArray            *mDataSource;
@property (nonatomic, assign) id                delegate;

- (instancetype)initWithFrame:(CGRect)frame target:(id)delegate;
- (void)pickerReloadAllComponents:(NSArray *)dataSource;
-(void)toolBarCanelClick:(id)sender;
-(void)toolBarDoneClick:(id)sender;

@end



@protocol BallImageViewDelegate <NSObject>

- (void)tap:(UITapGestureRecognizer *)recognizer;
- (void)pannedGesture:(UIPanGestureRecognizer*)gesture;

@end


@interface BallImageView : UIImageView

@property (nonatomic, retain) UILabel                   *mTitleLabel;
@property (nonatomic, retain) UILabel                   *mIconNumberLabel;
@property(nonatomic, retain) UIDynamicAnimator*         dynamicAnimator;
@property(nonatomic, retain) UIGravityBehavior*         gravityBehavior;
@property(nonatomic, retain) UICollisionBehavior*       collisionBehavior;
@property(nonatomic, retain) UIAttachmentBehavior*      suspendBehavior;
@property(nonatomic, retain) UIAttachmentBehavior*      touchBehavior;
@property(nonatomic, retain) UIDynamicItemBehavior*     itemBehavior;
@property(nonatomic, assign) CGPoint                    portraitPoint;
@property (nonatomic, retain) UIColor        *borderColor;
@property (nonatomic, assign) id<BallImageViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)image withReferenceView:(UIView *)view;

- (void)layoutTitleLabelWithFrame:(CGRect)frame title:(NSString *)text textFont:(UIFont *)font;

- (void)initAnimation;
- (void)GestureRecognizerStateBegan;
- (void)removeTouchBehavior;
- (void)removeAllBehaviors;
- (void)startItemBehavior;
- (void)startSuspendBehavior;
- (void)setFrame:(CGRect)newFrame;

@end

typedef NS_ENUM(NSInteger, SupportBallType) {
    SupportBallTypeEmail = 1,
    SupportBallTypeRequestCall,
    SupportBallTypeLiveChat,
    SupportBallTypeCallUs,
    SupportBallTypeVideoChat
};
@protocol BallViewDelegate <NSObject>


// 移动到logo完成
- (void)jumpToLogoAnimationCompletion:(SupportBallType)buttonTag;
// 小球朝屏幕中间移动实现方法（页面跳转），使导航栏返回按钮失效
- (void)isLeftBarButtonItemEnabled:(BOOL)isEnabled;
@end


@interface BallView : UIView<UIDynamicAnimatorDelegate>

@property (nonatomic, retain) UIDynamicAnimator*         dynamicAnimator;

@property (nonatomic, assign) id<BallViewDelegate>   delegate;

- (void)initAnimation;

- (id)initWithFrame:(CGRect)frame;

@end


typedef NS_ENUM(NSInteger, TextInputType) {
    TextInputTypePicker = 1,
    TextInputTypeInput,
    TextInputTypeButton
};

@protocol TextInputViewDelegate <NSObject>

- (void)submitButtonClick:(UIButton *)button;

@end


@interface TextInputView : UIView

@property (nonatomic, assign) TextInputType             textType;
@property (nonatomic, assign) id<TextInputViewDelegate> delegate;
@property (nonatomic, retain) UITextField               *textField;
@property (nonatomic, retain) UIButton                  *sendButton;

- (instancetype)initWithFrame:(CGRect)frame Type:(TextInputType)type target:(id)delegate Color:(UIColor *)color placeholder:(NSString *)placeholder ReturnKeyType:(UIReturnKeyType)returnKeyType;

@end


