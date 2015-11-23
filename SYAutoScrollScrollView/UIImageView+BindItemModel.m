//
//  UIImageView+BindItemModel.m
//  animationDemo
//
//  Created by Dragon on 15/9/11.
//  Copyright (c) 2015年 SY. All rights reserved.
//

#import "UIImageView+BindItemModel.h"

@implementation UIImageView (BindItemModel)

- (void)loadImageWithBindingItemModel:(SYScroll_Item_Model *)model{
    switch (model.type) {
        case SYScrollViewItemTypeImage:
        {
            self.image = [UIImage imageNamed:model.itemString];
        }
            break;
        case SYScrollViewItemTypeImageUrl:
            
            break;
        default:
            break;
    }
}

@end
