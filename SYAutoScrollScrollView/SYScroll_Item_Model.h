//
//  SYScroll_Item_Model.h
//  animationDemo
//
//  Created by Dragon on 15/9/11.
//  Copyright (c) 2015年 SY. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, SYScrollViewItemType) {
    SYScrollViewItemTypeImage,
    SYScrollViewItemTypeImageUrl,
};

@interface SYScroll_Item_Model : NSObject

@property (nonatomic , copy)NSString * itemString;
@property (nonatomic , assign)SYScrollViewItemType type;

@end
