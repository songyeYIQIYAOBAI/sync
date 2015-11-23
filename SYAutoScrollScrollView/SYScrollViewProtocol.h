//
//  SYScrollViewProtocol.h
//  animationDemo
//
//  Created by Dragon on 15/9/11.
//  Copyright (c) 2015年 SY. All rights reserved.
//
#import "SYScroll_Item_Model.h"

@protocol SYScrollViewDataSource <NSObject>

- (NSInteger)numberOfItems;

- (SYScroll_Item_Model *)itemAtIndex:(NSInteger)index;

@end