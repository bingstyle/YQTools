//
//  NSDate+Extension_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "NSDate+Extension_yq.h"

@implementation NSDate (Extension_yq)

- (NSUInteger)yq_day {
    return [NSDate yq_day:self];
}

- (NSUInteger)yq_month {
    return [NSDate yq_month:self];
}

- (NSUInteger)yq_year {
    return [NSDate yq_year:self];
}

- (NSUInteger)yq_hour {
    return [NSDate yq_hour:self];
}

- (NSUInteger)yq_minute {
    return [NSDate yq_minute:self];
}

- (NSUInteger)yq_second {
    return [NSDate yq_second:self];
}

+ (NSUInteger)yq_day:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitDay) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:date];
#endif
    
    return [dayComponents day];
}

+ (NSUInteger)yq_month:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMonth) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:date];
#endif
    
    return [dayComponents month];
}

+ (NSUInteger)yq_year:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitYear) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:date];
#endif
    
    return [dayComponents year];
}

+ (NSUInteger)yq_hour:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitHour) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSHourCalendarUnit) fromDate:date];
#endif
    
    return [dayComponents hour];
}

+ (NSUInteger)yq_minute:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMinute) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSMinuteCalendarUnit) fromDate:date];
#endif
    
    return [dayComponents minute];
}

+ (NSUInteger)yq_second:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitSecond) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSSecondCalendarUnit) fromDate:date];
#endif
    
    return [dayComponents second];
}

- (NSUInteger)yq_daysInYear {
    return [NSDate yq_daysInYear:self];
}

+ (NSUInteger)yq_daysInYear:(NSDate *)date {
    return [self yq_isLeapYear:date] ? 366 : 365;
}

- (BOOL)yq_isLeapYear {
    return [NSDate yq_isLeapYear:self];
}

+ (BOOL)yq_isLeapYear:(NSDate *)date {
    NSUInteger year = [date yq_year];
    if ((year % 4  == 0 && year % 100 != 0) || year % 400 == 0) {
        return YES;
    }
    return NO;
}

- (NSString *)yq_formatYMD {
    return [NSDate yq_formatYMD:self];
}

+ (NSString *)yq_formatYMD:(NSDate *)date {
    return [NSString stringWithFormat:@"%tu-%02tu-%02tu",[date yq_year], [date yq_month], [date yq_day]];
}

- (NSUInteger)yq_weeksOfMonth {
    return [NSDate yq_weeksOfMonth:self];
}

+ (NSUInteger)yq_weeksOfMonth:(NSDate *)date {
    return [[date yq_lastdayOfMonth] yq_weekOfYear] - [[date yq_begindayOfMonth] yq_weekOfYear] + 1;
}

- (NSUInteger)yq_weekOfYear {
    return [NSDate yq_weekOfYear:self];
}

+ (NSUInteger)yq_weekOfYear:(NSDate *)date {
    NSUInteger i;
    NSUInteger year = [date yq_year];
    
    NSDate *lastdate = [date yq_lastdayOfMonth];
    
    for (i = 1;[[lastdate yq_dateAfterDay:-7 * i] yq_year] == year; i++) {
        
    }
    
    return i;
}

- (NSDate *)yq_dateAfterDay:(NSUInteger)day {
    return [NSDate yq_dateAfterDate:self day:day];
}

+ (NSDate *)yq_dateAfterDate:(NSDate *)date day:(NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:day];
    
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:date options:0];
    
    return dateAfterDay;
}

- (NSDate *)yq_dateAfterMonth:(NSUInteger)month {
    return [NSDate yq_dateAfterDate:self month:month];
}

+ (NSDate *)yq_dateAfterDate:(NSDate *)date month:(NSInteger)month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setMonth:month];
    NSDate *dateAfterMonth = [calendar dateByAddingComponents:componentsToAdd toDate:date options:0];
    
    return dateAfterMonth;
}

- (NSDate *)yq_begindayOfMonth {
    return [NSDate yq_begindayOfMonth:self];
}

+ (NSDate *)yq_begindayOfMonth:(NSDate *)date {
    return [self yq_dateAfterDate:date day:-[date yq_day] + 1];
}

- (NSDate *)yq_lastdayOfMonth {
    return [NSDate yq_lastdayOfMonth:self];
}

+ (NSDate *)yq_lastdayOfMonth:(NSDate *)date {
    NSDate *lastDate = [self yq_begindayOfMonth:date];
    return [[lastDate yq_dateAfterMonth:1] yq_dateAfterDay:-1];
}

- (NSUInteger)yq_daysAgo {
    return [NSDate yq_daysAgo:self];
}

+ (NSUInteger)yq_daysAgo:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay)
                                               fromDate:date
                                                 toDate:[NSDate date]
                                                options:0];
#else
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit)
                                               fromDate:date
                                                 toDate:[NSDate date]
                                                options:0];
#endif
    
    return [components day];
}

- (NSInteger)yq_weekday {
    return [NSDate yq_weekday:self];
}

+ (NSInteger)yq_weekday:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:date];
    NSInteger weekday = [comps weekday];
    
    return weekday;
}

- (NSString *)yq_dayFromWeekday {
    return [NSDate yq_dayFromWeekday:self];
}

+ (NSString *)yq_dayFromWeekday:(NSDate *)date {
    switch([date yq_weekday]) {
        case 1:
            return @"星期天";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            break;
    }
    return @"";
}

- (BOOL)yq_isSameDay:(NSDate *)anotherDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [calendar components:(NSCalendarUnitYear
                                                          | NSCalendarUnitMonth
                                                          | NSCalendarUnitDay)
                                                fromDate:self];
    NSDateComponents *components2 = [calendar components:(NSCalendarUnitYear
                                                          | NSCalendarUnitMonth
                                                          | NSCalendarUnitDay)
                                                fromDate:anotherDate];
    return ([components1 year] == [components2 year]
            && [components1 month] == [components2 month]
            && [components1 day] == [components2 day]);
}

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
+ (NSString *)yq_monthWithMonthNumber:(NSInteger)month {
    switch(month) {
        case 1:
            return @"January";
            break;
        case 2:
            return @"February";
            break;
        case 3:
            return @"March";
            break;
        case 4:
            return @"April";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"June";
            break;
        case 7:
            return @"July";
            break;
        case 8:
            return @"August";
            break;
        case 9:
            return @"September";
            break;
        case 10:
            return @"October";
            break;
        case 11:
            return @"November";
            break;
        case 12:
            return @"December";
            break;
        default:
            break;
    }
    return @"";
}

+ (NSString *)yq_stringWithDate:(NSDate *)date format:(NSString *)format {
    return [date yq_stringWithFormat:format];
}

- (NSString *)yq_stringWithFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    
    NSString *retStr = [outputFormatter stringFromDate:self];
    
    return retStr;
}

+ (NSDate *)yq_dateWithString:(NSString *)string format:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    
    NSDate *date = [inputFormatter dateFromString:string];
    
    return date;
}

- (NSUInteger)yq_daysInMonth:(NSUInteger)month {
    return [NSDate yq_daysInMonth:self month:month];
}

+ (NSUInteger)yq_daysInMonth:(NSDate *)date month:(NSUInteger)month {
    switch (month) {
        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
            return 31;
        case 2:
            return [date yq_isLeapYear] ? 29 : 28;
    }
    return 30;
}

- (NSUInteger)yq_daysInMonth {
    return [NSDate yq_daysInMonth:self];
}

+ (NSUInteger)yq_daysInMonth:(NSDate *)date {
    return [self yq_daysInMonth:date month:[date yq_month]];
}

- (NSString *)yq_timeInfo {
    return [NSDate yq_timeInfoWithDate:self];
}

+ (NSString *)yq_timeInfoWithDate:(NSDate *)date {
    return [self yq_timeInfoWithDateString:[self yq_stringWithDate:date format:[self yq_ymdHmsFormat]]];
}

+ (NSString *)yq_timeInfoWithDateString:(NSString *)dateString {
    NSDate *date = [self yq_dateWithString:dateString format:[self yq_ymdHmsFormat]];
    
    NSDate *curDate = [NSDate date];
    NSTimeInterval time = -[date timeIntervalSinceDate:curDate];
    
    int month = (int)([curDate yq_month] - [date yq_month]);
    int year = (int)([curDate yq_year] - [date yq_year]);
    int day = (int)([curDate yq_day] - [date yq_day]);
    
    NSTimeInterval retTime = 1.0;
    if (time < 3600) { // 小于一小时
        retTime = time / 60;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%.0f分钟前", retTime];
    } else if (time < 3600 * 24) { // 小于一天，也就是今天
        retTime = time / 3600;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%.0f小时前", retTime];
    } else if (time < 3600 * 24 * 2) {
        return @"昨天";
    }
    // 第一个条件是同年，且相隔时间在一个月内
    // 第二个条件是隔年，对于隔年，只能是去年12月与今年1月这种情况
    else if ((abs(year) == 0 && abs(month) <= 1)
             || (abs(year) == 1 && [curDate yq_month] == 1 && [date yq_month] == 12)) {
        int retDay = 0;
        if (year == 0) { // 同年
            if (month == 0) { // 同月
                retDay = day;
            }
        }
        
        if (retDay <= 0) {
            // 获取发布日期中，该月有多少天
            int totalDays = (int)[self yq_daysInMonth:date month:[date yq_month]];
            
            // 当前天数 + （发布日期月中的总天数-发布日期月中发布日，即等于距离今天的天数）
            retDay = (int)[curDate yq_day] + (totalDays - (int)[date yq_day]);
        }
        
        return [NSString stringWithFormat:@"%d天前", (abs)(retDay)];
    } else  {
        if (abs(year) <= 1) {
            if (year == 0) { // 同年
                return [NSString stringWithFormat:@"%d个月前", abs(month)];
            }
            
            // 隔年
            int month = (int)[curDate yq_month];
            int preMonth = (int)[date yq_month];
            if (month == 12 && preMonth == 12) {// 隔年，但同月，就作为满一年来计算
                return @"1年前";
            }
            return [NSString stringWithFormat:@"%d个月前", (abs)(12 - preMonth + month)];
        }
        
        return [NSString stringWithFormat:@"%d年前", abs(year)];
    }
    
    return @"1小时前";
}

- (NSString *)yq_ymdFormat {
    return [NSDate yq_ymdFormat];
}

- (NSString *)yq_hmsFormat {
    return [NSDate yq_hmsFormat];
}

- (NSString *)yq_ymdHmsFormat {
    return [NSDate yq_ymdHmsFormat];
}

+ (NSString *)yq_ymdFormat {
    return @"yyyy-MM-dd";
}

+ (NSString *)yq_hmsFormat {
    return @"HH:mm:ss";
}

+ (NSString *)yq_ymdHmsFormat {
    return [NSString stringWithFormat:@"%@ %@", [self yq_ymdFormat], [self yq_hmsFormat]];
}

- (NSDate *)yq_offsetYears:(int)numYears {
    return [NSDate yq_offsetYears:numYears fromDate:self];
}

+ (NSDate *)yq_offsetYears:(int)numYears fromDate:(NSDate *)fromDate {
    if (fromDate == nil) {
        return nil;
    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:numYears];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:fromDate
                                     options:0];
}

- (NSDate *)yq_offsetMonths:(int)numMonths {
    return [NSDate yq_offsetMonths:numMonths fromDate:self];
}

+ (NSDate *)yq_offsetMonths:(int)numMonths fromDate:(NSDate *)fromDate {
    if (fromDate == nil) {
        return nil;
    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:numMonths];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:fromDate
                                     options:0];
}

- (NSDate *)yq_offsetDays:(int)numDays {
    return [NSDate yq_offsetDays:numDays fromDate:self];
}

+ (NSDate *)yq_offsetDays:(int)numDays fromDate:(NSDate *)fromDate {
    if (fromDate == nil) {
        return nil;
    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:numDays];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:fromDate
                                     options:0];
}

- (NSDate *)yq_offsetHours:(int)hours {
    return [NSDate yq_offsetHours:hours fromDate:self];
}

+ (NSDate *)yq_offsetHours:(int)numHours fromDate:(NSDate *)fromDate {
    if (fromDate == nil) {
        return nil;
    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setHour:numHours];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:fromDate
                                     options:0];
}

@end
