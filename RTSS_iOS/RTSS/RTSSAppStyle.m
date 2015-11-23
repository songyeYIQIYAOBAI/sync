//
//  RTSSAppStyle.m
//  RTSS
//
//  Created by shengyp on 14/10/27.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "RTSSAppStyle.h"
#import "CommonUtils.h"
#import "ImageUtils.h"

#define SERVICE_MOBILE_DATA_TYPE_KEY                     @"Z0002"
#define SERVICE_VOLTE_TYPE_KEY                           @"Z0003"
#define SERVICE_MIFI_TYPE_KEY                            @"Z0004"
#define SERVICE_FTTX_TYPE_KEY                            @"Z0005"
#define SERVICE_WIFI_TYPE_KEY                            @"Z0006"

static RTSSAppStyle* mAppStyle = nil;

@interface RTSSAppStyle ()

@property(nonatomic, retain) NSMutableDictionary*   serviceTypeDic;

@end

@implementation RTSSAppStyle

@synthesize navigationBarColor, navigationTitleFont, viewControllerBgColor, pouringWatterColor, separatorColor;
@synthesize buttonMajorColor;
@synthesize textMajorColor, textSubordinateColor,textBlueColor, textGreenColor;
@synthesize textFieldBgColor,textFieldBorderColor, textFieldPlaceholderColor, textFieldPlaceholderFont;
@synthesize portraitBorderColor, portraitBgColor;
@synthesize userInfoComponentErrorColor, userInfoComponentBgColor;
@synthesize currentPageIndicatorTintColor, pageIndicatorTintColor;
@synthesize cellUnSelectedColor, cellSelectedColor;

@synthesize homeViewResourcePanelColor;

@synthesize radarColor, radarSelectedItemColor, radarUnSelectedItemColor, radarPortraitBgColor;

@synthesize loginPortraitBgColor;

@synthesize personCenterCellBgColor;

@synthesize textMajorGreenColor, messageNeverReadTextColor;
@synthesize transactionFromMeTextColor,transactionFromOtherTextColor;
@synthesize turboBoostBoderColor, turboBoostUnfoldBgColor, turboBoostButtonBgGrayColor,turboBoostButtonBgGreenColor;
@synthesize budgetControlButtonStrokeColor;
@synthesize walletTitleOrgangeColor, walletTitleBlueColor;
@synthesize commonGreenButtonNormalColor, commonGreenButtonHighlightColor;
@synthesize separationBgColor;

@synthesize serviceTypeDic;

- (void)dealloc{
    [navigationBarColor release];
    [navigationTitleFont release];
    [viewControllerBgColor release];
    [pouringWatterColor release];
    [separatorColor release];
    [buttonMajorColor release];
    [textMajorColor release];
    [textSubordinateColor release];
    [textBlueColor release];
    [textGreenColor release];
    [textFieldBgColor release];
    [textFieldBorderColor release];
    [textFieldPlaceholderColor release];
    [textFieldPlaceholderFont release];
    [portraitBorderColor release];
    [portraitBgColor release];
    [userInfoComponentErrorColor release];
    [userInfoComponentBgColor release];
    [currentPageIndicatorTintColor release];
    [pageIndicatorTintColor release];
    [cellUnSelectedColor release];
    [cellSelectedColor release];
    
    [homeViewResourcePanelColor release];
    
    [radarColor release];
    [radarSelectedItemColor release];
    [radarUnSelectedItemColor release];
    [radarPortraitBgColor release];
    
    [loginPortraitBgColor release];
    
    [personCenterCellBgColor release];
    
    [messageNeverReadTextColor release];
    [textMajorGreenColor release];
    [transactionFromMeTextColor release];
    [transactionFromOtherTextColor release];
    
    [turboBoostUnfoldBgColor release];
    [turboBoostBoderColor release];
    [turboBoostButtonBgGreenColor release];
    [turboBoostButtonBgGrayColor release];
    
    [budgetControlButtonStrokeColor release];
    
    [walletTitleBlueColor release];
    [walletTitleOrgangeColor release];
    
    [commonGreenButtonHighlightColor release];
    [commonGreenButtonNormalColor release];
    
    [separationBgColor release];
    
    
    [serviceTypeDic release];
    
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initColor];
        [self initServiceSource];
    }
    return self;
}

- (void)initColor{
    self.navigationBarColor                 = [CommonUtils colorWithHexString:@"#FFFFFF"];
    self.navigationTitleFont                = [RTSSAppStyle getRTSSFontWithSize:20.0];
    self.viewControllerBgColor              = [CommonUtils colorWithHexString:@"#F9F9FB"];
    self.pouringWatterColor                 = [CommonUtils colorWithHexString:@"#99C824"];
    self.separatorColor                     = [CommonUtils colorWithHexString:@"#DCDCDC"];
    
    self.buttonMajorColor                   = [CommonUtils colorWithHexString:@"#FFDC02"];
    
    self.textMajorColor                     = [CommonUtils colorWithHexString:@"#444444"];
    self.textSubordinateColor               = [CommonUtils colorWithHexString:@"#B2BDC1"];
    self.textBlueColor                      = [CommonUtils colorWithHexString:@"#7ECEF4"];
    self.textGreenColor                     = [CommonUtils colorWithHexString:@"#99C824"];
    self.textMajorGreenColor                = [CommonUtils colorWithHexString:@"#87AD2B"];
    
    self.textFieldBgColor                   = [CommonUtils colorWithHexString:@"#F9F9FB"];
    self.textFieldBorderColor               = [CommonUtils colorWithHexString:@"#DCDCDC"];
    self.textFieldPlaceholderColor          = [CommonUtils colorWithHexString:@"#DBDBDB"];
    self.textFieldPlaceholderFont           = [RTSSAppStyle getRTSSFontWithSize:14.0];
    
    self.portraitBgColor                    = [CommonUtils colorWithHexString:@"#F9F9FB"];
    self.portraitBorderColor                = [CommonUtils colorWithHexString:@"#DCDCDC"];
    
    self.userInfoComponentErrorColor        = [UIColor redColor];
    self.userInfoComponentBgColor           = [CommonUtils colorWithHexString:@"#FFFFFF"];
    
    self.pageIndicatorTintColor             = [CommonUtils colorWithHexString:@"#EEEEF0"];
    self.currentPageIndicatorTintColor      = [CommonUtils colorWithHexString:@"#A7A6AB"];
    
    self.cellUnSelectedColor                = [CommonUtils colorWithHexString:@"#FFFFFF"];
    self.cellSelectedColor                  = [CommonUtils colorWithHexString:@"#F9F9FB"];
    
    self.radarColor                         = [CommonUtils colorWithHexString:@"#E5E5E5"];
    self.radarSelectedItemColor             = [CommonUtils colorWithHexString:@"#FFDC02"];
    self.radarUnSelectedItemColor           = [CommonUtils colorWithHexString:@"#DCDCDC"];
    self.radarPortraitBgColor               = [CommonUtils colorWithHexString:@"#FFFFFF"];
    
    self.loginPortraitBgColor               = [CommonUtils colorWithHexString:@"#FFFFFF"];
    
    self.personCenterCellBgColor            = [CommonUtils colorWithHexString:@"#FFFFFF"];
    
    self.messageNeverReadTextColor          = [CommonUtils colorWithHexString:@"#7FBA17"];
    
    self.transactionFromMeTextColor         = [CommonUtils colorWithHexString:@"#7FBA17"];
    self.transactionFromOtherTextColor      = [UIColor orangeColor];
    
    self.turboBoostUnfoldBgColor            = [CommonUtils colorWithHexString:@"#37393D"];
    self.turboBoostBoderColor               = [CommonUtils colorWithHexString:@"#36383B"];
    self.turboBoostButtonBgGrayColor        = [CommonUtils colorWithHexString:@"#46484C"];
    self.turboBoostButtonBgGreenColor       = [CommonUtils colorWithHexString:@"#7FBA17"];
    
    self.budgetControlButtonStrokeColor     = [CommonUtils colorWithHexString:@"#68656f"];
    
    self.walletTitleOrgangeColor            = [CommonUtils colorWithHexString:@"#F49800"];
    self.walletTitleBlueColor               = [CommonUtils colorWithHexString:@"#7ECEF4"];
    
    self.commonGreenButtonNormalColor       = [CommonUtils colorWithHexString:@"#759928"];
    self.commonGreenButtonHighlightColor    = [CommonUtils colorWithHexString:@"#99C824"];
    
    self.separationBgColor                  = [CommonUtils colorWithHexString:@"#434549"];
}

- (UINavigationController*)getRTSSNavigationController:(UIViewController *)rootViewController
{
    UINavigationController* navigationController = [[[UINavigationController alloc] initWithRootViewController:rootViewController] autorelease];
    navigationController.navigationBar.translucent = NO;
    navigationController.navigationBar.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    navigationController.navigationBar.barTintColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    NSDictionary *attributes = @{NSFontAttributeName:[RTSSAppStyle currentAppStyle].navigationTitleFont,
                                 NSForegroundColorAttributeName:[RTSSAppStyle currentAppStyle].textMajorColor};
    navigationController.navigationBar.titleTextAttributes = attributes;
    return navigationController;
}

+ (UIFont*)getRTSSFontWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"RobotoCondensed-Regular" size:fontSize];
}

- (void)initServiceSource{
    self.serviceTypeDic                     = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    /*
    {
        NSMutableDictionary* itemDic = [NSMutableDictionary dictionaryWithCapacity:2];
        [itemDic setObject:@"MIFI" forKey:SERVICE_NAME_KEY];
        [itemDic setObject:[UIImage imageNamed:@"balance_mifi_icon.png"] forKey:SERVICE_ICON_KEY];
        [self.serviceTypeDic setObject:itemDic forKey:SERVICE_MOBILE_DATA_TYPE_KEY];
    }
    {
        NSMutableDictionary* itemDic = [NSMutableDictionary dictionaryWithCapacity:2];
        [itemDic setObject:@"VoLTE" forKey:SERVICE_NAME_KEY];
        [itemDic setObject:[UIImage imageNamed:@"balance_vvm_icon.png"] forKey:SERVICE_ICON_KEY];
        [self.serviceTypeDic setObject:itemDic forKey:SERVICE_VOLTE_TYPE_KEY];
    }
    {
        NSMutableDictionary* itemDic = [NSMutableDictionary dictionaryWithCapacity:2];
        [itemDic setObject:@"LTE-Data" forKey:SERVICE_NAME_KEY];
        [itemDic setObject:[UIImage imageNamed:@"balance_vvm_icon.png"] forKey:SERVICE_ICON_KEY];
        [self.serviceTypeDic setObject:itemDic forKey:SERVICE_MIFI_TYPE_KEY];
    }
    {
        NSMutableDictionary* itemDic = [NSMutableDictionary dictionaryWithCapacity:2];
        [itemDic setObject:@"FTTx" forKey:SERVICE_NAME_KEY];
        [itemDic setObject:[UIImage imageNamed:@"balance_fttx_icon.png"] forKey:SERVICE_ICON_KEY];
        [self.serviceTypeDic setObject:itemDic forKey:SERVICE_FTTX_TYPE_KEY];
    }
    {
        NSMutableDictionary* itemDic = [NSMutableDictionary dictionaryWithCapacity:2];
        [itemDic setObject:@"WIFI" forKey:SERVICE_NAME_KEY];
        [itemDic setObject:[UIImage imageNamed:@"balance_wifi_icon.png"] forKey:SERVICE_ICON_KEY];
        [self.serviceTypeDic setObject:itemDic forKey:SERVICE_WIFI_TYPE_KEY];
    }
     */
}

+ (RTSSAppStyle *)currentAppStyle{
    @synchronized (self){
        if(nil == mAppStyle){
            mAppStyle = [[RTSSAppStyle alloc] init];
        }
    }
    return mAppStyle;
}

- (NSDictionary*)getServiceSourceWithServiceType:(NSString*)serviceType{
    
    NSDictionary* typeDic = [self.serviceTypeDic objectForKey:serviceType];
    if(nil != typeDic){
        return typeDic;
    }
    
    NSMutableDictionary* typeTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [typeTempDic setObject:nil == serviceType ? @"" : serviceType forKey:@""];
    return typeTempDic;
}

+ (UIColor*)getFreeResourceColorWithIndex:(NSInteger)index{
    UIColor* resourceColor = nil;
    switch (index % 8) {
        case 0:{
            resourceColor = [CommonUtils colorWithHexString:@"#99C824"];
            break;
        }
        case 1:{
            resourceColor = [CommonUtils colorWithHexString:@"#1BABE0"];
            break;
        }
        case 2:{
            resourceColor = [CommonUtils colorWithHexString:@"#FF8500"];
            break;
        }
        case 3:{
            resourceColor = [CommonUtils colorWithHexString:@"#2CBAA9"];
            break;
        }
        case 4:{
            resourceColor = [CommonUtils colorWithHexString:@"#E3BF1C"];
            break;
        }
        case 5:{
            resourceColor = [CommonUtils colorWithHexString:@"#E96296"];
            break;
        }
        case 6:{
            resourceColor = [CommonUtils colorWithHexString:@"#B79BFF"];
            break;
        }
        case 7:{
            resourceColor = [CommonUtils colorWithHexString:@"#B28850"];
            break;
        }
        default:{
            resourceColor = [CommonUtils colorWithHexString:@"#99C824"];
            break;
        }
    }
    return resourceColor;
}

+ (UIButton*)getMajorGreenButton:(CGRect)frame target:(id)target action:(SEL)action title:(NSString*)title{
    RTSSAppStyle* style = [RTSSAppStyle currentAppStyle];
    return [RTSSAppStyle getMajorButton:frame target:target action:action title:title bgNormal:style.buttonMajorColor bgHighlighted:style.buttonMajorColor];
}

+ (UIButton*)getMajorButton:(CGRect)frame target:(id)target action:(SEL)action title:(NSString *)title bgNormal:(UIColor*)normal bgHighlighted:(UIColor*)highlighted
{
    UIButton* button = [CommonUtils buttonWithType:UIButtonTypeCustom
                                             frame:frame
                                             title:title
                                     bgImageNormal:[ImageUtils createImageWithColor:normal size:frame.size]
                                bgImageHighlighted:[ImageUtils createImageWithColor:highlighted size:frame.size]
                                   bgImageSelected:nil
                                         addTarget:target
                                            action:action
                                               tag:0];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius  = frame.size.height/2.0;
    button.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:20.0];
    [button setTitleColor:[RTSSAppStyle currentAppStyle].textMajorColor forState:UIControlStateNormal];
    
    return button;
}

@end
