//
//  YQLocalNotification.m
//  Tools
//
//  Created by weixb on 16/12/15.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import "YQLocalNotification.h"
#import <UIKit/UIKit.h>

@implementation YQLocalNotification

#pragma mark - public

+ (void)createLocalNotificationWithTitle:(NSString *)title alertBody:(NSString *)alertBody userInfo:(NSDictionary *)userInfo date:(NSDate *)date {
    // 1.注册通知
    [self registerUserNotificationWithCategory:NO];
    // 2.初始化通知
    UILocalNotification *notification = [[UILocalNotification alloc  ]init];
    // 3.配置通知
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:15];
    // 设置通知声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 设置弹出框的标题
    notification.alertTitle = @"尊敬的先生:";
    // 设置icon图标badgeValue
    notification.applicationIconBadgeNumber++;
    // 设置显示的内容
    notification.alertBody = [NSString stringWithFormat:@"您当前有%@条未读消息,请查看.",@(notification.applicationIconBadgeNumber)];
    // 设定通知的userInfo，用来标识该通知
    notification.userInfo = userInfo;
    // 4. 添加通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}
+ (void)scheduleLocalNotificationWithRepeatInterval:(NSCalendarUnit)repeatInterval alertBody:(NSString *)alertBody userInfo:(NSDictionary *)userInfo date:(NSDate *)date {
    // 1.注册通知
    [self registerUserNotificationWithCategory:YES];
    // 2.初始化通知
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    // 3.配置通知
    localNotification.repeatInterval = repeatInterval;
    localNotification.fireDate = date;
    localNotification.alertAction = @"calenderRemind";
    localNotification.alertBody = alertBody;
    localNotification.userInfo = userInfo;
    localNotification.category = @"calendarReminderCategory";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [UIApplication sharedApplication].applicationIconBadgeNumber++;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
/**
 *  注册通知(iOS8以上)
 */
+ (void)registerUserNotificationWithCategory:(BOOL)isSupport {
    /*创建通知动作
     UIMutableUserNotificationAction是iOS8新引入的类，有着许多有用的配置属性:
     1.标示符（identifier）;通过此标示符，我们可以决定在用户点击不同的通知时，调用哪个动作。
     2.destructive：布尔值。当设置为true时，通知中相应地按钮的背景色会变成红色。这只会在banner通知中出现。
     通常，当动作代表着删除、移除或者其他关键的动作是都会被标记为destructive以获得用户的注意。
     3.authenticationRequired：布尔值。当设置为true时，用户在点击动作之前必须确认自己的身份。当一个动作十分关键时这非
     常有用，因为为认证的操作有可能会破坏App的数据。
     4.ActivationMode：枚举。决定App在通知动作点击后是应该被启动还是不被启动。此枚举有两个值：
     （a）UIUserNotificationActivationModeForeground,打开APP,进入前台;
     （b）UIUserNotificationActivationModeBackground,在background中，App被给予了几秒中来运行代码。
     */
    UIMutableUserNotificationAction *justAction =  [[UIMutableUserNotificationAction alloc]init];
    justAction.identifier = @"action";
    justAction.title = @"OK";
    justAction.activationMode = UIUserNotificationActivationModeBackground;
    justAction.destructive = false;
    justAction.authenticationRequired = false;
    
    UIMutableUserNotificationAction *openAction =  [[UIMutableUserNotificationAction alloc]init];
    openAction.identifier = @"openAction";
    openAction.title = @"open";
    openAction.activationMode = UIUserNotificationActivationModeForeground;
    openAction.destructive = false;
    openAction.authenticationRequired = true;
    
    UIMutableUserNotificationAction *trashAction =  [[UIMutableUserNotificationAction alloc]init];
    trashAction.identifier = @"trashAction";
    trashAction.title = @"delete";
    trashAction.activationMode = UIUserNotificationActivationModeBackground;
    trashAction.destructive = true;
    trashAction.authenticationRequired = true;
    
    NSArray *actionsArray = @[justAction, openAction, trashAction];
    NSArray *actionsArrayMinimal = @[trashAction,openAction];
    UIMutableUserNotificationCategory *calendarRemindCategory = [[UIMutableUserNotificationCategory alloc]init];
    calendarRemindCategory.identifier = @"calendarReminderCategory";
    [calendarRemindCategory setActions:actionsArray forContext:UIUserNotificationActionContextDefault];
    [calendarRemindCategory setActions:actionsArrayMinimal forContext:UIUserNotificationActionContextMinimal];
    
    //通过上面的代码，我们已经将本地通知的所有新功能已经实现了。现在我们需要将这些设定注册到用户设置中。\
    为了完成这个目标，我们将会用到 UIUserNotificationSettings类（iOS8新引入)
    
    //注册通知的类型
    UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    //注册通知的类目
    NSSet *categories = [[NSSet alloc]initWithObjects:calendarRemindCategory, nil];
    categories = isSupport ? categories : nil;
    //注册通知设置:第一个参数是我们为通知设置的类型,第二个方法是一个集合（NSSet），\
    在这个集合中必须包含一个App所有通知支持的类目。在本例中，我们只有一个类目，但是我们还是需要使用集合来传递它。
    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:type categories:categories];
    //根据提供的设置注册通知
    [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    
}

//+ (NSDate *)fixNotificationDateWithDate:(NSDate *)date {
//    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
//    dateComponents.second = 0;
//    NSDate *fixedDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
//    return fixedDate;
//}
@end
