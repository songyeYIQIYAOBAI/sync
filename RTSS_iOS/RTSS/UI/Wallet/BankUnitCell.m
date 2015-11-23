//
//  BankUnitCell.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-1-26.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BankUnitCell.h"
#import "RTSSAppStyle.h"
#define kRTSSBankCardEdge 10.0f
#define kRTSSBankCardIconHeight 40.0f

@interface BalanceView (){
     UILabel *balanceLabel;
}

@end
@implementation BalanceView
-(void)dealloc{
    
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
/**
 *
 *  ====================================
 */


@interface AddCardButton ()

@end

@implementation AddCardButton

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self installSubviews];
    }
    return self;
}

-(void)installSubviews{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:bgImageView];
    
    UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    addImageView.image = [UIImage imageNamed:@"wallet_bankcardmanager_addcard"];
    [bgImageView addSubview:addImageView];
    [addImageView release];
    
    UILabel *adLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addImageView.frame)+10, 10, 100, 20)];
    adLabel.text = @"Add a Card";
    adLabel.font = [UIFont systemFontOfSize:15.0f];
    adLabel.textColor = [UIColor whiteColor];
    [bgImageView addSubview:adLabel];
    [adLabel release];
    
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width-25, 10, 20, 20)];
    [arrow setImage:[UIImage imageNamed:@"common_next_arrow"]];
    [bgImageView addSubview:arrow];
    [arrow release];
    
    [bgImageView release];
}

@end


/**
 *  ======================================
 */
@interface BankUnitCell (){
    
    UIImageView *markImageView;
    UILabel *cardLabel;
    UIImageView *bgImageView;
}

@end

@implementation BankUnitCell

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
    markImageView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    markImageView.layer.cornerRadius = kRTSSBankCardIconHeight/2;
    markImageView.layer.masksToBounds = YES;
    [bgImageView addSubview:markImageView];
    
    //卡片类型
    UILabel *cardType  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(markImageView.frame)+10, kRTSSBankCardEdge, 100, 20)];
    cardType.textColor = [UIColor whiteColor];
    cardType.textAlignment = NSTextAlignmentLeft;
    cardType.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    cardType.text = @"CMB";
    cardType.font = [UIFont systemFontOfSize:15.0f];
    [bgImageView addSubview:cardType];
    [cardType release];
    
    //卡片描述信息
    UILabel *cardTypeInfo  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(markImageView.frame)+10, CGRectGetMaxY(cardType.frame), 100, 20)];
    cardTypeInfo.textColor = [UIColor whiteColor];
    cardTypeInfo.textAlignment = NSTextAlignmentLeft;
    cardTypeInfo.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    cardTypeInfo.text = @"Credit Card";
    cardTypeInfo.font = [UIFont systemFontOfSize:12.0f];
    [bgImageView addSubview:cardTypeInfo];
    [cardTypeInfo release];
    
    //卡号显示
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
