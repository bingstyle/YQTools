//
//  UIDevice+Util_yq.m
//  YQToolsDemo
//
//  Created by WeiXinbing on 2019/6/5.
//  Copyright © 2019 weixb. All rights reserved.
//

#import "UIDevice+Util_yq.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <ifaddrs.h>

@implementation UIDevice (Util_yq)
// 运营商
+ (CTCarrier *)carrier {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    return carrier;
}
// 国家码 如：460
+ (NSString *)mobileCountryCode {
    return UIDevice.carrier.mobileCountryCode;
}
// 网络码 如：01
+ (NSString *)mobileNetworkCode {
    return UIDevice.carrier.mobileNetworkCode;
}
// 运营商名称，中国联通
+ (NSString *)carrierName {
    return UIDevice.carrier.carrierName;
}
// isoCountryCode 如：cn
+ (NSString *)isoCountryCode {
    return UIDevice.carrier.isoCountryCode;
}
// allowsVOIP
+ (BOOL)allowsVOIP {
    return UIDevice.carrier.allowsVOIP;
}
// 无线连接技术，如CTRadioAccessTechnologyLTE
+ (NSString *)currentRadioAccessTechnology {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    return [info.currentRadioAccessTechnology stringByReplacingOccurrencesOfString:@"CTRadioAccessTechnology" withString:@""];
}

// 是否连接蜂窝
+ (BOOL)hasBeehive {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    return info.currentRadioAccessTechnology.length;
}

@end
