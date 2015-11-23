//
//  CommonUtils.h
//  RTSS
//
//  Created by shengyp on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductResource.h"

@interface CommonUtils : NSObject

// 创建UIColor
+ (UIColor*)colorWithHexString:(NSString*)hexString;

// 创建UIButton 背景图片
+ (UIButton*)buttonWithType:(UIButtonType)type
                      frame:(CGRect)frame
                      title:(NSString*)title
              bgImageNormal:(UIImage*)bgImageNormal
         bgImageHighlighted:(UIImage*)bgImageHighlighted
            bgImageSelected:(UIImage*)bgImageSelected
                  addTarget:(id)target
                     action:(SEL)action
                        tag:(NSInteger)tag;

// 创建UIButton 内部图片
+ (UIButton*)buttonWithType:(UIButtonType)type
                      frame:(CGRect)frame
                      title:(NSString*)title
                imageNormal:(UIImage*)imageNormal
           imageHighlighted:(UIImage*)imageHighlighted
              imageSelected:(UIImage*)imageSelected
                  addTarget:(id)target
                     action:(SEL)action
                        tag:(NSInteger)tag;
// 创建UIButton 根据色值
+ (UIButton*)buttonWithType:(UIButtonType)type
                      frame:(CGRect)frame
                      title:(NSString*)title
                colorNormal:(UIColor*)colorNormal
           colorHighlighted:(UIColor*)colorHighlighted
              colorSelected:(UIColor*)colorSelected
                  addTarget:(id)target
                     action:(SEL)action
                        tag:(NSInteger)tag;

// 创建UILabel
+ (UILabel*)labelWithFrame:(CGRect)frame text:(NSString*)text textColor:(UIColor*)textColor textFont:(UIFont*)textFont tag:(NSInteger)tag;

// 创建UITextField
+ (UITextField*)textFieldWithFrame:(CGRect)frame text:(NSString*)text textColor:(UIColor*)textColor textFont:(UIFont*)textFont tag:(NSInteger)tag;

// 格式化deviceToken
+ (NSString*)formatDeviceToken:(NSData*)deviceToken;

// 校验新UserID
+ (BOOL)checkNewUserID:(NSString*)userId;

// 校验新用户密码
+ (BOOL)checkNewUserPassword:(NSString*)password;

// 对象是否有效
+ (BOOL)objectIsValid:(id)object;

// 根据流量字节数转换相应的单位的字符串(保留小数点个数)
+ (NSString*)formatDataWithByte:(long long)byte decimals:(int)count unitEnable:(BOOL)enable;

+ (NSString*)formatMoneyWithPenny:(long long)penny decimals:(int)count unitEnable:(BOOL)enable;

+ (NSString*)formatTimeWithSeconds:(long long)secounds decimals:(int)count unitEnable:(BOOL)enable;

+ (NSString*)formatMessageWithValue:(long long)value unitEnable:(BOOL)enable;

+ (NSString*)formatResourcesWithValue:(long long)value unit:(MeasureUnit)unit;
+ (NSString*)formatResourcesWithValue:(long long)value unit:(MeasureUnit)unit unitEnable:(BOOL)enable;

+ (NSString*)formatResourcesWithValue:(long long)value unit:(MeasureUnit)unit decimals:(int)count;
+ (NSString*)formatResourcesWithValue:(long long)value unit:(MeasureUnit)unit decimals:(int)count unitEnable:(BOOL)enable;

// 根据指定单位量值转换相应的的量值
+ (long long)formatDataFromMBToByte:(float)value;

+ (long long)formatMoneyFromYuanToPenny:(float)value;

+ (long long)formatTimeFromMinuteTosecond:(float)value;

+ (long long)formatMessageFromMsgToMsg:(float)value;

+ (long long)formatResourcesValueWithValue:(float)value unit:(MeasureUnit)unit;

//流量数据类型转换
+ (float)formatDataFromByteToMB:(long long)byteDataAmount;

//money 类型转换
+ (float)formatMoneyFromPennyToYuan:(long long)pennyMoneyAmount;

//time 类型转换
+ (float)formatTimeFromSecondToMinute:(long long)secondTimeAmount;

//根据传入的最小单位量和单位类型，返回mb,minute..等类型
+(float)getUnitConverteValue:(float)value AndUnit:(MeasureUnit) unitType;

+(long long)getUnitConverteOrgValue:(float)value AndUnit:(MeasureUnit) unitType;

//根据类型，返回单位名称
+(NSString *)getUnitName:(MeasureUnit)type;

//根据输入值及目标单位转化成目标值
//现只对标准单位值之间转换(data:MB->b voice:Min->sec money:yuan->fen)
+ (long long)convertCurrentValue:(long long)curValue toTargetUnit:(MeasureUnit)targetUnit;

//计算文本大小
+ (CGSize)calculateTextSize:(NSString *)textString constrainedSize:(CGSize)size textFontSize:(CGFloat)fontSize lineBreakMode:(NSLineBreakMode)breakMode;

+ (CGSize)calculateTextSize:(NSString *)textString constrainedSize:(CGSize)size textFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)breakMode;

//根据传入的单位量和单位类型，返回(B,KB,MB,GB,TB),minute..等类型;
+(NSDictionary *)getValueAndUnitByConverteValue:(float)value AndUnit:(MeasureUnit) unitType;

@end
