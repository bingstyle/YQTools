//
//  UIApplication+Service_yq.h
//  YQToolsDemo
//
//  Created by WeiXinbing on 2019/1/22.
//  Copyright © 2019 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (Service_yq)

/**
 *  直接拨打电话
 *
 *  @param phoneNum 电话号码
 */
+ (void)yq_directPhoneCallWithPhoneNum:(NSString *)phoneNum;

/**
 *  弹出对话框并询问是否拨打电话
 *
 *  @param phoneNum 电话号码
 *  @param view     contentView
 */
+ (void)yq_phoneCallWithPhoneNum:(NSString *)phoneNum contentView:(UIView *)view;

/**
 *  跳到app的评论页
 *
 *  @param appId APP的id号
 */
+ (void)yq_jumpToAppReviewPageWithAppId:(NSString *)appId;

/**
 *  发邮件
 *
 *  @param address 邮件地址
 */
+ (void)yq_sendEmailToAddress:(NSString *)address;

@end

NS_ASSUME_NONNULL_END
