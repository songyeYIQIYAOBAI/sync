//
//  CircleViewItem.h
//  RTSS
//
//  Created by tiger on 14-12-3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleView.h"

typedef NS_ENUM(NSInteger, CircleViewType){
    ItemViewCircleType,
    ItemViewButtonType
};


@interface CircleViewItem : UIView

@property (nonatomic, readonly)CircleView * circle;
@property (nonatomic, readonly)UIButton * moreBtn;
@property (nonatomic, assign)CircleViewType iteType;

- (void)openfromPoint:(CGPoint)from to:(CGPoint)to withDuration:(CFTimeInterval)duration;
- (void)closefromPoint:(CGPoint)from to:(CGPoint)to withDuration:(CFTimeInterval)duration;

@end
