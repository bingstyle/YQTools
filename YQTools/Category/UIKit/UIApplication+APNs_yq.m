//
//  UIApplication+APNs_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/2/20.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "UIApplication+APNs_yq.h"

@implementation UIApplication (APNs_yq)

+ (void)yq_registerAPNs
{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

@end
