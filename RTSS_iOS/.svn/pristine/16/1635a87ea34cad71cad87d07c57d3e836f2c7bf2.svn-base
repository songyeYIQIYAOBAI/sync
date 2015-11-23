//
//  CircleViewItem.m
//  RTSS
//
//  Created by tiger on 14-12-3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "CircleViewItem.h"
#import "SKBounceAnimation.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"

#define OPEN_KEY            @"openKey"
#define CLOSE_KEY           @"closeKey"

#define SWITCH_DIAMETER       130
#define CIRCLE_HEIGH          90
#define CIRCLE_WIDTH          90
#define MORE_BUTTON           100
#define LINE_WIDTH            3
#define CIRCLE_COUNT          6


@implementation CircleViewItem
@synthesize iteType, moreBtn, circle;


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initObject];
    }
    return self;
}

-(void)initObject
{
    //圆
    circle = [[CircleView alloc]initWithFrame:CGRectMake(0, 0, CIRCLE_WIDTH, CIRCLE_HEIGH) line:LINE_WIDTH];
    [self addSubview:circle];
    circle.hidden = YES;
    
    //按钮
    moreBtn = [[CommonUtils buttonWithType:UIButtonTypeCustom
                                                   frame:CGRectMake(0,0, MORE_BUTTON, MORE_BUTTON)
                                                   title:NSLocalizedString(@"MoBileUsage_More", nil)
                                             colorNormal:[RTSSAppStyle currentAppStyle].navigationBarColor
                                        colorHighlighted:[RTSSAppStyle currentAppStyle].viewControllerBgColor
                                           colorSelected:nil
                                               addTarget:nil
                                                  action:nil
                                                     tag:0]retain];
    [moreBtn setTitleColor:[RTSSAppStyle currentAppStyle].textSubordinateColor forState:UIControlStateNormal];
    moreBtn.layer.cornerRadius = MORE_BUTTON/2;
    moreBtn.layer.borderColor = [RTSSAppStyle currentAppStyle].budgetControlButtonStrokeColor.CGColor;
    moreBtn.layer.borderWidth = 0.5f;
    moreBtn.clipsToBounds = YES;
    [self addSubview:moreBtn];
    moreBtn.hidden = YES;

}

- (void)dealloc
{
    [moreBtn release];
    [circle release];
    [super dealloc];
}

- (void)openfromPoint:(CGPoint)from to:(CGPoint)to withDuration:(CFTimeInterval)duration
{
    SKBounceAnimation *bounceAnimation = [SKBounceAnimation animationWithKeyPath:@"position"];
    bounceAnimation.fromValue = [NSValue valueWithCGPoint:from];
    bounceAnimation.toValue = [NSValue valueWithCGPoint:to];
    bounceAnimation.duration = duration;
    bounceAnimation.numberOfBounces = 4;
    bounceAnimation.delegate = self;
    bounceAnimation.removedOnCompletion = NO;
    bounceAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:bounceAnimation forKey:OPEN_KEY];
}

- (void)closefromPoint:(CGPoint)from to:(CGPoint)to withDuration:(CFTimeInterval)duration
{
    SKBounceAnimation *bounceAnimation = [SKBounceAnimation animationWithKeyPath:@"position"];
    bounceAnimation.fromValue = [NSValue valueWithCGPoint:from];
    bounceAnimation.toValue = [NSValue valueWithCGPoint:to];
    bounceAnimation.duration = duration;
    bounceAnimation.numberOfBounces = 4;
    bounceAnimation.delegate = self;
    bounceAnimation.removedOnCompletion = NO;
    bounceAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:bounceAnimation forKey:CLOSE_KEY];
}

- (void) animationDidStop:(SKBounceAnimation *)animation finished:(BOOL)flag{
    [self.layer setValue:animation.toValue forKeyPath:animation.keyPath];
    if (nil != [self.layer animationForKey:OPEN_KEY]) {
        [self.layer removeAnimationForKey:OPEN_KEY];
        NSLog(@"openAnimationStop");
    }
    
    if (nil != [self.layer animationForKey:CLOSE_KEY]) {
        [self.layer removeAnimationForKey:CLOSE_KEY];
        NSLog(@"closeAnimationStop");
    }
}

-(void)setIteType:(CircleViewType)type
{
    if (ItemViewCircleType == type) {
        circle.hidden = NO;
    }
    
    if (ItemViewButtonType == type) {
        moreBtn.hidden = NO;
    }
    
    iteType = type;
}

@end
