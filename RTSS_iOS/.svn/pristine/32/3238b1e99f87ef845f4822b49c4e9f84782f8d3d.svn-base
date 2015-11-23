//
//  PasswordInputView.m
//  RTSS
//
//  Created by 蔡杰 on 14-11-3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "PasswordInputView.h"
#import "CommonUtils.h"


#define kRTSSPassWordShowViewWidth  240
#define kRTSSPassWordShowViewHeight  40
#define kRTSSTag 300


@interface PasswordShowView : UIView

-(void)showNumberWithTag:(NSInteger)tag isDelete:(BOOL)del;

@end


@implementation PasswordShowView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI:frame];
        
    }
    return self;
}

-(void)createUI:(CGRect)aFame{
    
    self.layer.borderColor = [UIColor colorWithRed:208/255.0 green:216.0/255 blue:238/255 alpha:1.0].CGColor;
    self.layer.cornerRadius = 5.0f;
    self.layer.borderWidth = 2.0f;
    
    for (int i = 0; i < 6; i++) {
        UILabel *paswordLabel = [[UILabel alloc]initWithFrame:CGRectMake(aFame.size.width/6*i, 5, aFame.size.width/6, aFame.size.height)];
        paswordLabel.tag = kRTSSTag + i ;
        paswordLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        paswordLabel.textAlignment = NSTextAlignmentCenter;
        paswordLabel.font = [UIFont systemFontOfSize:30.0f];
        [self addSubview:paswordLabel];
        [paswordLabel release];
    }
}


-(void)showNumberWithTag:(NSInteger)tag isDelete:(BOOL)del{
        UILabel *label = (UILabel*)[self viewWithTag:tag+kRTSSTag];
    if (del) {
        [label setText:@""];
        
    }else{
        [label setText:@"*"];
    }
}


-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat edge = self.bounds.size.width/6;
    for (int i = 1; i < 6; i++) {
        //设置颜色
        CGContextSetRGBStrokeColor(context, 239.0/255, 239.0/255, 239.0/255, 1.0);
        //开始一个起始路径
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, 1.5);
        //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
        CGContextMoveToPoint(context, edge*i, 0);
        //设置下一个坐标点
        CGContextAddLineToPoint(context, edge*i, self.bounds.size.height);
        //连接上面定义的坐标点
        CGContextStrokePath(context);
    }
}

@end




@interface PasswordInputView (){

    UILabel *typeLabel;
    UILabel *balanceLabel;
    PasswordShowView *password;
    
}

@property(nonatomic,readwrite,copy)NSString *passwordString;
@end

@implementation PasswordInputView{
    NSInteger count;  //最大为六
}


-(void)dealloc{
    [password release];
    [super dealloc];
}

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self installSubViews:frame];
        self.layer.cornerRadius = 5.0f;
    }
    
    return self;
    
    
}

-(void)installSubViews:(CGRect)aFrame{
    CGFloat edge = 10.0f;
    CGFloat labelHeight = 25.0f;
    
    NSString *tips = @"Enter payment Password";
    UILabel *tipsLabel = [CommonUtils labelWithFrame:CGRectMake(0, edge, aFrame.size.width, 20) text:tips textColor:[UIColor blackColor] textFont:[UIFont systemFontOfSize:20.0f] tag:0];
    [self addSubview:tipsLabel];
    [tips release];
    
    NSString *types = @"VVM VOTE";
    typeLabel = [CommonUtils labelWithFrame:CGRectMake(0, CGRectGetMaxY(tipsLabel.frame)+edge, aFrame.size.width, labelHeight) text:types textColor:[UIColor darkGrayColor] textFont:[UIFont systemFontOfSize:18.0f] tag:0];
    [self addSubview:typeLabel];
    
    NSString *balance = @"€ 100";
    balanceLabel = [CommonUtils labelWithFrame:CGRectMake(0, CGRectGetMaxY(typeLabel.frame)+edge, aFrame.size.width, labelHeight) text:balance textColor:[UIColor blackColor] textFont:[UIFont systemFontOfSize:25.0f] tag:0];
    [self addSubview:balanceLabel];
    
    //button
    UIButton *cancle = [UIButton buttonWithType:UIButtonTypeCustom];
    cancle.frame = CGRectMake(aFrame.size.width -25, 5, 20, 20);
    [cancle setBackgroundImage:[UIImage imageNamed:@"wallet_passwordInput_cancle"] forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(cancelInputPassword) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancle];
    //添加显示密码的
    password = [[PasswordShowView alloc]initWithFrame:CGRectMake((aFrame.size.width-kRTSSPassWordShowViewWidth)/2, CGRectGetMaxY(balanceLabel.frame)+edge, kRTSSPassWordShowViewWidth, kRTSSPassWordShowViewHeight)];
    password.backgroundColor = [UIColor whiteColor];
    [self addSubview:password];
}
#pragma mark  -- public

-(void)updateNumber:(NSString*)number{
    if (count == 6) {
        return;
    }
    [password showNumberWithTag:count isDelete:NO];
    [self updatePassword:number isDel:NO];
     count ++;
    if (count == 6) {
          NSLog(@"密码验证---%@",self.passwordString);
        return;
        
    }else{
      //self.passwordString = [NSString stringWithFormat:@"%@",number];

    }
}


-(void)deleteNumber{
    
    count--;
    if (! (count > 0) ) {
        count = 0;
    }
    [self updatePassword:nil isDel:YES];
    [password showNumberWithTag:count isDelete:YES];
    //NSLog(@"count = %d",count);
    if (count == 0) {
        count = 0;
        NSLog(@"义无数据--%@",self.passwordString);
        return;
    }
}

-(void)updatePassword:(NSString*)number isDel:(BOOL)adel{
    
    if (!adel) {
        if ([self.passwordString length] > 0) {
            self.passwordString = [NSString stringWithFormat:@"%@%@",self.passwordString,number];
            return;
        }
        self.passwordString = [NSString stringWithFormat:@"%@",number];
        return;
    }
    
    //删除
    if (count == 0) {
        self.passwordString = [NSString stringWithFormat:@""];
        return;
    }
    NSInteger toLocation = count;
    self.passwordString = [self.passwordString substringToIndex:toLocation];
    NSLog(@"del = %@",self.passwordString);
}

#pragma mark --Acrtion
-(void)cancelInputPassword{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
