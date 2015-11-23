//
//  MobileUsageView.h
//  RTSS
//
//  Created by tiger on 14-11-28.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchView.h"
#import "CircleViewItem.h"

@interface MobileUsageView : UIView

@property (nonatomic, readonly)SwitchView * switchView;
@property (nonatomic, readonly)CircleViewItem * actionBtn;

-(void)loadDataAndInitCircleView:(NSMutableArray *)array;
-(BOOL)removeAllCircleFromSupperView;

-(void)shrinkCircleAnimation:(BOOL)animation completion:(void (^)(BOOL finished))completion;
-(void)openCircleAnimation:(BOOL)animation completion:(void (^)(BOOL finished))completion;

@end
