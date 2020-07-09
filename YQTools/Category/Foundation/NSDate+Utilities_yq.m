//
//  NSDate+Utilities_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "NSDate+Utilities_yq.h"
#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

// Thanks, AshFurrow
static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);

@implementation NSDate (Utilities_yq)

// Courtesy of Lukasz Margielewski
// Updated via Holger Haenisch
+ (NSCalendar *) yq_currentCalendar
{
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}

#pragma mark - Relative Dates

+ (NSDate *)yq_dateWithDaysFromNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] yq_dateByAddingDays:days];
}

+ (NSDate *)yq_dateWithDaysBeforeNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] yq_dateBySubtractingDays:days];
}

+ (NSDate *) yq_dateTomorrow
{
    return [NSDate yq_dateWithDaysFromNow:1];
}

+ (NSDate *) yq_dateYesterday
{
    return [NSDate yq_dateWithDaysBeforeNow:1];
}

+ (NSDate *) yq_dateWithHoursFromNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) yq_dateWithHoursBeforeNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) yq_dateWithMinutesFromNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) yq_dateWithMinutesBeforeNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

#pragma mark - String Properties

- (NSString *) yq_stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = dateStyle;
    formatter.timeStyle = timeStyle;
    //    formatter.locale = [NSLocale currentLocale]; // Necessary?
    return [formatter stringFromDate:self];
}

- (NSString *) yq_shortString
{
    return [self yq_stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *) yq_shortTimeString
{
    return [self yq_stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *) yq_shortDateString
{
    return [self yq_stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}

- (NSString *) yq_mediumString
{
    return [self yq_stringWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle ];
}

- (NSString *) yq_mediumTimeString
{
    return [self yq_stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle ];
}

- (NSString *) yq_mediumDateString
{
    return [self yq_stringWithDateStyle:NSDateFormatterMediumStyle  timeStyle:NSDateFormatterNoStyle];
}

- (NSString *) yq_longString
{
    return [self yq_stringWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle ];
}

- (NSString *) yq_longTimeString
{
    return [self yq_stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle ];
}

- (NSString *) yq_longDateString
{
    return [self yq_stringWithDateStyle:NSDateFormatterLongStyle  timeStyle:NSDateFormatterNoStyle];
}

#pragma mark - Comparing Dates

- (BOOL) yq_isEqualToDateIgnoringTime: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate yq_currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate yq_currentCalendar] components:componentFlags fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL) yq_isToday
{
    return [self yq_isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) yq_isTomorrow
{
    return [self yq_isEqualToDateIgnoringTime:[NSDate yq_dateTomorrow]];
}

- (BOOL) yq_isYesterday
{
    return [self yq_isEqualToDateIgnoringTime:[NSDate yq_dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL)yq_isSameWeekAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate yq_currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate yq_currentCalendar] components:componentFlags fromDate:aDate];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (components1.week != components2.week) return NO;
#pragma clang diagnostic pop
    
    // Must have a time interval under 1 week. Thanks @aclark
    return (fabs([self timeIntervalSinceDate:aDate]) < D_WEEK);
    
}

- (BOOL) yq_isThisWeek
{
    return [self yq_isSameWeekAsDate:[NSDate date]];
}

- (BOOL) yq_isNextWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self yq_isSameWeekAsDate:newDate];
}

- (BOOL) yq_isLastWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self yq_isSameWeekAsDate:newDate];
}

// Thanks, mspasov
- (BOOL) yq_isSameMonthAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate yq_currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [[NSDate yq_currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL) yq_isThisMonth
{
    return [self yq_isSameMonthAsDate:[NSDate date]];
}

// Thanks Marcin Krzyzanowski, also for adding/subtracting years and months
- (BOOL) yq_isLastMonth
{
    return [self yq_isSameMonthAsDate:[[NSDate date] yq_dateBySubtractingMonths:1]];
}

- (BOOL) yq_isNextMonth
{
    return [self yq_isSameMonthAsDate:[[NSDate date] yq_dateByAddingMonths:1]];
}

- (BOOL) yq_isSameYearAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate yq_currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate yq_currentCalendar] components:NSCalendarUnitYear fromDate:aDate];
    return (components1.year == components2.year);
}

- (BOOL) yq_isThisYear
{
    // Thanks, baspellis
    return [self yq_isSameYearAsDate:[NSDate date]];
}

- (BOOL) yq_isNextYear
{
    NSDateComponents *components1 = [[NSDate yq_currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate yq_currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year + 1));
}

- (BOOL) yq_isLastYear
{
    NSDateComponents *components1 = [[NSDate yq_currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate yq_currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year - 1));
}

- (BOOL) yq_isEarlierThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) yq_isLaterThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

// Thanks, markrickert
- (BOOL) yq_isInFuture
{
    return ([self yq_isLaterThanDate:[NSDate date]]);
}

// Thanks, markrickert
- (BOOL) yq_isInPast
{
    return ([self yq_isEarlierThanDate:[NSDate date]]);
}


#pragma mark - Roles
- (BOOL) yq_isTypicallyWeekend
{
    NSDateComponents *components = [[NSDate yq_currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL) yq_isTypicallyWorkday
{
    return ![self yq_isTypicallyWeekend];
}

#pragma mark - Adjusting Dates

// Thaks, rsjohnson
- (NSDate *) yq_dateByAddingYears: (NSInteger) dYears
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:dYears];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) yq_dateBySubtractingYears: (NSInteger) dYears
{
    return [self yq_dateByAddingYears:-dYears];
}

- (NSDate *) yq_dateByAddingMonths: (NSInteger) dMonths
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:dMonths];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) yq_dateBySubtractingMonths: (NSInteger) dMonths
{
    return [self yq_dateByAddingMonths:-dMonths];
}

// Courtesy of dedan who mentions issues with Daylight Savings
- (NSDate *) yq_dateByAddingDays: (NSInteger) dDays
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) yq_dateBySubtractingDays: (NSInteger) dDays
{
    return [self yq_dateByAddingDays: (dDays * -1)];
}

- (NSDate *) yq_dateByAddingHours: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) yq_dateBySubtractingHours: (NSInteger) dHours
{
    return [self yq_dateByAddingHours: (dHours * -1)];
}

- (NSDate *) yq_dateByAddingMinutes: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) yq_dateBySubtractingMinutes: (NSInteger) dMinutes
{
    return [self yq_dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDateComponents *) yq_componentsWithOffsetFromDate: (NSDate *) aDate
{
    NSDateComponents *dTime = [[NSDate yq_currentCalendar] components:componentFlags fromDate:aDate toDate:self options:0];
    return dTime;
}

#pragma mark - Extremes

- (NSDate *) yq_dateAtStartOfDay
{
    NSDateComponents *components = [[NSDate yq_currentCalendar] components:componentFlags fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[NSDate yq_currentCalendar] dateFromComponents:components];
}

// Thanks gsempe & mteece
- (NSDate *) yq_dateAtEndOfDay
{
    NSDateComponents *components = [[NSDate yq_currentCalendar] components:componentFlags fromDate:self];
    
    components.hour = 23; // Thanks Aleksey Kononov
    components.minute = 59;
    components.second = 59;
    return [[NSDate yq_currentCalendar] dateFromComponents:components];
}

#pragma mark - Retrieving Intervals

- (NSInteger) yq_minutesAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) yq_minutesBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) yq_hoursAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) yq_hoursBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) yq_daysAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_DAY);
}

- (NSInteger) yq_daysBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_DAY);
}

// Thanks, dmitrydims
// I have not yet thoroughly tested this
- (NSInteger)yq_distanceDaysToDate:(NSDate *)anotherDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
    return components.day;
}
- (NSInteger)yq_distanceMonthsToDate:(NSDate *)anotherDate{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitMonth fromDate:self toDate:anotherDate options:0];
    return components.month;
}
- (NSInteger)yq_distanceYearsToDate:(NSDate *)anotherDate{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitYear fromDate:self toDate:anotherDate options:0];
    return components.year;
}


@end
