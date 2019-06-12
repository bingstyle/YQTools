//
//  UIDevice+Util_yq.h
//  YQToolsDemo
//
//  Created by WeiXinbing on 2019/6/5.
//  Copyright © 2019 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTCarrier;

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Util_yq)

// 运营商
+ (CTCarrier *)carrier;
// 国家码 如：460
+ (NSString *)mobileCountryCode;
// 网络码 如：01
+ (NSString *)mobileNetworkCode;
// 运营商名称，中国联通
+ (NSString *)carrierName;
// isoCountryCode 如：cn
+ (NSString *)isoCountryCode;
// allowsVOIP
+ (BOOL)allowsVOIP;
// 无线连接技术，如CTRadioAccessTechnologyLTE
+ (NSString *)currentRadioAccessTechnology;

// 是否连接蜂窝
+ (BOOL)hasBeehive;


@end

NS_ASSUME_NONNULL_END
