//
//  PatternGesturesPath.m
//  EasyTT
//
//  Created by tiger on 14-10-10.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "PatternMiniPathView.h"
#import "CommonUtils.h"


@implementation PatternMiniPathView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

-(void)setup
{
    for (int i = 0; i < 9; i++) {
        UIView * itemView = [[UIView alloc]init];
        itemView.backgroundColor = [CommonUtils colorWithHexString:@"#47484c"];
        itemView.tag = i;
        [self addSubview:itemView];
        [itemView release];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"self.subviews.count = %d", self.subviews.count);
    for (int i = 0; i < self.subviews.count; i++) {
        //2.取出按钮
        UIView * itemView = self.subviews[i];
        
        //3.九宫格计算每个按钮的frame
        CGFloat row = i/3;
        CGFloat loc = i%3;
        CGFloat btnW = 12;
        CGFloat btnH = 12;
        CGFloat padding = (self.frame.size.width - 3 * btnW)/4;
        NSLog(@"self.frame.size.width = %f", self.frame.size.width);
        CGFloat btnX = padding + (btnW + padding) * loc;
        CGFloat btnY = padding + (btnW + padding) * row;
        itemView.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

-(void)drawGesturesPath:(NSMutableArray *)tags isFinished:(BOOL)isFinished
{
    if (isFinished) {
        for (UIView *itemView in self.subviews) {
            NSNumber *tag = [NSNumber numberWithInt:itemView.tag];
            if ([tags containsObject:tag]) {
                itemView.backgroundColor = [CommonUtils colorWithHexString:@"#98c625"];
            }
        }
    }
}

@end
