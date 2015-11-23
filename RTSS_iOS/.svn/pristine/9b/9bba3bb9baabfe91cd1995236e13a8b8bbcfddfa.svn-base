//
//  HomeView.h
//  RTSS
//
//  Created by shengyp on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HomeGridViewIndex){
    HomeGridViewIndexDefault,
    HomeGridViewIndexUsageOverView,
    HomeGridViewIndexUsageExplore,
    HomeGridViewIndexUsageData,
    HomeGridViewIndexQuickOrder,
    HomeGridViewIndexTurboBoost,
    HomeGridViewIndexTransfer,
    HomeGridViewIndexTransform,
    HomeGridViewIndexWallet,
    HomeGridViewIndexBudgetControl,
    HomeGridViewIndexDiscovery,
    HomeGridViewIndexMessages,
    HomeGridViewIndexCustomerSupport,
    HomeGridViewIndexServiceRequest,
    HomeGridViewIndexSettings,
};

#pragma mark ========导航条目
@class PortraitImageView;
@interface HomeNavigationBar : UIView

@property(nonatomic, readonly) UIImageView*            logoImageView;
@property(nonatomic, readonly) PortraitImageView*      portraitImageView;

- (void)showHomeNavigationBar;

- (void)dismissHomeNavigationBar;

@end

#pragma mark ========宫格样式
@interface HomeGridStyle : NSObject

@property(nonatomic,assign)CGFloat gridItemWidth;
@property(nonatomic,assign)CGFloat gridItemHeight;
@property(nonatomic,assign)CGFloat gridItemIconWidth;
@property(nonatomic,assign)CGFloat gridItemIconHeight;
@property(nonatomic,assign)CGFloat gridItemTextHeight;
@property(nonatomic,assign)CGFloat gridItemX_SP;
@property(nonatomic,assign)CGFloat gridItemY_SP;
@property(nonatomic,assign)CGFloat gridItemX_H;
@property(nonatomic,assign)CGFloat gridItemY_H;
@property(nonatomic,assign)CGFloat gridItemSeparatorSize;

@property(nonatomic,assign)NSUInteger rowCount;
@property(nonatomic,assign)NSUInteger columnCount;

+(HomeGridStyle*)defaultStyle;

@end

#pragma mark ========一个宫格视图
@class HomeGridItemView;
@protocol HomeGridItemViewDelegate <NSObject>

@optional
- (void)homeGridItemView:(HomeGridItemView*)itemView selectedIndex:(HomeGridViewIndex)index;

@end

@interface HomeGridItemView : UIView

@property(nonatomic, readonly) UIButton*            gridItemButton;
@property(nonatomic, readonly) UIImageView*         gridItemImageView;
@property(nonatomic, readonly) UILabel*             gridItemLabel;
@property(nonatomic, readonly) UIView*              gridItemBottomSeparatorView;
@property(nonatomic, readonly) UIView*              gridItemRightSeparatorView;

@property(nonatomic, assign, setter=setGridItemBottomSeparator:) BOOL isBottomSeparator;
@property(nonatomic, assign, setter=setGridItemRightSeparator:) BOOL isRightSeparator;

@property(nonatomic, assign) HomeGridViewIndex gridItemIndexTag;
@property(nonatomic, assign) id<HomeGridItemViewDelegate> delegate;

@property(nonatomic, retain) HomeGridStyle* gridItemStyle;

- (void)setHomeGridItemFrame:(CGRect)frame style:(HomeGridStyle*)gridStyle;

+ (NSNumber*)getHomeGridItemIndexTagByString:(NSString*)string;

+ (HomeGridItemView*)layoutHomeGridItemView:(HomeGridViewIndex)gridViewIndex delegate:(id)aDelegate;

@end

#pragma mark ========多个宫格组合视图
@interface HomeGridView : UIView

- (void)addGridItemView:(HomeGridItemView*)gridItemView;

- (void)loadHomeGridView;

- (HomeGridItemView*)getHomeGridItemViewWithIndex:(HomeGridViewIndex)gridViewIndex;

@end

#pragma mark ========一页菜单视图
@interface HomeMenuView : UIView

@property (nonatomic, readonly)HomeGridView* gridView;

@end

#pragma mark ========主页视图
@protocol HomeViewDelegate;
@interface HomeView : UIView

@property(nonatomic, readonly) UIPageControl* homePageControl;

@property(nonatomic, assign) id<HomeViewDelegate> delegate;

- (void)addPageView:(UIView*)pageView;
- (void)addPageArrayView:(NSArray*)pageViews;

- (void)removeAllPageView;

- (void)scrollEnabled:(BOOL)enabled;

- (void)loadHomeView;

- (void)loadHomeViewWithIndex:(NSInteger)index;

- (HomeGridItemView*)getHomeGridItemViewWithIndex:(HomeGridViewIndex)itemGridViewIndex;

@end

@protocol HomeViewDelegate <NSObject>

@optional

- (void)homeView:(HomeView *)homeView viewWillAppear:(NSInteger)viewIndex;
- (void)homeView:(HomeView *)homeView viewDisappear:(NSInteger)viewIndex;

@end
