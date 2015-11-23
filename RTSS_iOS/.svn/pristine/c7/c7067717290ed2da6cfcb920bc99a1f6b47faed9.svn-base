//
//  PortraitImageView.m
//  RTSS
//
//  Created by 加富董 on 14-11-5.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "PortraitImageView.h"
#import "RTSSAppStyle.h"

@implementation PortraitImageView
@synthesize actionButton, portraitImage;

#pragma mark init
- (id)initWithFrame:(CGRect)frame image:(UIImage *)image borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    if (self = [super initWithFrame:frame]) {
        //content mode
        self.contentMode = UIViewContentModeCenter;
        self.userInteractionEnabled = YES;
        
        //bg color
        self.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
        
        //holder image
        if (image) {
            self.image = image;
        }
        
        //border color
        if (borderColor) {
            self.layer.borderColor = borderColor.CGColor;
        }
        
        //border width
        if (borderWidth > 0.f) {
            self.layer.borderWidth = borderWidth;
        }
        
        //radius
        self.layer.cornerRadius = CGRectGetWidth(frame) / 2.f;
        self.layer.masksToBounds = YES;
        
        //actionButton
        actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        actionButton.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(frame), CGRectGetHeight(frame));
        actionButton.backgroundColor = [UIColor clearColor];
        [self addSubview:actionButton];
    }
    return self;
}

#pragma mark setter
- (void)setPortraitImage:(UIImage*)image{
    CGSize imageSize = image.size;
    if(imageSize.width > self.bounds.size.width || imageSize.height > self.bounds.size.height){
        self.contentMode = UIViewContentModeScaleToFill;
    }else{
        self.contentMode = UIViewContentModeCenter;
    }
    self.image = image;
}

- (void)setFrame:(CGRect)newFrame {
    [super setFrame:newFrame];
    self.layer.cornerRadius = CGRectGetWidth(newFrame) / 2.f;
    self.layer.masksToBounds = YES;
    actionButton.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(newFrame), CGRectGetHeight(newFrame));
}

#pragma mark dealloc
- (void)dealloc {

    [super dealloc];
}

@end
