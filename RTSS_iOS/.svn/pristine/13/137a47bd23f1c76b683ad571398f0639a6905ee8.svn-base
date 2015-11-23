//
//  PlanManageDropDownView.m
//  RTSS
//
//  Created by tiger on 14-11-4.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "PlanManageDropDownView.h"
#import "CommonUtils.h"
#import "DropDownItemView.h"
#import "RTSSAppDefine.h"

@interface PlanManageDropDownView()
{
    NSMutableArray * itemViews;
    NSMutableArray * hideItemViews;//隐藏项
    BOOL isDrop;
    UIImageView *lastSeprater;
    CGFloat verticalPadding;
    CGFloat dropDownHeight;
}

@end

@implementation PlanManageDropDownView
@synthesize servicesArray, dropDownBtn, delegate;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initObject];
        [self layoutCountentView];
    }
    return self;
}

-(void)initObject
{
    isDrop = YES;
}

-(void)layoutCountentView
{
    //下拉按钮
    dropDownBtn = [CommonUtils buttonWithType:UIButtonTypeCustom
                                                frame:CGRectMake(PHONE_UISCREEN_WIDTH-40, 10, 24, 24)
                                                title:@""
                                        bgImageNormal:[UIImage imageNamed:@"common_arrow_down.png"]
                                   bgImageHighlighted:nil
                                      bgImageSelected:nil addTarget:self action:@selector(dropDownOnClick) tag:0];
    [self addSubview:dropDownBtn];
    
    
    //分割线
    lastSeprater = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-2.0f, PHONE_UISCREEN_WIDTH, 2.0f)];
    lastSeprater.image = [UIImage imageNamed:@"common_separator_line.png"];
    [self addSubview:lastSeprater];
}

-(void)setServicesArray:(NSMutableArray *)newServiceArray
{
    if (servicesArray != newServiceArray) {
        [servicesArray release];
        servicesArray = [newServiceArray retain];
        
        [self layoutContentSubviews];
    }
}

-(void)layoutContentSubviews
{
    itemViews = [[NSMutableArray alloc]init];
    hideItemViews = [[NSMutableArray alloc]init];
    for (int i = 0; i < servicesArray.count; i++) {
        DropDownItemView * item = [[DropDownItemView alloc]init];
        item.itemImageView.image = [servicesArray[i] valueForKey:_ITEMIMAGE_];
        item.itemLabel.text = [servicesArray[i] valueForKey:_ITEMTEXT_];
        [self addSubview:item];
        [itemViews addObject:item];
    }
    

    //宫格宽度
    float gridWidth = 200;
    //垂直间距
    verticalPadding = 4;
    
    CGFloat btnW = 50;
    CGFloat btnH = 30;
    
    //计算需要伸长的高度
    dropDownHeight = ((servicesArray.count-1)/3)*(verticalPadding+btnH);
    
    for (int i = 0; i < servicesArray.count; i++) {
        //2.取出按钮
        DropDownItemView * itemView = itemViews[i];
        
        //3.九宫格计算每个按钮的frame
        CGFloat row = i/3;
        CGFloat loc = i%3;

        CGFloat horizontalPadding = (gridWidth - 3 * btnW)/4;
        
        NSLog(@"self.frame.size.width = %f", self.frame.size.width);
        CGFloat btnX = horizontalPadding + (btnW + horizontalPadding) * loc;
        CGFloat btnY = verticalPadding + (btnH + verticalPadding) * row;
        itemView.frame = CGRectMake(btnX + (PHONE_UISCREEN_WIDTH-gridWidth)/2, btnY, btnW, btnH);
        
        if (row != 0) {
            itemView.hidden = YES;
            [hideItemViews addObject:itemView];
        }
    }
}

-(void)dealloc
{
    [itemViews release];
    [super dealloc];
}

-(void)setOtherItemViewShowStatus:(BOOL)isShow
{
    for (DropDownItemView* itemView in hideItemViews) {
        itemView.hidden = !isShow;
    }
}

-(void)dropDownOnClick
{
    if (isDrop) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + dropDownHeight);
        [self setOtherItemViewShowStatus:isDrop];
        
        lastSeprater.frame = CGRectMake(lastSeprater.frame.origin.x, lastSeprater.frame.origin.y + dropDownHeight, lastSeprater.frame.size.width, lastSeprater.frame.size.height);
        
    }else{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - dropDownHeight);
        [self setOtherItemViewShowStatus:isDrop];
        
        lastSeprater.frame = CGRectMake(lastSeprater.frame.origin.x, lastSeprater.frame.origin.y - dropDownHeight, lastSeprater.frame.size.width, lastSeprater.frame.size.height);
    }
    isDrop = !isDrop;
}


@end
