//
//  UIDevice+WiFi_yq.h
//  YQToolsDemo
//
//  Created by WeiXinbing on 2019/6/5.
//  Copyright © 2019 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (WiFi_yq)

// WiFi 的名称
+ (NSString *)WiFiName;
// WiFi 的路由器的 Mac 地址
+ (NSString *)WiFiBSSID;

// 本机地址
+ (NSString *)ifa_addr;
// 广播地址
+ (NSString *)ifa_dstaddr;
// 子网掩码地址
+ (NSString *)ifa_netmask;
// 端口地址
+ (NSString *)ifa_name;
// 路由器地址
+ (NSString *)route_addr;

// 获取公网IP信息
+ (NSDictionary *)getIpInfo;
// IP转经纬度
+ (NSDictionary *)getLocationInfo;

//格式化方法
+ (NSString*)formatNetWork:(long long int)rate;

@end

NS_ASSUME_NONNULL_END
