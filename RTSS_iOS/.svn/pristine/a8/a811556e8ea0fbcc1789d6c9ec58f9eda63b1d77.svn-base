//
//  SwitchButton.m
//  RTSS
//
//  Created by tiger on 14-11-28.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "SwitchView.h"
#import "CommonUtils.h"
#import "ImageUtils.h"
#import "RTSSAppStyle.h"

#define IMAGE_HEIGH              44
#define IMAGE_WIDTH              40
#define TOP_PADDING              10 //20
#define BOTTON_PADDING           30
#define INTENER_PADDING          2   //  控件内部间隔
#define TEXTFIELD_HEIGH          30
#define TEXTFIELD_WIDTH          80

@interface SwitchView()
{
    
}
@end

@implementation SwitchView
@synthesize serviceImage, serviceName, actionBtn;


-(void)dealloc{
    
    
    [_nameLabel release];
    [super dealloc];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutContentView:frame];
    }
    return self;
}

-(void)layoutContentView:(CGRect)frame
{
    CGFloat width = frame.size.width;
    //CGFloat height = frame.size.height;
    //切换按钮
    actionBtn = [CommonUtils buttonWithType:UIButtonTypeCustom
                                      frame:CGRectMake(0, 0, width, width)
                                      title:@""
                                colorNormal: [RTSSAppStyle currentAppStyle].navigationBarColor
                           colorHighlighted:[RTSSAppStyle currentAppStyle].viewControllerBgColor
                              colorSelected:nil
                                  addTarget:nil
                                     action:nil
                                        tag:0];
    actionBtn.layer.cornerRadius = width/2;
    actionBtn.layer.borderColor = [RTSSAppStyle currentAppStyle].budgetControlButtonStrokeColor.CGColor;
    actionBtn.layer.borderWidth = 0.5f;
    actionBtn.clipsToBounds = YES;
    [self addSubview:actionBtn];
    
    //图片
    serviceImage = [[UIImageView alloc]initWithFrame:CGRectMake((width-IMAGE_WIDTH)/2, TOP_PADDING, IMAGE_WIDTH, IMAGE_HEIGH)];
    serviceImage.backgroundColor = [UIColor clearColor];
    [actionBtn addSubview:serviceImage];
    [serviceImage release];
    
    //产品名字
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake((width-80)/2, TOP_PADDING, 80, IMAGE_HEIGH)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    _nameLabel.font = [RTSSAppStyle getRTSSFontWithSize:13.0f];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_nameLabel];
    //名称
    serviceName = [CommonUtils labelWithFrame:CGRectMake(0, TOP_PADDING + IMAGE_WIDTH + INTENER_PADDING, self.bounds.size.width, TEXTFIELD_HEIGH) text:NSLocalizedString(@"MoBileUsage_Detail_Center_Text", nil) textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[RTSSAppStyle getRTSSFontWithSize:22.0f] tag:0];
    serviceName.backgroundColor = [UIColor clearColor];
    [actionBtn addSubview:serviceName];
    
    //切换图标
    UIImageView * switchImage = [[UIImageView alloc]initWithFrame:CGRectMake((width-IMAGE_WIDTH)/2, width-BOTTON_PADDING, IMAGE_WIDTH, 13)];
    switchImage.image = [UIImage imageNamed:@"balance_switch_icon.png"];
    switchImage.backgroundColor = [UIColor clearColor];
    [actionBtn addSubview:switchImage];
    [switchImage release];
}



@end
