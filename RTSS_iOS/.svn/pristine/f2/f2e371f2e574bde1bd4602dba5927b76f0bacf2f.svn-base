//
//  SlideOptionsView.h
//  RTSS
//
//  Created by 加富董 on 14/11/26.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionView : UIView

@property (nonatomic,readonly) UIButton *optionButton;
@property (nonatomic,assign) int optionIndex;

- (id)initWithFrame:(CGRect)frame optionTitle:(NSString *)title index:(int)index;

@end

@class SlideOptionsView;

@protocol SlideOptionsViewDelegate <NSObject>

@optional

- (void)slideOptionsView:(SlideOptionsView *)slideView didSelectOptionAtIndex:(int)index;

@end

@interface SlideOptionsView : UIView

//delegate
@property (nonatomic,assign) id <SlideOptionsViewDelegate> delegate;
//所有option view的集合
@property (nonatomic,readonly)NSMutableArray *optionViewsArray;
//option 标题数据源
@property (nonatomic,readonly)NSArray *optionTitlesArr;
//所有indicator 的origin 集合
@property (nonatomic,readonly)NSMutableArray *indicatorOrginsArray;


- (id)initWithFrame:(CGRect)frame optionTiltes:(NSArray *)optionTitles gangedPageWidth:(CGFloat)pageWidth;

- (void)moveToIndex:(int)destIndex callBack:(BOOL)needCallBack;

@end


