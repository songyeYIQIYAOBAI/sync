//
//  PlanManageHeadView.m
//  RTSS
//
//  Created by tiger on 14-11-3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "PlanManageHeadView.h"
#import "CommonUtils.h"
#import "PlanManageDropDownView.h"
#import "RTSSAppStyle.h"
#import "RTSSAppDefine.h"

@interface PlanManageHeadView()
{
    UIImageView *headImageView;
    UILabel *nameLabel;
    UILabel *phoneLabel;
    UILabel *balanceLabel;
    UILabel *tariffLabel;
    UILabel *moneyLabel;
    UILabel *packageInfoLabel;
    CGRect originalFrame;
    
    PlanManageDropDownView * dropDownView;
}
@end

@implementation PlanManageHeadView
@synthesize  delegate;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutContentView];
    }
    return self;
}

-(void)setHeadInfoModel:(PlanManageHeadModel *)headInfo
{
    headImageView.image = headInfo.headImage;
    nameLabel.text = headInfo.name;
    phoneLabel.text = headInfo.phone;
    
    NSString * formatBalance = [NSString stringWithFormat:@"Balance €%@", headInfo.balance];
    balanceLabel.text = formatBalance;
    
    NSString * formatTariffLabel = [NSString stringWithFormat:@"Tariff %@", headInfo.tariff];
    tariffLabel.text = formatTariffLabel;
    
    NSString * formatMoney = [NSString stringWithFormat:@"€%@", headInfo.money];
    moneyLabel.text = formatMoney;
    
    //设置对齐方式
    nameLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    balanceLabel.textAlignment = NSTextAlignmentRight;
    tariffLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    
    dropDownView.servicesArray = headInfo.serviceArray;
}

-(void)layoutContentView
{
    RTSSAppStyle * colorMgr = [RTSSAppStyle currentAppStyle];
    self.backgroundColor = colorMgr.navigationBarColor;
    
    //headImage
    headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 80, 80)];
    headImageView.backgroundColor = [UIColor greenColor];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 40.0f;
    [self addSubview:headImageView];

    //nameLabel
    nameLabel = [CommonUtils labelWithFrame:CGRectMake(120, 45, 80, 20) text:@"" textColor:[CommonUtils colorWithHexString:@"#b2bdc1"] textFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:15] tag:0];
    nameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:nameLabel];
    
    //phoneLabel
    phoneLabel = [CommonUtils labelWithFrame:CGRectMake(120, 65, 80, 20) text:@"" textColor:[CommonUtils colorWithHexString:@"#b2bdc1"] textFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:15] tag:0];
    phoneLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:phoneLabel];
    
    //balanceLabel
    balanceLabel = [CommonUtils labelWithFrame:CGRectMake(190, 10, 110, 20) text:@"" textColor:colorMgr.textMajorGreenColor textFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:15] tag:0];
    balanceLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:balanceLabel];

    //tariffLabel
    tariffLabel = [CommonUtils labelWithFrame:CGRectMake(220, 45, 80, 20) text:@"" textColor:[CommonUtils colorWithHexString:@"#b2bdc1"] textFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:15] tag:0];
    tariffLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:tariffLabel];
    
    //moneylabel
    moneyLabel = [CommonUtils labelWithFrame:CGRectMake(220, 65, 80, 20) text:@"" textColor:[CommonUtils colorWithHexString:@"#b2bdc1"] textFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:15] tag:0];
    tariffLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:moneyLabel];
    
    //sepraterline
    UIImageView *seprater = [[UIImageView alloc]initWithFrame:CGRectMake(20, 115, PHONE_UISCREEN_WIDTH -20*2, 2.0f)];
    seprater.image = [UIImage imageNamed:@"common_separator_line.png"];
    [self addSubview:seprater];

    //packageInfoLabel
    packageInfoLabel = [CommonUtils labelWithFrame:CGRectMake(10, 157, PHONE_UISCREEN_WIDTH-10*2, 65) text:@"According to the use of your history,recommend you order €98 traiff package" textColor:[CommonUtils colorWithHexString:@"#b2bdc1"] textFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:14] tag:0];
    packageInfoLabel.backgroundColor = [UIColor clearColor];
    packageInfoLabel.numberOfLines = 0;
    packageInfoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:packageInfoLabel];
    
    //dropDownView
    dropDownView = [[PlanManageDropDownView alloc]initWithFrame:CGRectMake(0, 117, PHONE_UISCREEN_WIDTH, 40)];
    dropDownView.backgroundColor = colorMgr.navigationBarColor;
    dropDownView.delegate = self;
    [self addSubview:dropDownView];
    [dropDownView release];

}

-(void)adjustViewFrame:(float)offHeight IsDrop:(BOOL)isDrop
{
    if (isDrop) {
        packageInfoLabel.frame = CGRectMake(10, 157 + offHeight, 305, 65);
        self.frame = CGRectOffset(self.frame, 0, offHeight);
    }else{
        packageInfoLabel.frame = CGRectMake(10, 157 - offHeight, 305, 65);
        self.frame = CGRectOffset(self.frame, 0, -offHeight);
    }
}


@end
