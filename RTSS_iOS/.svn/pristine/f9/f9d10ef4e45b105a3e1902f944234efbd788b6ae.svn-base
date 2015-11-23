//
//  UsageModel.h
//  RTSS
//
//  Created by 蔡杰Alan on 14-12-6.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *
 *  1：数据单位（B）  --->Data
 2：金额单位（分)
 3：时间单位（秒） --->voice
 4：消息单位（条quantity  items） --->SMS
 */

typedef NS_ENUM(NSInteger, RTSSMessureId){
    RTSSMessureIdData =1,
    RTSSMessureIdAmount = 2,
    RTSSMessureIdTime = 3,
    RTSSMessureIdSMS = 4,
};
@interface UsageModel : NSObject

/**
 *  类型数值转换
 *
 *  @param numer     使用量
 *  @param messureId  类型ID
 *
 *  @return 返回 转换对应数值类型
 */
+(float)transformeWithNumerical:(long long)numer byMessureId:(RTSSMessureId)messureId;

/**
 *  根据MessureId 获取相应地单位字符串
 *
 *  @param MessureId  类型ID
 *
 *  @return 返回单位字符串
 */
+(NSString*)unitByMessureId:(RTSSMessureId)MessureId;


@end
