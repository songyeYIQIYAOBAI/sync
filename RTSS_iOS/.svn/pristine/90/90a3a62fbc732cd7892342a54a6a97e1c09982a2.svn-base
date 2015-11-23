//
//  DateUtils.h
//  SJB
//
//  Created by sheng yinpeng on 13-7-10.
//  Copyright (c) 2013年 sheng yinpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

// NSDate转NSString
+ (NSString*)getStringDateByDate:(NSDate*)date;
// NSDate转NSString(带格式的转换:@"yyyy-MM-dd HH:mm:ss")
+ (NSString*)getStringDateByDate:(NSDate *)date dateFormat:(NSString*)string;
// 当前系统时间
+ (NSString*)getCurrentSystemDate;
// 当月第一天
+ (NSDate*)getFirstDayByMonth;
// 当月最后一天
+ (NSDate*)getLastDayByMonth;
// 获取本月的天数
+ (NSInteger)getNumbersOfDaysByMonth;
// 当天距离当月最后一天还有几天
+ (NSInteger)getNumbersOfDaysToLastDay;
// 当月的第几天
+ (NSDate*)getDateByDay:(NSInteger)day;
// 是否是相同年月
+ (BOOL)isSameYearMonth:(NSDate*)start endDate:(NSDate*)end;
// 比较两个时间相差（分钟/小时/天/月/年）
+ (NSString*)compareDiffer:(NSDate*)fromDate toDate:(NSDate*)toDate;
// 比较两个时间是否相差多少分钟分钟
+ (BOOL)compareDifferMinute:(NSDate*)fromDate toDate:(NSDate*)toDate minute:(NSInteger)minutes;
// 根据基础时间按月间隔计算新的时间(如:间隔1个月,2013-08-23 16:00:00 ---> 2013-09-23 16:00:00)
+ (NSDate*)dateByAddingIntervalMonth:(NSInteger)intervalMonth basicDate:(NSDate*)basicDate;
/* 两个时间比较(早,晚,相等)(mask YES代表年月日时分秒全量比较,NO代表只按年月日比较)
 *(fromDate > toDate:NSOrderedDescending)降序
 *(fromDate < toDate:NSOrderedAscending)升序
 *(fromDate = toDate:NSOrderedSame)相等*/
+ (NSComparisonResult)compareFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate isAll:(BOOL)mask;

+ (NSString *)intervalSinceNowWithFormatDate: (NSString *) theDate;
+ (NSString *)intervalSinceNowWithDate: (NSDate *) date;



//@caijie add
/**
 *  更新月
 */
+(NSDate *) dateByAddingMonths: (NSInteger) dMonths by:(NSDate*)aDate;
+(NSDate *) dateBySubtractingMonths: (NSInteger) dMonths by:(NSDate*)aDate;
//根据aDate 获取月份
+ (NSInteger) monthBy:(NSDate*)aDate;

+(NSDate*)dateByDateString:(NSString*)aDateString UseFormatString:(NSString*)formatString;
/**
 *  计算某一日期前后天数间隔的日期(柱状图需要)
 *
 */
+(NSDate *) dateWithDaysFromDate:(NSDate*)aDate ByAddingDays: (NSInteger) dDays;
+(NSDate *) dateWithDaysFromDate:(NSDate*)aDate BySubtractingDays: (NSInteger) dDays;

/**
 *  @author 蔡杰Alan, 15-04-17 10:04:31
 *
 *  @brief  日期  以后迁移到DateUntil
 */

+(NSDate *) dateAtStartOfDayByDate:(NSDate*)date;

+(NSDate *) dateAtEndOfDayByDate:(NSDate*)date;

@end
