//
//  MyFavoritesView.h
//  RTSS
//
//  Created by 宋野 on 15-1-21.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    MyFavoritesViewButtonTypeOne,
    MyFavoritesViewButtonTypeTwo,
    MyFavoritesViewButtonTypeThree,
    MyFavoritesViewButtonTypeFour,
}MyFavoritesViewButtonType;


@interface MyFavoritesViewButtonItem : NSObject
@property (nonatomic ,retain)NSString * bgImage;
@property (nonatomic ,retain)NSString * selectBgImage;
@property (nonatomic ,assign)MyFavoritesViewButtonType tag;
@property (nonatomic ,assign)BOOL needNum;
@end


@protocol MyFavoritesViewDataSource <NSObject>

- (NSInteger)numberOfPerformButtons;

- (MyFavoritesViewButtonItem *)itemOfIndex:(NSInteger)index;

@end

@protocol MyFavoritesViewDelegate <NSObject>

- (void)myFavoritesViewBuyButtonClick;

- (void)myFavoritesViewButtonViewsIndexButtonClick:(NSInteger)index IndexTag:(NSInteger)indexTag;

@end

@interface MyFavoritesView : UIView

@property (nonatomic ,retain)NSString * titleImage;
@property (nonatomic ,retain)NSString * firstTitle;
@property (nonatomic ,retain)NSString * firstTitleContent;
@property (nonatomic ,retain)NSString * contentImage;
@property (nonatomic ,retain)NSString * secondTitle;
@property (nonatomic ,retain)NSString * secondTitleContent;
@property (nonatomic ,retain)NSString * typeImage;
@property (nonatomic ,retain)NSString * type;
@property (nonatomic ,retain)NSString * dateString;

@property (nonatomic ,assign)id<MyFavoritesViewDelegate>delegate;
@property (nonatomic ,assign)id<MyFavoritesViewDataSource>dataSource;


- (void)updateSubViews;

@end
