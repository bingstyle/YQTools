//
//  UIApplication+Util_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2018/2/4.
//  Copyright © 2018年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (Util_yq)

/**
 *  获取启动页图片
 *
 *  @return 启动页图片
 */
+ (UIImage *)yq_launchImage;

/// Application's Bundle Name (show in SpringBoard).
@property (nullable, nonatomic, readonly) NSString *yq_appBundleName;

/// Application's Bundle ID.  e.g. "com.ibireme.MyApp"
@property (nullable, nonatomic, readonly) NSString *yq_appBundleID;

/// Application's Version.  e.g. "1.2.0"
@property (nullable, nonatomic, readonly) NSString *yq_appVersion;

/// Application's Build number. e.g. "123"
@property (nullable, nonatomic, readonly) NSString *yq_appBuildVersion;

/// Whether this app is pirated (not install from appstore).
@property (nonatomic, readonly) BOOL yq_isPirated;

/// Whether this app is being debugged (debugger attached).
@property (nonatomic, readonly) BOOL yq_isBeingDebugged;

/// Current thread real memory used in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t yq_memoryUsage;

/// Current thread CPU usage, 1.0 means 100%. (-1 when error occurs)
@property (nonatomic, readonly) float yq_cpuUsage;


@end

NS_ASSUME_NONNULL_END
