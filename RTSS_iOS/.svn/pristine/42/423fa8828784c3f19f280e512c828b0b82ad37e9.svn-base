//
//  BankCardView.m
//  RTSS
//
//  Created by 蔡杰 on 14-11-4.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BankCardView.h"

#define kRTSSBankCardEdge 10.0f
#define kRTSSBankCardIconHeight 40.0f

#pragma mark --BalanceView

@interface BalanceView (){
  
   // UIImageView *markImageView;
    UILabel *balanceLabel;
}

@end


@implementation BalanceView

-(void)dealloc{
    
    //[markImageView release];
    [balanceLabel release];
    [super dealloc];
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self installSubViewsWithFrame:frame];
        self.layer.cornerRadius = 10.0f;
        self.layer.masksToBounds = YES;
    }
    return self;
}


-(void)installSubViewsWithFrame:(CGRect)frame{
    
//    markImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kRTSSBankCardEdge, kRTSSBankCardEdge, kRTSSBankCardIconHeight, kRTSSBankCardIconHeight)];
//    markImageView.backgroundColor = [UIColor blueColor];
//    markImageView.layer.cornerRadius = kRTSSBankCardIconHeight/2;
//    markImageView.layer.masksToBounds = YES;
//    [self addSubview:markImageView];
    
//    UILabel *tips = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(markImageView.frame)+10, CGRectGetMinY(markImageView.frame)+10, 100, 20)];
//    tips.textColor = [UIColor whiteColor];
//    tips.text = @"Balance";
//    tips.font = [UIFont systemFontOfSize:18.0f];
//    [self addSubview:tips];
    
    CGFloat balanceWidth = 200;
    balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-balanceWidth-kRTSSBankCardEdge, kRTSSBankCardEdge+5, balanceWidth, 30)];
    balanceLabel.textColor = [UIColor whiteColor];
    balanceLabel.textAlignment = NSTextAlignmentRight;
    balanceLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    balanceLabel.text = @"€ 99.00";
    balanceLabel.font = [UIFont systemFontOfSize:25.0f];
    [self addSubview:balanceLabel];
    
    
}

#pragma mark --BalanceView Public
-(void)setUserBalance:(NSString*)balance{
    balanceLabel.text = balance;
}

@end

#pragma mark --BankCardView

@interface BankCardView (){

    UIImageView *markImageView;
    UILabel *cardLabel;
    UIImageView *bgImageView;
}

@end


@implementation BankCardView

-(void)dealloc{
    
    [markImageView release];
    [cardLabel release];
    [bgImageView release];
    [super dealloc];
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self installSubViewsWithFrame:frame];
        [self setProperty];
    }
    return self;
}
-(void)setProperty{
    
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;
}

-(void)installSubViewsWithFrame:(CGRect)frame{
    
    //背景图
    bgImageView = [[UIImageView alloc]initWithFrame:self.bounds];
   // bgImageView.backgroundColor = [UIColor redColor];
    [self addSubview:bgImageView];
    
    //card Icon
    markImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kRTSSBankCardEdge, kRTSSBankCardEdge, kRTSSBankCardIconHeight, kRTSSBankCardIconHeight)];
    markImageView.backgroundColor = [UIColor blueColor];
    markImageView.layer.cornerRadius = kRTSSBankCardIconHeight/2;
    markImageView.layer.masksToBounds = YES;
    [bgImageView addSubview:markImageView];
    
    UILabel *cardType  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(markImageView.frame)+10, kRTSSBankCardEdge, 100, 20)];
    cardType.textColor = [UIColor whiteColor];
    //cardType.backgroundColor = [UIColor yellowColor];
    cardType.textAlignment = NSTextAlignmentLeft;
    cardType.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    cardType.text = @"CMB";
    cardType.font = [UIFont systemFontOfSize:15.0f];
    [bgImageView addSubview:cardType];
    [cardType release];
    
    UILabel *cardTypeInfo  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(markImageView.frame)+10, CGRectGetMaxY(cardType.frame), 100, 20)];
    cardTypeInfo.textColor = [UIColor whiteColor];
    cardTypeInfo.textAlignment = NSTextAlignmentLeft;
    cardTypeInfo.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    cardTypeInfo.text = @"Credit Card";
    cardTypeInfo.font = [UIFont systemFontOfSize:12.0f];
    [bgImageView addSubview:cardTypeInfo];
    [cardTypeInfo release];
    
    cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(kRTSSBankCardEdge+CGRectGetMaxX(markImageView.frame), CGRectGetMaxY(markImageView.frame)+15,frame.size.width-CGRectGetMaxX(markImageView.frame)-kRTSSBankCardEdge, 30)];
    cardLabel.textColor = [UIColor whiteColor];
   // cardLabel.backgroundColor = [UIColor yellowColor];
    cardLabel.textAlignment = NSTextAlignmentCenter;
    cardLabel.contentMode = UIViewContentModeCenter;
    cardLabel.adjustsFontSizeToFitWidth = YES;
    cardLabel.numberOfLines =  1;
    cardLabel.baselineAdjustment = UIBaselineAdjustmentNone;
    cardLabel.font = [UIFont systemFontOfSize:30.0f];
    cardLabel.text = @"**** **** **** 1037";
    [bgImageView addSubview:cardLabel];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
