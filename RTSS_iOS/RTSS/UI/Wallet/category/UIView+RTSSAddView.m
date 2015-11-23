//
//  UIView+RTSSAddView.m
//  EasyTT
//
//  Created by 蔡杰 on 14-10-23.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "UIView+RTSSAddView.h"
#import "UILabel+LabelTextColor.h"

#import "RTSSAppDefine.h"
#import "RTSSAppStyle.h"
#import "CommonUtils.h"

//static CGFloat const kRTSS_lrEdge = 20.0f;

#define kRTSSLabelHeight 20.0f
#define kRTSSLabelWidth  120.0f
#define kRTSSLabelSpacing 15.0f

@implementation UIView (RTSSAddView)
/**
 *  不同颜色背景UIView
 *
 *  @param fame 大小
 */
-(void)addTopViewWithFrame:(CGRect)fame{
    //topView
    UIView *topView = [[UIView alloc] initWithFrame:fame];
    topView.backgroundColor =  [RTSSAppStyle currentAppStyle].navigationBarColor;
    [self addSubview:topView];
    //line
    [topView addBottomLine];
    [topView release];
}

/**
 *  加载底部横条
 */
-(void)addBottomLine{
    [self addBottomLineWithY:self.bounds.size.height-kRTSSLineHeight];
}

-(void)addBottomLineWithY:(CGFloat)lineY{
    UIImageView *line = [[UIImageView alloc] init];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    line.frame = CGRectMake(0, lineY, PHONE_UISCREEN_WIDTH, kRTSSLineHeight);
    [self addSubview:line];
    [line release];
}


-(void)setViewBlackColor{
    self.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
}

+(UILabel *)addLabelWithFrame:(CGRect)aFrame TextColor:(UIColor *)aColor TextAlignment:(NSTextAlignment)ATextAligment{
    UILabel *label = [[UILabel alloc] initWithFrame:aFrame];
    label.textColor =  aColor;
    label.textAlignment = ATextAligment;
    label.font = [UIFont systemFontOfSize:15.0f];
    label.numberOfLines = 1;
    return [label autorelease];
}

#define kRTSSTextFieldHeight 35.0f
#define kRTSSTextFieldEdge 10.0f
#define kRTSSTextFieldlrEdge 20.0f
#define kRTSSLabelWidth     120.0f

-(UITextField *)addTextFieldWithFrame:(CGRect)aFrame Name:(NSString *)name TextFieldDelegate:(id)aDelegate KeyboardType:(UIKeyboardType)aKeyboardType isMoneySymbol:(BOOL)flag{
    
    UIView *blackView = [[[UIView alloc] initWithFrame:aFrame] autorelease];
    blackView.backgroundColor =  [RTSSAppStyle currentAppStyle].navigationBarColor;
    [self addSubview:blackView];
    
    //textField  title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kRTSSTextFieldlrEdge,0,kRTSSLabelWidth, 20)];
    titleLabel.numberOfLines = 1;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [titleLabel setTextMainColor];
    titleLabel.text = name;
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [blackView addSubview:titleLabel];
    [titleLabel release];
    
    UIView *bgTextFieldView = [[UIView alloc] initWithFrame:CGRectMake(kRTSSTextFieldlrEdge, CGRectGetMaxY(titleLabel.frame)+kRTSSTextFieldEdge, aFrame.size.width-kRTSSTextFieldlrEdge*2, kRTSSTextFieldHeight)];
    //bgTextFieldView.layer.borderWidth = 1.0;
    bgTextFieldView.layer.cornerRadius = 5.0;
    bgTextFieldView.backgroundColor =  [RTSSAppStyle currentAppStyle].textFieldBgColor;
    [blackView addSubview:bgTextFieldView];
    
    
    UITextField *textField = [[UITextField alloc] init];
   // textField.frame = CGRectMake(kRTSSTextFieldlrEdge, CGRectGetMaxY(titleLabel.frame)+kRTSSTextFieldEdge, aFrame.size.width-kRTSSTextFieldlrEdge*2, kRTSSTextFieldHeight);
    textField.frame = bgTextFieldView.bounds;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.textColor = [UIColor whiteColor];
    textField.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    textField.tintColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    textField.backgroundColor = [UIColor clearColor];
    textField.layer.borderColor = [RTSSAppStyle currentAppStyle].textFieldBorderColor.CGColor;
    textField.layer.borderWidth = 1.0;
    textField.layer.cornerRadius = 5.0;
    textField.clipsToBounds = YES;
    textField.delegate = aDelegate;
    textField.keyboardType = aKeyboardType;
    [bgTextFieldView addSubview:textField];
    [bgTextFieldView release];

    if (flag) {
        UILabel *moneySymbol =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 20, 20)];
        moneySymbol.textAlignment = NSTextAlignmentCenter;
        moneySymbol.text = [NSString stringWithFormat:@"%@ ", NSLocalizedString(@"Currency_Unit", nil)];;    //@"€";
        moneySymbol.textColor =[RTSSAppStyle currentAppStyle].textSubordinateColor;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = moneySymbol;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
        textField.leftView = view;
        textField.leftViewMode = UITextFieldViewModeAlways;
        [view release];
    }
    [blackView  addBottomLine];
    return [textField autorelease];
}

-(UILabel *)serviceViewWithFrame:(CGRect)frame Title:(NSString *)title isShowSelect:(BOOL)show Target:(id)target Action:(SEL)aSel{
    UIView *bgView = [[[UIView alloc] initWithFrame:frame] autorelease];
    bgView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    [self addSubview:bgView];
    CGFloat y = 15.0f;
    UILabel *serviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, y, kRTSSLabelWidth, kRTSSLabelHeight)];
    serviceLabel.text = title;
    serviceLabel.textAlignment = NSTextAlignmentLeft;
    serviceLabel.font = [UIFont systemFontOfSize:15.0f];
    [serviceLabel setTextMainColor];
    [bgView addSubview:serviceLabel];
    [serviceLabel release];
    
        //Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
   // button.backgroundColor = [UIColor greenColor];
    button.frame = CGRectMake(CGRectGetWidth(bgView.frame)-20-30, 0, 50, 50);
    [button addTarget:target action:aSel forControlEvents:UIControlEventTouchUpInside];
     //[button setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
    [button setImage:[UIImage imageNamed:@"common_arrow_down"] forState:UIControlStateNormal];
   
    //[button setBackgroundImage:[UIImage imageNamed:@"common_arrow_down"] forState:UIControlStateNormal];
    if (show) {

        [bgView addSubview:button];
    }
    //info
    UILabel *infoLabel = [[UILabel alloc] init];
    //infoLabel.backgroundColor = [UIColor redColor];
    
    if (show) {
        infoLabel.frame = CGRectMake(CGRectGetMinX(button.frame)-kRTSSLabelWidth-15, y, kRTSSLabelWidth+20, kRTSSLabelHeight);
    }else{
        
        infoLabel.frame =CGRectMake(frame.size.width-kRTSSLabelWidth-10, y, kRTSSLabelWidth, kRTSSLabelHeight);
    }
        infoLabel.textAlignment = NSTextAlignmentRight;
    infoLabel.adjustsFontSizeToFitWidth = YES;
    //infoLabel.text = @"FTTX";
    infoLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    infoLabel.font = [UIFont systemFontOfSize:13.0f];
    [bgView addSubview:infoLabel];
    
    //割线
    [bgView addBottomLine];
    
    return [infoLabel autorelease];
}

-(void)selectTopUpAccountWithframe:(CGRect)frame Title:(NSString *)title Target:(id)target Action:(SEL)aSel{
    UIView *bgView = [[[UIView alloc] initWithFrame:frame] autorelease];
    bgView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    [self addSubview:bgView];
    
    UILabel *topupLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, kRTSSLabelSpacing, kRTSSLabelWidth+50, kRTSSLabelHeight)];
    topupLabel.text = @"Top up the account";
    topupLabel.textAlignment = NSTextAlignmentLeft;
    topupLabel.font = [UIFont systemFontOfSize:15.0f];
    [topupLabel setTextMainColor];
    [bgView addSubview:topupLabel];
    [topupLabel release];
    
    UISwitch *open = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetWidth(bgView.frame)-70, 10, 50, 30)];
    open.on = NO;
    //open.onTintColor = [RTSSAppStyle currentAppStyle].textMajorGreenColor;
    open.tintColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    open.thumbTintColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    [open addTarget:target action:aSel forControlEvents:UIControlEventValueChanged];
    [bgView addSubview:open];
    [open release];
    
    [bgView addBottomLine];
}

-(UILabel *)addLabelWithFrame:(CGRect)aFrame Title:(NSString *)title{
    UIView *bgView = [[[UIView alloc] initWithFrame:aFrame] autorelease];
    bgView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    [self addSubview:bgView];
    
    UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(kRTSSTextFieldlrEdge, kRTSSLabelSpacing, 100, kRTSSLabelHeight)];
    mainLabel.text = title;
    mainLabel.textAlignment = NSTextAlignmentLeft;
    mainLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [mainLabel setTextMainColor];
    mainLabel.font = [UIFont systemFontOfSize:15.0f];
    [bgView addSubview:mainLabel];
    [mainLabel release];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(aFrame.size.width-kRTSSTextFieldlrEdge-kRTSSLabelWidth, kRTSSLabelSpacing, kRTSSLabelWidth, kRTSSLabelHeight)];
    infoLabel.textAlignment = NSTextAlignmentRight;
    infoLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    infoLabel.font = [UIFont systemFontOfSize:15.0f];
    [infoLabel setTextAuxiliaryColor];
    [bgView addSubview:infoLabel];

    [bgView addBottomLine];
    
    return [infoLabel autorelease];
}

-(UILabel *)balanceWithFrame:(CGRect)aFrame TextColor:(UIColor *)aColor TextAlignment:(NSTextAlignment)ATextAligment{
    UIView *bgView = [[[UIView alloc] initWithFrame:aFrame] autorelease];
    bgView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    [self addSubview:bgView];
    CGFloat y = 15.0f;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, y, kRTSSLabelWidth, kRTSSLabelHeight)];
    label.textColor =  aColor;
    label.textAlignment = ATextAligment;
    label.font = [RTSSAppStyle getRTSSFontWithSize:15.0f];
    label.numberOfLines = 1;
    [bgView addSubview:label];
    //割线
    [bgView addBottomLine];
    
    return [label autorelease];
}

-(UIView*)addIntervalViewWithFrame:(CGRect)frame{
    UIView *darkView = [[UIView alloc]initWithFrame:frame];
    darkView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    [darkView addBottomLine];
    [self addSubview:darkView];
    
    return [darkView autorelease];
}
@end
