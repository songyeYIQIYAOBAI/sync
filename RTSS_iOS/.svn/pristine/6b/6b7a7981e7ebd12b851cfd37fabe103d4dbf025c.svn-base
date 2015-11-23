//
//  DateUtils.m
//  SJB
//
//  Created by sheng yinpeng on 13-7-10.
//  Copyright (c) 2013年 sheng yinpeng. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

// NSDate转NSString
+ (NSString*)getStringDateByDate:(NSDate*)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return dateString;
}

// NSDate转NSString(带格式的转换:@"yyyy-MM-dd HH:mm:ss")
+ (NSString*)getStringDateByDate:(NSDate *)date dateFormat:(NSString*)string
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:string];
    NSString* dateString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return dateString;
}

// 当前系统时间
+ (NSString*)getCurrentSystemDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    if(nil == dateString){
        dateString = @"1900-01-01 00:00:00";
    }
    return dateString;
}

// 当月第一天
+ (NSDate*)getFirstDayByMonth
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents* comps = [cal components:unitFlags fromDate:[NSDate date]];
    comps.day = 1;
    NSDate* firstDay = [cal dateFromComponents:comps];
    return firstDay;
}

// 当月最后一天
+ (NSDate*)getLastDayByMonth
{
	NSCalendar* cal = [NSCalendar currentCalendar];
	NSDate* currentDate = [NSDate date];
	NSRange range = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:currentDate];
	NSUInteger numberOfDaysInMonth = range.length;
	
	NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit  | NSDayCalendarUnit |
	                       NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	NSDateComponents* comps = [cal components:unitFlags fromDate:currentDate];
	comps.day = numberOfDaysInMonth;
	comps.hour = 0;
	comps.minute = 0;
	comps.second = 0;
	
	return [cal dateFromComponents:comps];
}

// 获取本月的天数
+ (NSInteger)getNumbersOfDaysByMonth
{
	NSCalendar* cal = [NSCalendar currentCalendar];
	NSDate* currentDate = [NSDate date];
	NSRange range = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:currentDate];
	NSUInteger numberOfDaysInMonth = range.length;
	return numberOfDaysInMonth;
}

// 当天距离当月最后一天还有几天
+ (NSInteger)getNumbersOfDaysToLastDay
{
	NSCalendar* cal = [NSCalendar currentCalendar];
	NSDate* currentDate = [NSDate date];
	NSRange range = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:currentDate];
	NSUInteger numberOfDaysInMonth = range.length;
	
	NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit  | NSDayCalendarUnit |
	NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	NSDateComponents* comps = [cal components:unitFlags fromDate:currentDate];
	
	return (numberOfDaysInMonth-comps.day)+1;
}

// 当月的第几天
+ (NSDate*)getDateByDay:(NSInteger)day
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit  | NSDayCalendarUnit |
                           NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* comps = [cal components:unitFlags fromDate:[NSDate date]];
    comps.day = day;
    comps.hour = 8;
    comps.minute = 0;
    comps.second = 0;
    NSDate* date = [cal dateFromComponents:comps];
    return date;
}

// 是否是相同年月
+ (BOOL)isSameYearMonth:(NSDate*)start endDate:(NSDate*)end
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents* startComps = [cal components:unitFlags fromDate:start];
    NSDateComponents* endComps = [cal components:unitFlags fromDate:end];
    
    NSInteger startYear = startComps.year;
    NSInteger startMonth = startComps.month;
    
    NSInteger endYear = endComps.year;
    NSInteger endMonth = endComps.month;
    
    if(startYear == endYear && startMonth == endMonth){
        return YES;
    }
    return NO;
}

// 比较两个时间相差（分钟/小时/天/月/年）
+ (NSString*)compareDiffer:(NSDate*)fromDate toDate:(NSDate*)toDate
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit  | NSDayCalendarUnit |
                           NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents* components = [calendar components:unitFlags fromDate:fromDate toDate:toDate options:0];
    NSInteger year = components.year;
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    //NSInteger second = [components second];
    
    if(year > 0 || year < 0){
        return [NSString stringWithFormat:@"%d年",abs((int)year)];
    }
    if(month > 0 || month < 0){
        return [NSString stringWithFormat:@"%d月",abs((int)month)];
    }
    if(day > 0 || day < 0){
        return [NSString stringWithFormat:@"%d天",abs((int)day)];
    }
    if(hour > 0 || hour < 0){
        return [NSString stringWithFormat:@"%d小时",abs((int)hour)];
    }
    if(minute > 0 || minute < 0){
        return [NSString stringWithFormat:@"%d分钟",abs((int)minute)];
    }
    return [NSString stringWithFormat:@"%d分钟",1];
}

// 比较两个时间是否相差多少分钟分钟
+ (BOOL)compareDifferMinute:(NSDate*)fromDate toDate:(NSDate*)toDate minute:(NSInteger)minutes
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit  | NSDayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    if(nil == fromDate) fromDate = [NSDate date];
    if(nil == toDate) toDate = [NSDate date];
    NSDateComponents* components = [calendar components:unitFlags fromDate:fromDate toDate:toDate options:0];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    if(abs((int)year) > 0 || abs((int)month) > 0 || abs((int)day) > 0 || abs((int)hour) > 0 || abs((int)minute) >= minutes){
        return YES;
    }
    return NO;
}

// 根据基础时间按月间隔计算新的时间(如:间隔1个月,2013-08-23 16:00:00 ---> 2013-09-23 16:00:00)
+ (NSDate*)dateByAddingIntervalMonth:(NSInteger)intervalMonth basicDate:(NSDate*)basicDate
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.month = intervalMonth;
    NSDate* lastDate = [calendar dateByAddingComponents:offsetComponents toDate:basicDate options:0];
    [offsetComponents release];
    return lastDate;
}

/* 两个时间比较(早,晚,相等)(mask YES代表年月日时分秒全量比较,NO代表只按年月日比较)
 *(fromDate > toDate:NSOrderedDescending)降序
 *(fromDate < toDate:NSOrderedAscending)升序
 *(fromDate = toDate:NSOrderedSame)相等
 */
+ (NSComparisonResult)compareFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate isAll:(BOOL)mask
{
    if(mask){
        NSString* fromDateString = [DateUtils getStringDateByDate:fromDate dateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* toDateString = [DateUtils getStringDateByDate:toDate dateFormat:@"yyyy-MM-dd HH:mm:ss"];
        return [fromDateString compare:toDateString];
    }else{
        NSString* fromDateString = [DateUtils getStringDateByDate:fromDate dateFormat:@"yyyy-MM-dd"];
        NSString* toDateString = [DateUtils getStringDateByDate:toDate dateFormat:@"yyyy-MM-dd"];
        return [fromDateString compare:toDateString];
    }
}

+ (NSString *)intervalSinceNowWithDate: (NSDate *) date
{
    NSTimeInterval late = [date timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    NSString *timeString = @"1分钟";
    
    NSTimeInterval cha = now - late;
    if (cha <= 0) {
        return timeString;
    }
    
    if (cha / 3600 < 1) {
        timeString = [NSString stringWithFormat:@"%f", cha / 60];
        timeString = [timeString substringToIndex:timeString.length - 7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        
    }else if (cha / 3600 > 1 && cha / 86400 < 1) {
        timeString = [NSString stringWithFormat:@"%f", cha / 3600];
        timeString = [timeString substringToIndex:timeString.length - 7];
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
    }else if (cha / 86400 > 1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha / 86400];
        timeString = [timeString substringToIndex:timeString.length - 7];
        timeString = [NSString stringWithFormat:@"%@天前", timeString];
        
    }
    
    return timeString;
}

+ (NSString *)intervalSinceNowWithFormatDate: (NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    return  [DateUtils intervalSinceNowWithDate:d];
}


#pragma Mark -- 获取上一个月和下一个月
+(NSDate *) dateByAddingMonths: (NSInteger) dMonths by:(NSDate*)aDate{
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:dMonths];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:aDate options:0];
    [dateComponents release];
    return newDate;
}
+(NSDate *) dateBySubtractingMonths: (NSInteger) dMonths by:(NSDate*)aDate{
    
    return [DateUtils dateByAddingMonths:-dMonths by:aDate];
}

static const unsigned componentFlags = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit);

+ (NSCalendar *) currentCalendar
{
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}


+ (NSInteger) monthBy:(NSDate*)aDate
{
	NSDateComponents *components = [[NSCalendar currentCalendar] components:componentFlags fromDate:aDate];
	return components.month;
}

+(NSDate*)dateByDateString:(NSString*)aDateString UseFormatString:(NSString*)formatString;{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:formatString];
    NSDate *date =[formatter dateFromString:aDateString];
    [formatter release];
    return date;
}
#pragma mark --days
+(NSDate *)dateWithDaysFromDate:(NSDate *)aDate ByAddingDays:(NSInteger)dDays
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:aDate options:0];
    [dateComponents release];
    return newDate;
}

+(NSDate *)dateWithDaysFromDate:(NSDate *)aDate BySubtractingDays:(NSInteger)dDays
{
    return [DateUtils dateWithDaysFromDate:aDate ByAddingDays:(dDays*-1)];
}


#pragma --mark --date


+(NSDate *) dateAtStartOfDayByDate:(NSDate*)date{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* components = [cal components:componentFlags fromDate:date];
    components.day = 1;
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    NSDate* firstDay = [cal dateFromComponents:components];
    return firstDay;
    return [cal dateFromComponents:components];
    
}

+(NSDate *) dateAtEndOfDayByDate:(NSDate*)date{
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSRange range = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    NSUInteger numberOfDaysInMonth = range.length;
    
    NSDateComponents *components = [cal components:componentFlags fromDate:date];
    components.day = numberOfDaysInMonth;
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    return [cal dateFromComponents:components];
    
}



@end
