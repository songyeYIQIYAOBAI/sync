//
//  ItemView.m
//  RTSS
//
//  Created by tiger on 14-11-4.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "DropDownItemView.h"
#import "CommonUtils.h"

@implementation DropDownItemView
@synthesize itemLabel, itemImageView;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initContentView:frame];
    }
    return self;
}

-(void)initContentView:(CGRect)frame
{
    itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 20, 20)];
    [self addSubview:itemImageView];
    
    itemLabel = [CommonUtils labelWithFrame:CGRectMake(20, 5, 40, 20) text:@"" textColor:[CommonUtils colorWithHexString:@"#b2bdc1"] textFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:14] tag:0];
    [self addSubview:itemLabel];
}

-(void)dealloc
{
    [itemImageView release];
    [super dealloc];
}

@end
