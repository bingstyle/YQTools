//
//  NSDate+Extension_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension_yq)

/**
 * 获取日、月、年、小时、分钟、秒
 */
- (NSUInteger)yq_day;
- (NSUInteger)yq_month;
- (NSUInteger)yq_year;
- (NSUInteger)yq_hour;
- (NSUInteger)yq_minute;
- (NSUInteger)yq_second;
+ (NSUInteger)yq_day:(NSDate *)date;
+ (NSUInteger)yq_month:(NSDate *)date;
+ (NSUInteger)yq_year:(NSDate *)date;
+ (NSUInteger)yq_hour:(NSDate *)date;
+ (NSUInteger)yq_minute:(NSDate *)date;
+ (NSUInteger)yq_second:(NSDate *)date;

/**
 * 获取一年中的总天数
 */
- (NSUInteger)yq_daysInYear;
+ (NSUInteger)yq_daysInYear:(NSDate *)date;

/**
 * 判断是否是润年
 * @return YES表示润年，NO表示平年
 */
- (BOOL)yq_isLeapYear;
+ (BOOL)yq_isLeapYear:(NSDate *)date;

/**
 * 获取该日期是该年的第几周
 */
- (NSUInteger)yq_weekOfYear;
+ (NSUInteger)yq_weekOfYear:(NSDate *)date;

/**
 * 获取格式化为YYYY-MM-dd格式的日期字符串
 */
- (NSString *)yq_formatYMD;
+ (NSString *)yq_formatYMD:(NSDate *)date;

/**
 * 返回当前月一共有几周(可能为4,5,6)
 */
- (NSUInteger)yq_weeksOfMonth;
+ (NSUInteger)yq_weeksOfMonth:(NSDate *)date;

/**
 * 获取该月的第一天的日期
 */
- (NSDate *)yq_begindayOfMonth;
+ (NSDate *)yq_begindayOfMonth:(NSDate *)date;

/**
 * 获取该月的最后一天的日期
 */
- (NSDate *)yq_lastdayOfMonth;
+ (NSDate *)yq_lastdayOfMonth:(NSDate *)date;

/**
 * 返回day天后的日期(若day为负数,则为|day|天前的日期)
 */
- (NSDate *)yq_dateAfterDay:(NSUInteger)day;
+ (NSDate *)yq_dateAfterDate:(NSDate *)date day:(NSInteger)day;

/**
 * 返回day天后的日期(若day为负数,则为|day|天前的日期)
 */
- (NSDate *)yq_dateAfterMonth:(NSUInteger)month;
+ (NSDate *)yq_dateAfterDate:(NSDate *)date month:(NSInteger)month;

/**
 * 返回numYears年后的日期
 */
- (NSDate *)yq_offsetYears:(int)numYears;
+ (NSDate *)yq_offsetYears:(int)numYears fromDate:(NSDate *)fromDate;

/**
 * 返回numMonths月后的日期
 */
- (NSDate *)yq_offsetMonths:(int)numMonths;
+ (NSDate *)yq_offsetMonths:(int)numMonths fromDate:(NSDate *)fromDate;

/**
 * 返回numDays天后的日期
 */
- (NSDate *)yq_offsetDays:(int)numDays;
+ (NSDate *)yq_offsetDays:(int)numDays fromDate:(NSDate *)fromDate;

/**
 * 返回numHours小时后的日期
 */
- (NSDate *)yq_offsetHours:(int)hours;
+ (NSDate *)yq_offsetHours:(int)numHours fromDate:(NSDate *)fromDate;

/**
 * 距离该日期前几天
 */
- (NSUInteger)yq_daysAgo;
+ (NSUInteger)yq_daysAgo:(NSDate *)date;

/**
 *  获取星期几
 *
 *  @return Return weekday number
 *  [1 - Sunday]
 *  [2 - Monday]
 *  [3 - Tuerday]
 *  [4 - Wednesday]
 *  [5 - Thursday]
 *  [6 - Friday]
 *  [7 - Saturday]
 */
- (NSInteger)yq_weekday;
+ (NSInteger)yq_weekday:(NSDate *)date;

/**
 *  获取星期几(名称)
 *
 *  @return Return weekday as a localized string
 *  [1 - Sunday]
 *  [2 - Monday]
 *  [3 - Tuerday]
 *  [4 - Wednesday]
 *  [5 - Thursday]
 *  [6 - Friday]
 *  [7 - Saturday]
 */
- (NSString *)yq_dayFromWeekday;
+ (NSString *)yq_dayFromWeekday:(NSDate *)date;

/**
 *  日期是否相等
 *
 *  @param anotherDate The another date to compare as NSDate
 *  @return Return YES if is same day, NO if not
 */
- (BOOL)yq_isSameDay:(NSDate *)anotherDate;

/**
 *  是否是今天
 *
 *  @return Return if self is today
 */
- (BOOL)yq_isToday;

/**
 *  Add days to self
 *
 *  @param days The number of days to add
 *  @return Return self by adding the gived days number
 */
- (NSDate *)yq_dateByAddingDays:(NSUInteger)days;

/**
 *  Get the month as a localized string from the given month number
 *
 *  @param month The month to be converted in string
 *  [1 - January]
 *  [2 - February]
 *  [3 - March]
 *  [4 - April]
 *  [5 - May]
 *  [6 - June]
 *  [7 - July]
 *  [8 - August]
 *  [9 - September]
 *  [10 - October]
 *  [11 - November]
 *  [12 - December]
 *
 *  @return Return the given month as a localized string
 */
+ (NSString *)yq_monthWithMonthNumber:(NSInteger)month;

/**
 * 根据日期返回字符串
 */
+ (NSString *)yq_stringWithDate:(NSDate *)date format:(NSString *)format;
- (NSString *)yq_stringWithFormat:(NSString *)format;
+ (NSDate *)yq_dateWithString:(NSString *)string format:(NSString *)format;

/**
 * 获取指定月份的天数
 */
- (NSUInteger)yq_daysInMonth:(NSUInteger)month;
+ (NSUInteger)yq_daysInMonth:(NSDate *)date month:(NSUInteger)month;

/**
 * 获取当前月份的天数
 */
- (NSUInteger)yq_daysInMonth;
+ (NSUInteger)yq_daysInMonth:(NSDate *)date;

/**
 * 返回x分钟前/x小时前/昨天/x天前/x个月前/x年前
 */
- (NSString *)yq_timeInfo;
+ (NSString *)yq_timeInfoWithDate:(NSDate *)date;
+ (NSString *)yq_timeInfoWithDateString:(NSString *)dateString;

/**
 * 分别获取yyyy-MM-dd/HH:mm:ss/yyyy-MM-dd HH:mm:ss格式的字符串
 */
- (NSString *)yq_ymdFormat;
- (NSString *)yq_hmsFormat;
- (NSString *)yq_ymdHmsFormat;
+ (NSString *)yq_ymdFormat;
+ (NSString *)yq_hmsFormat;
+ (NSString *)yq_ymdHmsFormat;

@end
