//
//  SYScrollView.h
//  animationDemo
//
//  Created by Dragon on 15/9/11.
//  Copyright (c) 2015年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYScrollViewProtocol.h"

typedef void(^SYScrollViewTapContentViewIndexFinishedBlock)(NSInteger index);


@interface SYScrollView : UIView

/***
 是否支持自动滚动    以及多长时间后滚动
 ***/
@property (nonatomic , assign)BOOL autoScrollEnable;
@property (nonatomic , assign)NSInteger autoScrollSecond;
/***
 数据源
 ***/
@property (nonatomic , assign)id<SYScrollViewDataSource>dataSource;

//block
@property (nonatomic , copy)SYScrollViewTapContentViewIndexFinishedBlock tapContentViewIndexBlock;

- (void)setSYScrollViewTapContentViewIndexFinishedBlock:(SYScrollViewTapContentViewIndexFinishedBlock)block;


@end
