//
//  MaskView.m
//  EasyTT
//
//  Created by 加富董 on 14-10-21.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "MaskView.h"

@implementation MaskView

@synthesize hideBlock = _hideBlock;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    self.backgroundColor = [UIColor lightGrayColor];
    self.alpha = 0.5f;
    self.hideBlock = nil;
    [self addGestures];
}

- (void)addGestures
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide:)];
    [self addGestureRecognizer:tap];
    [tap release];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hide:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeUp];
    [swipeUp release];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hide:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeDown];
    [swipeDown release];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hide:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeLeft];
    [swipeLeft release];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hide:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeRight];
    [swipeRight release];
}

- (void)hide:(UIGestureRecognizer *)rec
{
    if (self.hideBlock) {
        self.hideBlock(self);
    }
    [self removeFromSuperview];
}

- (void)dealloc
{
    if (self.hideBlock) {
        [self.hideBlock release];
    }
    [super dealloc];
}

@end
