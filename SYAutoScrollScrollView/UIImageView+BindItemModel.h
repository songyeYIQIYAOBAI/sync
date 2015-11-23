//
//  UIImageView+BindItemModel.h
//  animationDemo
//
//  Created by Dragon on 15/9/11.
//  Copyright (c) 2015年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYScroll_Item_Model.h"

@interface UIImageView (BindItemModel)

- (void)loadImageWithBindingItemModel:(SYScroll_Item_Model *)model;

@end
