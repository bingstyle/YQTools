//
//  YQPublic+LocalNotification.h
//  Tools
//
//  Created by weixb on 16/12/14.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import "YQPublic.h"

@interface YQPublic (LocalNotification)

+ (void)createLocalNotificationWithTitle:(NSString *)title alertBody:(NSString *)alertBody userInfo:(NSDictionary *)userInfo date:(NSDate *)date;

+ (void)registerUserNotificationWithCategory:(BOOL)isSupport;
//+ (void)scheduleLocalNotification;
+ (void)scheduleLocalNotificationWithRepeatInterval:(NSCalendarUnit)repeatInterval alertBody:(NSString *)alertBody userInfo:(NSDictionary *)userInfo date:(NSDate *)date;

@end
