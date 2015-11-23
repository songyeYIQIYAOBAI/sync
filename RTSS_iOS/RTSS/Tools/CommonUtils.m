//
//  CommonUtils.m
//  RTSS
//
//  Created by shengyp on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "CommonUtils.h"
#import "ImageUtils.h"
#import "RTSSAppDefine.h"

@implementation CommonUtils

+ (UIColor*)colorWithHexString:(NSString*)hexString{
    if(nil == hexString || hexString.length < 7){
        return nil;
    }
    
    unsigned int red, green, blue;
    
    NSRange range = NSMakeRange(1, 2);
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(CGFloat)(red/255.0f) green:(CGFloat)(green/255.0f) blue:(CGFloat)(blue/255.0f) alpha:1.0f];
}

+ (UIButton*)buttonWithType:(UIButtonType)type frame:(CGRect)frame title:(NSString*)title bgImageNormal:(UIImage*)bgImageNormal bgImageHighlighted:(UIImage*)bgImageHighlighted bgImageSelected:(UIImage*)bgImageSelected addTarget:(id)target action:(SEL)action tag:(NSInteger)tag{
    
    UIButton *button = [UIButton buttonWithType:type];
    button.frame = frame;
    button.tag = tag;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if(nil != title){
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if(nil != bgImageNormal){
        [button setBackgroundImage:bgImageNormal forState:UIControlStateNormal];
    }
    if(nil != bgImageHighlighted){
        [button setBackgroundImage:bgImageHighlighted forState:UIControlStateHighlighted];
    }
    if(nil != bgImageSelected){
        [button setBackgroundImage:bgImageSelected forState:UIControlStateSelected];
    }
    
    return button;
}

+ (UIButton*)buttonWithType:(UIButtonType)type frame:(CGRect)frame title:(NSString*)title imageNormal:(UIImage*)imageNormal imageHighlighted:(UIImage*)imageHighlighted imageSelected:(UIImage*)imageSelected addTarget:(id)target action:(SEL)action tag:(NSInteger)tag{
    
    UIButton *button = [UIButton buttonWithType:type];
    button.frame = frame;
    button.tag = tag;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if(nil != title){
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if(nil != imageNormal){
        [button setImage:imageNormal forState:UIControlStateNormal];
    }
    if(nil != imageHighlighted){
        [button setImage:imageHighlighted forState:UIControlStateHighlighted];
    }
    if(nil != imageSelected){
        [button setImage:imageSelected forState:UIControlStateSelected];
    }
    
    return button;
}

+ (UIButton*)buttonWithType:(UIButtonType)type frame:(CGRect)frame title:(NSString*)title colorNormal:(UIColor*)colorNormal colorHighlighted:(UIColor*)colorHighlighted colorSelected:(UIColor*)colorSelected addTarget:(id)target action:(SEL)action tag:(NSInteger)tag{
    
    UIButton* button = [UIButton buttonWithType:type];
    button.frame = frame;
    button.tag = tag;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height);
    if(nil != title){
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if(nil != colorNormal){
        [button setBackgroundImage:[ImageUtils createImageWithColor:colorNormal size:size] forState:UIControlStateNormal];
    }
    if(nil != colorHighlighted){
        [button setBackgroundImage:[ImageUtils createImageWithColor:colorHighlighted size:size] forState:UIControlStateHighlighted];
    }
    if(nil != colorSelected){
        [button setBackgroundImage:[ImageUtils createImageWithColor:colorSelected size:size] forState:UIControlStateSelected];
    }
    
    return button;
}

+ (UILabel*)labelWithFrame:(CGRect)frame text:(NSString*)text textColor:(UIColor*)textColor textFont:(UIFont*)textFont tag:(NSInteger)tag{
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.tag = tag;
    label.text = text;
    label.textColor = textColor;
    label.font = textFont;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    return [label autorelease];
}

+ (UITextField*)textFieldWithFrame:(CGRect)frame text:(NSString*)text textColor:(UIColor*)textColor textFont:(UIFont*)textFont tag:(NSInteger)tag{

    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.tag = tag;
    textField.text = text;
    textField.textColor = textColor;
    textField.font = textFont;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    return [textField autorelease];
}

+ (NSString*)formatDeviceToken:(NSData*)deviceToken{
    NSCharacterSet* cs = [NSCharacterSet characterSetWithCharactersInString:@"< >"];
    return [[[deviceToken description] componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
}

+ (BOOL)checkNewUserID:(NSString*)userId{
    if(nil == userId || 0 == userId.length){
        return NO;
    }
    NSRange range = [userId rangeOfString:@"(?![^a-zA-Z]+$)(?!\\D+$).+" options:NSRegularExpressionSearch];
    return range.location != NSNotFound ? YES : NO;
}

+ (BOOL)checkNewUserPassword:(NSString*)password{
    if(nil == password || 0 == password.length){
        return NO;
    }
    NSRange range = [password rangeOfString:@"^(?![a-zA-Z0-9]+$)(?![^a-zA-Z/D]+$)(?![^0-9/D]+$).{8,30}$" options:NSRegularExpressionSearch];
    return range.location != NSNotFound ? YES : NO;
}

+ (BOOL)objectIsValid:(id)object{
    if([NSNull null] != object && nil != object && [object isKindOfClass:[NSString class]] && ((NSString*)object).length > 0){
        return YES;
    }else if([NSNull null] != object && nil != object && [object isKindOfClass:[NSArray class]] && [(NSArray*)object count] > 0){
        return YES;
    }else if([NSNull null] != object && nil != object && [object isKindOfClass:[NSMutableArray class]] && [(NSMutableArray*)object count] > 0){
        return YES;
    }else if([NSNull null] != object && nil != object && [object isKindOfClass:[NSDictionary class]]){
        return YES;
    }else if([NSNull null] != object && nil != object && [object isKindOfClass:[NSMutableDictionary class]]){
        return YES;
    }else {
        return NO;
    }
}

#pragma mark 根据量值转换相应的单位的字符串(保留小数点个数)
+ (NSString*)formatDataWithByte:(long long)byte decimals:(int)count unitEnable:(BOOL)enable{
    
    long long _1KBValue   = RTSS_1KB_VALUE;
    long long _1MBValue   = RTSS_1MB_VALUE;
    long long _1GBValue   = RTSS_1GB_VALUE;
    long long _1TBValue   = RTSS_1TB_VALUE;
    
    NSString* realUnit    = RTSS_1BYTE_UNIT;
    float realTemp        = byte*1.0;
    
    if(byte < _1KBValue){
        realUnit = RTSS_1BYTE_UNIT;
        realTemp = byte*1.0;
    }else if(byte >= _1KBValue && byte < _1MBValue){
        realUnit = RTSS_1KB_UNIT;
        realTemp = (byte*1.0/_1KBValue);
    }else if(byte >= _1MBValue && byte < _1GBValue){
        realUnit = RTSS_1MB_UNIT;
        realTemp = (byte*1.0/_1MBValue);
    }else if(byte >= _1GBValue && byte < _1TBValue){
        realUnit = RTSS_1GB_UNIT;
        realTemp = (byte*1.0/_1GBValue);
    }else if(byte >= _1TBValue){
        realUnit = RTSS_1TB_UNIT;
        realTemp = (byte*1.0/_1TBValue);
    }
    
    NSString* formatString = [NSString stringWithFormat:@"%%0.%df %@", count,realUnit];
    if(NO == enable){
        formatString = [NSString stringWithFormat:@"%%0.%df", count];
    }
    return [NSString stringWithFormat:formatString,realTemp];
}

+ (NSString*)formatMoneyWithPenny:(long long)penny decimals:(int)count unitEnable:(BOOL)enable{
    
    NSString* realUnit      = NSLocalizedString(@"Currency_Unit", nil);
    double realTemp         = penny*1.0/RTSS_1YUAN_VALUE;
    
    NSString* formatString = [NSString stringWithFormat:@"%@%%0.%df", realUnit,count];
    if(NO == enable){
        formatString = [NSString stringWithFormat:@"%%0.%df", count];
    }
    return [NSString stringWithFormat:formatString, realTemp];
}

+ (NSString*)formatTimeWithSeconds:(long long)secounds decimals:(int)count unitEnable:(BOOL)enable{
    
    long long _1MinValue    = RTSS_1MINUTE_VALUE;
    
    NSString* realUnit      = RTSS_1SECOND_UNIT;
    double realTemp         = secounds*1.0;
    
    if (secounds < _1MinValue) {
        realUnit = RTSS_1SECOND_UNIT;
        realTemp = secounds*1.0;
    }else{
        realUnit = RTSS_1MINUTE_UNIT;
        realTemp = secounds*1.0/_1MinValue;
    }
    
    NSString* formatString = [NSString stringWithFormat:@"%%0.%df %@", count,realUnit];
    if(NO == enable){
        formatString = [NSString stringWithFormat:@"%%0.%df", count];
    }
    
    return [NSString stringWithFormat:formatString, realTemp];
}

+ (NSString*)formatMessageWithValue:(long long)value unitEnable:(BOOL)enable{
    NSString* realUnit      = RTSS_1MSG_UNIT;
    
    if(YES == enable){
        return [NSString stringWithFormat:@"%lld %@", value, realUnit];
    }else{
        return [NSString stringWithFormat:@"%lld ", value];
    }
}

+ (NSString*)formatResourcesWithValue:(long long)value unit:(MeasureUnit)unit
{
    return [CommonUtils formatResourcesWithValue:value unit:unit unitEnable:YES];
}

+ (NSString*)formatResourcesWithValue:(long long)value unit:(MeasureUnit)unit unitEnable:(BOOL)enable
{
    NSString* resultString = @"0";
    switch (unit) {
        case UnitForDataAmount:
            resultString = [CommonUtils formatDataWithByte:value decimals:0 unitEnable:enable];
            break;
        case UnitForMessageAmount:
            resultString = [CommonUtils formatMessageWithValue:value unitEnable:enable];
            break;
        case UnitForTime:
            resultString = [CommonUtils formatTimeWithSeconds:value decimals:0 unitEnable:enable];
            break;
        case UnitForMoney:
            resultString = [CommonUtils formatMoneyWithPenny:value decimals:2 unitEnable:enable];
            break;
        default:
            break;
    }
    
    return resultString;
}

+ (NSString*)formatResourcesWithValue:(long long)value unit:(MeasureUnit)unit decimals:(int)count
{
    return [CommonUtils formatResourcesWithValue:value unit:unit decimals:count unitEnable:YES];
}

+ (NSString*)formatResourcesWithValue:(long long)value unit:(MeasureUnit)unit decimals:(int)count unitEnable:(BOOL)enable
{
    NSString* resultString = @"0";
    switch (unit) {
        case UnitForDataAmount:
            resultString = [CommonUtils formatDataWithByte:value decimals:count unitEnable:enable];
            break;
        case UnitForMessageAmount:
            resultString = [CommonUtils formatMessageWithValue:value unitEnable:enable];
            break;
        case UnitForTime:
            resultString = [CommonUtils formatTimeWithSeconds:value decimals:count unitEnable:enable];
            break;
        case UnitForMoney:
            resultString = [CommonUtils formatMoneyWithPenny:value decimals:count unitEnable:enable];
            break;
        default:
            break;
    }
    
    return resultString;
}

#pragma mark  根据指定单位量值转换相应的的量值
+ (long long)formatDataFromMBToByte:(float)value
{
    return (long long)value*RTSS_1MB_VALUE;
}

+ (long long)formatMoneyFromYuanToPenny:(float)value
{
    return (long long)value*RTSS_1YUAN_VALUE;
}

+ (long long)formatTimeFromMinuteTosecond:(float)value
{
    return (long long)value*RTSS_1MINUTE_VALUE;
}

+ (long long)formatMessageFromMsgToMsg:(float)value
{
    return (long long)value*RTSS_1MSG_VALUE;
}

+ (long long)formatResourcesValueWithValue:(float)value unit:(MeasureUnit)unit
{
    long long resultValue = 0;
    switch (unit) {
        case UnitForDataAmount:
            resultValue = [CommonUtils formatDataFromMBToByte:value];
            break;
        case UnitForMessageAmount:
            resultValue = [CommonUtils formatMessageFromMsgToMsg:value];
            break;
        case UnitForTime:
            resultValue = [CommonUtils formatTimeFromMinuteTosecond:value];
            break;
        case UnitForMoney:
            resultValue = [CommonUtils formatMoneyFromYuanToPenny:value];
            break;
        default:
            break;
    }
    
    return resultValue;
}

+ (float)formatDataFromByteToMB:(long long)byteDataAmount {
    return byteDataAmount * 1.0 / RTSS_1MB_VALUE;
}

+ (float)formatMoneyFromPennyToYuan:(long long)pennyMoneyAmount {
    return pennyMoneyAmount * 1.0 / RTSS_1YUAN_VALUE;
}

+ (float)formatTimeFromSecondToMinute:(long long)secondTimeAmount {
    return secondTimeAmount * 1.0 / RTSS_1MINUTE_VALUE;
}

#pragma mark calculate size
+ (CGSize)calculateTextSize:(NSString *)textString constrainedSize:(CGSize)size textFontSize:(CGFloat)fontSize lineBreakMode:(NSLineBreakMode)breakMode {
    return [CommonUtils calculateTextSize:textString constrainedSize:size textFont:[UIFont systemFontOfSize:fontSize] lineBreakMode:breakMode];
}

+ (CGSize)calculateTextSize:(NSString *)textString constrainedSize:(CGSize)size textFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)breakMode {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = breakMode;
    CGFloat systemVersion = SYSTEM_VERSION_FLOAT;
    CGSize textSize = CGSizeZero;
    if (systemVersion >= 7.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        textSize = [textString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
#else
        textSize = [textString sizeWithFont:font constrainedToSize:size lineBreakMode:breakMode];
        
#endif
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
        textSize = [textString sizeWithFont:font constrainedToSize:size lineBreakMode:breakMode];
#endif
    }
    [paragraphStyle release];
    return textSize;

}

+(NSDictionary *)getValueAndUnitByConverteValue:(float)value AndUnit:(MeasureUnit) unitType
{
    float resultValue = 0.0f;
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithCapacity:2];
    switch (unitType) {
        case UnitForDataAmount: {
            if (value < RTSS_1KB_VALUE) {
                resultValue = value;
                [resultDic setObject:[NSNumber numberWithFloat:resultValue] forKey:@"resultValue"];
                [resultDic setObject:@"B" forKey:@"resultUnit"];
                break;
            } else if (value < RTSS_1MB_VALUE && value >= RTSS_1KB_VALUE){
                resultValue = value/RTSS_1KB_VALUE;
                [resultDic setObject:[NSNumber numberWithFloat:resultValue] forKey:@"resultValue"];
                [resultDic setObject:@"KB" forKey:@"resultUnit"];
                break;
            }   else if (value < RTSS_1GB_VALUE && value >= RTSS_1MB_VALUE){
                resultValue = value/RTSS_1MB_VALUE;
                [resultDic setObject:[NSNumber numberWithFloat:resultValue] forKey:@"resultValue"];
                [resultDic setObject:@"MB" forKey:@"resultUnit"];
                break;
            }   else if (value < RTSS_1TB_VALUE && value >= RTSS_1GB_VALUE){
                resultValue = value/RTSS_1GB_VALUE;
                [resultDic setObject:[NSNumber numberWithFloat:resultValue] forKey:@"resultValue"];
                [resultDic setObject:@"GB" forKey:@"resultUnit"];
                break;
            } else {
                resultValue = value/RTSS_1TB_VALUE;
                [resultDic setObject:[NSNumber numberWithFloat:resultValue] forKey:@"resultValue"];
                [resultDic setObject:@"TB" forKey:@"resultUnit"];
                break;
            }
        }
        case UnitForMoney: {
            resultValue = value/RTSS_1YUAN_VALUE;
            [resultDic setObject:[NSNumber numberWithFloat:resultValue] forKey:@"resultValue"];
            [resultDic setObject:@"€" forKey:@"resultUnit"];
            break;
        }
        case UnitForTime: {
            if (value < RTSS_1MINUTE_VALUE) {
                resultValue = value;
                [resultDic setObject:[NSNumber numberWithFloat:resultValue] forKey:@"resultValue"];
                [resultDic setObject:@"Sec" forKey:@"resultUnit"];
                break;
            } else if (value < RTSS_1HOUR_VALUE && value >= RTSS_1MINUTE_VALUE){
                resultValue = value/RTSS_1MINUTE_VALUE;
                [resultDic setObject:[NSNumber numberWithFloat:resultValue] forKey:@"resultValue"];
                [resultDic setObject:@"Min" forKey:@"resultUnit"];
                break;
            } else if (value < RTSS_1DAY_VALUE && value >= RTSS_1HOUR_VALUE){
                resultValue = value/RTSS_1HOUR_VALUE;
                [resultDic setObject:[NSNumber numberWithFloat:resultValue] forKey:@"resultValue"];
                [resultDic setObject:@"Hour" forKey:@"resultUnit"];
                break;
            } else {
                resultValue = value/RTSS_1DAY_VALUE;
                [resultDic setObject:[NSNumber numberWithFloat:resultValue] forKey:@"resultValue"];
                [resultDic setObject:@"Day" forKey:@"resultUnit"];
                break;
            }
        }
        case UnitForMessageAmount: {
            resultValue = value;
            [resultDic setObject:[NSNumber numberWithFloat:resultValue] forKey:@"resultValue"];
            [resultDic setObject:@"Msg" forKey:@"resultUnit"];
            break;
        }
        default:{
            resultValue = value;
            [resultDic setObject:[NSNumber numberWithFloat:resultValue] forKey:@"resultValue"];
            [resultDic setObject:@"" forKey:@"resultUnit"];
        
        }
            break;
    }
    return (NSDictionary *)[resultDic autorelease];
}

+ (float)getUnitConverteValue:(float)value AndUnit:(MeasureUnit) unitType
{
    float resultValue = 0.0f;
    switch (unitType) {
        case UnitForDataAmount:
            resultValue = value/RTSS_1MB_VALUE;
            break;
        case UnitForMoney:
            resultValue = value/RTSS_1YUAN_VALUE;
            break;
        case UnitForTime:
            resultValue = value/RTSS_1MINUTE_VALUE;
            break;
        case UnitForMessageAmount:
            resultValue = value;
            break;
        default:
            break;
    }
    return resultValue;
}
+(long long)getUnitConverteOrgValue:(float)value AndUnit:(MeasureUnit)unitType{
    
    long long resultValue = 0.0f;
    switch (unitType) {
        case UnitForDataAmount:
            resultValue = (long long)(value*RTSS_1MB_VALUE) ;
            break;
        case UnitForMoney:
            resultValue = (long long)value*RTSS_1YUAN_VALUE;
            break;
        case UnitForTime:
            resultValue = (long long)value*RTSS_1MINUTE_VALUE;
            break;
        case UnitForMessageAmount:
            resultValue = (long long)value;
            break;
        default:
            break;
    }
    return resultValue;
}

+ (long long)convertCurrentValue:(long long)curValue toTargetUnit:(MeasureUnit)targetUnit {
    long long resultVale = curValue;
    switch (targetUnit) {
        case UnitForDataAmount:
        {
            resultVale = curValue * RTSS_1MB_VALUE;
        }
            break;
        case UnitForMoney:
        {
            resultVale = curValue * RTSS_1YUAN_VALUE;
        }
            break;
        case UnitForTime:
        {
            resultVale = curValue * RTSS_1MINUTE_VALUE;
        }
            break;
        case UnitForMessageAmount:
        {
            resultVale = curValue;
        }
            break;
        default:
            break;
    }
    return resultVale;
}

+(NSString *)getUnitName:(MeasureUnit)type
{
    NSString* unitString = @"";
    switch (type) {
        case UnitForDataAmount:
        {
            unitString =  @"MB";
            break;
        }
        case UnitForMoney:
        {
            unitString = @"€";
            break;
        }
        case UnitForTime:
        {
            unitString = @"Min";
            break;
        }
        case UnitForMessageAmount:
        {
            unitString = @"Msg";
            break;
        }
        default:
            break;
    }
    return unitString;
}


@end
