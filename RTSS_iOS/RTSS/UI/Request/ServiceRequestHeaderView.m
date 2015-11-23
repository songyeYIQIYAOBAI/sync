//
//  ServiceRequestHeaderView.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-3-4.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "ServiceRequestHeaderView.h"

@interface ServiceRequestHeaderView()

@property (nonatomic, retain) NSMutableArray *mButtonArray;
@property(nonatomic,retain)NSArray *mFiltrateArray;
@end

@implementation ServiceRequestHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self install_SR_Subviews];
    }
    return self;
}
-(void)install_SR_Subviews{
    
    
    CGRect buttonBgRect = CGRectMake(45, 60, 80, 80);
    if (PHONE_UISCREEN_IPHONE5) {
        buttonBgRect = CGRectMake(45, 65, 80, 80);
    } else if (PHONE_UISCREEN_IPHONE6) {
        buttonBgRect = CGRectMake(40, 70, 90, 90);
    } else if (PHONE_UISCREEN_IPHONE6PLUS) {
        buttonBgRect = CGRectMake(30, 80, 110, 110);
    }
    
    
    UIImageView *buttonBgImageView = [[UIImageView alloc] initWithFrame:buttonBgRect];
    buttonBgImageView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    [buttonBgImageView.layer setBorderColor: [[RTSSAppStyle currentAppStyle].separatorColor CGColor]];
    [buttonBgImageView.layer setBorderWidth: 1.0];
    buttonBgImageView.layer.cornerRadius = CGRectGetWidth(buttonBgImageView.frame) / 2.f;
    buttonBgImageView.layer.masksToBounds = YES;
    [self addSubview:buttonBgImageView];
    [buttonBgImageView release];
    
    UIImageView *mDownLineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-0.5, self.bounds.size.width, 0.5)];
    mDownLineImage.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self addSubview:mDownLineImage];
    [mDownLineImage release];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = ServiceRequestActionTypeAdd;
    button.frame = CGRectMake(buttonBgImageView.frame.origin.x+buttonBgImageView.frame.size.height/4, buttonBgImageView.frame.origin.y+buttonBgImageView.frame.size.height/4, buttonBgImageView.frame.size.height/2, buttonBgImageView.frame.size.height/2);
    [button setBackgroundImage:[UIImage imageNamed:@"service_request_addcircle.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(performActon:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
}
-(void)install_SR_MoreSubviewsButton:(NSArray *)info{
    
    self.mFiltrateArray = info;
    self.mButtonArray = [NSMutableArray arrayWithCapacity:0];
    CGFloat buttonWith = 57;
    CGFloat buttonHeight = 20;
    CGFloat buttonCornerRadius = 10.f;
    CGFloat buttonTitleFontSize = 11.f;
    //计算x
    CGFloat x = PHONE_UISCREEN_WIDTH - 10 - 3*buttonWith- 2*5;
    CGFloat y = 76;
    if (PHONE_UISCREEN_IPHONE5) {
        y = 80;
    } else if (PHONE_UISCREEN_IPHONE6) {
        buttonWith = 65;
        buttonHeight = 23;
        x = PHONE_UISCREEN_WIDTH - 20 - 3*buttonWith- 2*5;
        y = 88;
    } else if (PHONE_UISCREEN_IPHONE6PLUS) {
        buttonWith = 77;
        buttonHeight = 28;
        x = PHONE_UISCREEN_WIDTH - 20 - 3*buttonWith- 2*5;
        y = 100;
        buttonCornerRadius = 15.f;
        buttonTitleFontSize = 13.f;
    }
    
    for (int i = 0; i < [self.mFiltrateArray count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x+(i%3*(buttonWith+5)), y+(i/3*(buttonHeight+10)), buttonWith, buttonHeight);
        button.tag = i;
        [button setBackgroundColor:[RTSSAppStyle currentAppStyle].viewControllerBgColor];
        [button setTitle:[[self.mFiltrateArray objectAtIndex:i] objectForKey:@"categoryName"] forState:UIControlStateNormal];
        button.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:buttonTitleFontSize];
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = [RTSSAppStyle currentAppStyle].separatorColor.CGColor;
        button.layer.cornerRadius = buttonCornerRadius;

        [button setTitleColor:[RTSSAppStyle currentAppStyle].textMajorColor forState:UIControlStateNormal];
        [button setTitleColor:[RTSSAppStyle currentAppStyle].textBlueColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(serviceRequestAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.mButtonArray addObject:button];
        //默认all为绿色
        if (i == 0) {
            button.selected = YES;
            [button setBackgroundColor:[RTSSAppStyle currentAppStyle].navigationBarColor];
            
        }
    }
    
}

- (void)allButtonGreen
{
    for (UIButton *button in self.mButtonArray) {
        if (button.tag == 0) {
            button.selected = YES;
            [button setBackgroundColor:[RTSSAppStyle currentAppStyle].navigationBarColor];
        } else {
            [button setBackgroundColor:[RTSSAppStyle currentAppStyle].viewControllerBgColor];
            button.selected = NO;
        }
    }
}

#pragma mark --Action
-(void)performActon:(id)sender{
//     UIButton *bt = (UIButton*)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(serviceRequestActionType:)]){
        [self.delegate serviceRequestActionType:@"Add"];
    }
}
-(void)serviceRequestAction:(id)sender{
    
    
    for (UIButton *button in self.mButtonArray) {
        [button setBackgroundColor:[RTSSAppStyle currentAppStyle].viewControllerBgColor];
        button.selected = NO;
        
    }
    
    UIButton *bt = (UIButton*)sender;
    bt.selected = YES;
    [bt setBackgroundColor:[RTSSAppStyle currentAppStyle].navigationBarColor];
    if (self.delegate && [self.delegate respondsToSelector:@selector(serviceRequestActionType:)]) {
        [self.delegate serviceRequestActionType:[[self.mFiltrateArray objectAtIndex:bt.tag] objectForKey:@"categoryId"]];
    }
    
}

@end
