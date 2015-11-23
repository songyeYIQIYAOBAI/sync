//
//  PopView.h
//  EasyTT
//
//  Created by tiger on 14-11-1.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopItemView : UIView
{
	UIView* spaceLineView;
}

@property(nonatomic,readonly)UIButton* popItemButton;

@property(nonatomic, assign, setter=setSeparate:)BOOL isSeparate;

@end

@interface PopView : UIView
{
	UIImageView* bgImageView;
	
	NSMutableArray* itemsView;
	
	BOOL isShow;
}

- (void)setBackgroundImage:(UIImage*)bgImage;

- (void)addPopItemView:(PopItemView*)itemView;
- (void)removeAllItemView;

- (BOOL)isShowPopView;
- (void)showPopView:(BOOL)animated;
- (void)dismissPopView:(BOOL)animated;

@end
