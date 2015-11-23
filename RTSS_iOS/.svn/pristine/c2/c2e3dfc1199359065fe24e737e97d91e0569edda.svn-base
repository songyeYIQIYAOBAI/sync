//
//  EColumnDataModel.h
//  IOS7Test
//
//  Created by shengyp on 14-6-20.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EColumnDataModel : NSObject

// 底部文本
@property (nonatomic, retain) NSString* label;
// 真实数值
@property (nonatomic, assign) CGFloat value;
// 显示数值
@property (nonatomic, retain) NSString* valueString;
// 平均数值
@property (nonatomic, assign) CGFloat averageValue;
// 最大数值
@property (nonatomic, assign) CGFloat maxValue;
// TAG
@property (nonatomic, assign) NSInteger index;
// 单位
@property (nonatomic, retain) NSString* unit;

@property(nonatomic,assign)NSString *groupId;

@property(nonatomic,assign)NSInteger messureId;

@property(nonatomic,copy)NSString *name;




- (id)initWithLabel:(NSString*)aLabel valueText:(NSString*)valueText value:(CGFloat)aValue averageValue:(CGFloat)aAverageValue maxValue:(CGFloat)aMaxValue index:(NSInteger)aIndex unit:(NSString*)aUnit groupId:(NSString*)groupId messureId:(NSInteger)messureId name:(NSString*)name;


/**
 *  类型数值转换
 *
 *  @param numer     使用量
 *  @param messureId  类型ID
 *
 *  @return 返回 转换对应数值类型
 */
//+(float)transformeWithNumerical:(long long)numer byMessureId:(RTSSMessureId)messureId;

@end
