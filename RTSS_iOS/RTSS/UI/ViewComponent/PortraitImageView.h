//
//  PortraitImageView.h
//  RTSS
//
//  Created by 加富董 on 14-11-5.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PortraitImageView : UIImageView

@property (nonatomic, readonly) UIButton *actionButton;
@property (nonatomic, assign, setter=setPortraitImage:) UIImage* portraitImage;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

@end
