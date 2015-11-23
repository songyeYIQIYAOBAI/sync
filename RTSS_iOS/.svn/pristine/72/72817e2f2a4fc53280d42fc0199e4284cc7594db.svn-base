//
//  HomeBottleView.h
//  RTSS
//
//  Created by shengyp on 14/10/29.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QuadCurveMenuIndex){
    QuadCurveMenuIndexDefault=-1,
    QuadCurveMenuIndexTransfer,
    QuadCurveMenuIndexReceive,
    QuadCurveMenuIndexHistory
};

@class LabelNumberJump;
@interface HomeBottleMarkView : UIView

// 当前资源名称
@property(nonatomic, readonly)UILabel*                      currentSourceNameLabel;
// 当前资源ID
@property(nonatomic, readonly)UILabel*                      currentSourceIdLabel;
// 当前剩余标签
@property(nonatomic, readonly)UILabel*                      currentRemainingLabel;
// 当前剩余值
@property(nonatomic, readonly)LabelNumberJump*              currentRemainingValueLabel;

@end

@interface TransferRuleView: UIView

// 点击事件
@property(nonatomic, readonly)UIButton*             actionButton;
// 编辑的图片
@property(nonatomic, readonly)UIImageView*          editedImageView;
// 数量
@property(nonatomic, readonly, retain)UILabel*      transferNumberLabel;
// 提示
@property(nonatomic, readonly, retain)UILabel*      transferTitleLabel;

// 设置转赠数量和标题
- (void)setTransferRuleNumber:(NSString*)number editedImage:(UIImage*)edited title:(NSString*)title;
// 更新转赠数量
- (void)updateTransferRuleNumber:(NSString*)number;
// 移除转赠显示
- (void)removeTransferRuleNumber;

@end

@class QuadCurveMenu;
@class QuadCurveMenuItem;
@class PortraitImageView;
@interface HomeMarkView : UIView

// 圆形菜单
@property(nonatomic, readonly) QuadCurveMenu*               quadCurveMenu;
@property(nonatomic, readonly) QuadCurveMenuItem*           transferMenuItem;
@property(nonatomic, readonly) QuadCurveMenuItem*           receiveMenuItem;
@property(nonatomic, readonly) QuadCurveMenuItem*           historyMenuItem;

// 当前资源显示
@property(nonatomic, readonly) UILabel*                     resourceNameLabel;
@property(nonatomic, readonly) UILabel*                     resourceValueLabel;
// 瓶子刻度标记
@property(nonatomic, readonly) HomeBottleMarkView*          bottleMarkView;
// 转换规则提示
@property(nonatomic, readonly) TransferRuleView*            transferRuleView;

@end

@class BottleView;
@interface HomeDisplayView : UIView

// 显示图层 包括(瓶子,瓶颈,瓶盖,瓶水,标记图层(菜单,标题图片,头像,瓶子水的位置标记,当前套餐显示))
@property(nonatomic, readonly) HomeMarkView*                homeMarkView;
// 瓶子
@property(nonatomic, readonly) BottleView*                  bottleView;
// 瓶颈
@property(nonatomic, readonly) UIImageView*                 bottleneckImageView;
// 瓶盖
@property(nonatomic, readonly) UIImageView*                 bottlecapImageView;
// 瓶子点击
@property(nonatomic, readonly) UIButton*                    homeBottleButton;

// 打开瓶盖
- (void)openBottleCap;
// 关闭瓶盖
- (void)closeBottleCap;
// 播放倒水声音
- (void)playOpenPouringAudio;
// 停止倒水声音
- (void)stopOpenPouringAudio;
// 标记图层显示
- (void)showHomeMarkView;
// 标记图层消失
- (void)dismissHomeMarkView;
// 更新瓶子水位(animated is YES,水位是从没有到满瓶，在下降到当前值. animated is NO,水位直接到当前值)
- (void)updateBottleVolume:(CGFloat)percent animated:(BOOL)animated;

@end

@interface HomePouringOutView : UIView

// 初始化出水图层，根据方向
- (instancetype)initWithFrame:(CGRect)frame direction:(NSInteger)direction;
// 更新出水水颜色
- (void)updateEmitterCellColor:(UIColor*)color;

@end

@interface HomePouringInView : UIView

// 初始化出水图层，根据方向
- (instancetype)initWithFrame:(CGRect)frame direction:(NSInteger)direction;
// 更新进水水颜色
- (void)updateEmitterCellColor:(UIColor*)color;

@end

@interface HomePouringOutViewGroup : UIView

// 左右方向倒水图层
@property(nonatomic, readonly) HomePouringOutView*      leftHomePouringOutView;
@property(nonatomic, readonly) HomePouringOutView*      rightHomePouringOutView;

@property(nonatomic, assign, setter=setHiddenLeft:) BOOL    isHiddenLeft;
@property(nonatomic, assign, setter=setHiddenRight:) BOOL   isHiddenRight;

- (void)addHomePouringOutView;
- (void)removeHomePouringOutView;

@end

@interface HomePouringInViewGroup : UIView

// 左右方向进水图层
@property(nonatomic, readonly) HomePouringInView*       rightHomePouringInView;

- (void)addHomePouringInView;
- (void)removeHomePouringInView;

@end

@interface HomeBottleView : UIView

// 显示图层 包括(瓶子,瓶盖,瓶水,标记图层(菜单,标题图片,头像,瓶子水的位置标记,当前套餐显示))
@property(nonatomic, readonly) HomeDisplayView*             homeDisplayView;

// 倒水图层 包括(左方向粒子图层,右方向粒子图层)
@property(nonatomic, readonly) HomePouringOutViewGroup*     homePouringOutViewGroup;

// 注水图层 包括(注水方向粒子图层)
@property(nonatomic, readonly) HomePouringInViewGroup*      homePouringInViewGroup;

@end
