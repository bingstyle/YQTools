//
//  NSDate+Utilities_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utilities_yq)

+ (NSCalendar *)yq_currentCalendar; // avoid bottlenecks

#pragma mark ----short time 格式化的时间
@property (nonatomic, readonly) NSString *yq_shortString;
@property (nonatomic, readonly) NSString *yq_shortDateString;
@property (nonatomic, readonly) NSString *yq_shortTimeString;
@property (nonatomic, readonly) NSString *yq_mediumString;
@property (nonatomic, readonly) NSString *yq_mediumDateString;
@property (nonatomic, readonly) NSString *yq_mediumTimeString;
@property (nonatomic, readonly) NSString *yq_longString;
@property (nonatomic, readonly) NSString *yq_longDateString;
@property (nonatomic, readonly) NSString *yq_longTimeString;

///使用dateStyle timeStyle格式化时间
- (NSString *)yq_stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

#pragma mark ---- 从当前日期相对日期时间
///明天
+ (NSDate *)yq_dateTomorrow;
///昨天
+ (NSDate *)yq_dateYesterday;
///今天后几天
+ (NSDate *)yq_dateWithDaysFromNow:(NSInteger)days;
///今天前几天
+ (NSDate *)yq_dateWithDaysBeforeNow:(NSInteger)days;
///当前小时后dHours个小时
+ (NSDate *)yq_dateWithHoursFromNow:(NSInteger)dHours;
///当前小时前dHours个小时
+ (NSDate *)yq_dateWithHoursBeforeNow:(NSInteger)dHours;
///当前分钟后dMinutes个分钟
+ (NSDate *)yq_dateWithMinutesFromNow:(NSInteger)dMinutes;
///当前分钟前dMinutes个分钟
+ (NSDate *)yq_dateWithMinutesBeforeNow:(NSInteger)dMinutes;


#pragma mark ---- Comparing dates 比较时间
///比较年月日是否相等
- (BOOL)yq_isEqualToDateIgnoringTime:(NSDate *)aDate;
///是否是今天
- (BOOL)yq_isToday;
///是否是明天
- (BOOL)yq_isTomorrow;
///是否是昨天
- (BOOL)yq_isYesterday;

///是否是同一周
- (BOOL)yq_isSameWeekAsDate:(NSDate *)aDate;
///是否是本周
- (BOOL)yq_isThisWeek;
///是否是本周的下周
- (BOOL)yq_isNextWeek;
///是否是本周的上周
- (BOOL)yq_isLastWeek;

///是否是同一月
- (BOOL)yq_isSameMonthAsDate:(NSDate *)aDate;
///是否是本月
- (BOOL)yq_isThisMonth;
///是否是本月的下月
- (BOOL)yq_isNextMonth;
///是否是本月的上月
- (BOOL)yq_isLastMonth;

///是否是同一年
- (BOOL)yq_isSameYearAsDate:(NSDate *)aDate;
///是否是今年
- (BOOL)yq_isThisYear;
///是否是今年的下一年
- (BOOL)yq_isNextYear;
///是否是今年的上一年
- (BOOL)yq_isLastYear;

///是否提前aDate
- (BOOL)yq_isEarlierThanDate:(NSDate *)aDate;
///是否晚于aDate
- (BOOL)yq_isLaterThanDate:(NSDate *)aDate;
///是否晚是未来
- (BOOL)yq_isInFuture;
///是否晚是过去
- (BOOL)yq_isInPast;


///是否是工作日
- (BOOL)yq_isTypicallyWorkday;
///是否是周末
- (BOOL)yq_isTypicallyWeekend;

#pragma mark ---- Adjusting dates 调节时间
///增加dYears年
- (NSDate *)yq_dateByAddingYears:(NSInteger)dYears;
///减少dYears年
- (NSDate *)yq_dateBySubtractingYears:(NSInteger)dYears;
///增加dMonths月
- (NSDate *)yq_dateByAddingMonths:(NSInteger)dMonths;
///减少dMonths月
- (NSDate *)yq_dateBySubtractingMonths:(NSInteger)dMonths;
///增加dDays天
- (NSDate *)yq_dateByAddingDays:(NSInteger)dDays;
///减少dDays天
- (NSDate *)yq_dateBySubtractingDays:(NSInteger)dDays;
///增加dHours小时
- (NSDate *)yq_dateByAddingHours:(NSInteger)dHours;
///减少dHours小时
- (NSDate *)yq_dateBySubtractingHours:(NSInteger)dHours;
///增加dMinutes分钟
- (NSDate *)yq_dateByAddingMinutes:(NSInteger)dMinutes;
///减少dMinutes分钟
- (NSDate *)yq_dateBySubtractingMinutes:(NSInteger)dMinutes;


#pragma mark ---- 时间间隔
///比aDate晚多少分钟
- (NSInteger)yq_minutesAfterDate:(NSDate *)aDate;
///比aDate早多少分钟
- (NSInteger)yq_minutesBeforeDate:(NSDate *)aDate;
///比aDate晚多少小时
- (NSInteger)yq_hoursAfterDate:(NSDate *)aDate;
///比aDate早多少小时
- (NSInteger)yq_hoursBeforeDate:(NSDate *)aDate;
///比aDate晚多少天
- (NSInteger)yq_daysAfterDate:(NSDate *)aDate;
///比aDate早多少天
- (NSInteger)yq_daysBeforeDate:(NSDate *)aDate;

///与anotherDate间隔几天
- (NSInteger)yq_distanceDaysToDate:(NSDate *)anotherDate;
///与anotherDate间隔几月
- (NSInteger)yq_distanceMonthsToDate:(NSDate *)anotherDate;
///与anotherDate间隔几年
- (NSInteger)yq_distanceYearsToDate:(NSDate *)anotherDate;

@end
