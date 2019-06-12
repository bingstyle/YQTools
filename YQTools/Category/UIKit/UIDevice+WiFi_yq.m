//
//  UIDevice+WiFi_yq.m
//  YQToolsDemo
//
//  Created by WeiXinbing on 2019/6/5.
//  Copyright © 2019 weixb. All rights reserved.
//

#import "UIDevice+WiFi_yq.h"
#import <SystemConfiguration/CaptiveNetwork.h>//获取WiFi信息
#import <arpa/inet.h>//网关
#import <netinet/in.h>//网关
#import <ifaddrs.h>//网关

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation UIDevice (WiFi_yq)

#pragma mark - Public
// WiFi 的名称
+ (NSString *)WiFiName {
    NSDictionary *info = [UIDevice WiFiInfoDic];
    if (info && [info count]) {
        return [info objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
    }
    return nil;
}
// WiFi 的路由器的 Mac 地址
+ (NSString *)WiFiBSSID {
    NSDictionary *info = [UIDevice WiFiInfoDic];
    if (info && [info count]) {
        return [info objectForKey:(__bridge NSString *)kCNNetworkInfoKeyBSSID];
    }
    return nil;
}

// 本机地址
+ (NSString *)ifa_addr {
    return [[UIDevice getLocalInfoForCurrentWiFi] objectForKey:@"ifa_addr"];
}
// 广播地址
+ (NSString *)ifa_dstaddr {
    return [[UIDevice getLocalInfoForCurrentWiFi] objectForKey:@"ifa_dstaddr"];
}
// 子网掩码地址
+ (NSString *)ifa_netmask {
    return [[UIDevice getLocalInfoForCurrentWiFi] objectForKey:@"ifa_netmask"];
}
// 端口地址
+ (NSString *)ifa_name {
    return [[UIDevice getLocalInfoForCurrentWiFi] objectForKey:@"ifa_name"];
}
// 路由器地址
+ (NSString *)route_addr {
    NSArray *array = [UIDevice.ifa_addr componentsSeparatedByString:@"."];
    if (array.count != 4) {
        return @"127.0.0.1";
    }
    return [@[array[0], array[1], array[2], @"1"] componentsJoinedByString:@"."];
}

// 获取公网IP信息
+ (NSDictionary *)getIpInfo
{
    //通过淘宝的服务来定位WAN的IP，否则获取路由IP没什么用
    NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"];
    NSData *data = [NSData dataWithContentsOfURL:ipURL];
    if (!data) {
        return  nil;
    }
    NSError *error = nil;
    NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingMutableContainers
                                                         error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    return dic;
}

// IP转经纬度
+ (NSDictionary *)getLocationInfo {
    // 百度API
    NSURL *ipURL = [NSURL URLWithString:@"https://api.map.baidu.com/location/ip?ak=2W2Sx5EMiVvYGiVIuSVjaXNYGW7tQYq3&coor=bd09ll"];
    NSData *data = [NSData dataWithContentsOfURL:ipURL];
    if (!data) {
        return  nil;
    }
    NSError *error = nil;
    NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingMutableContainers
                                                         error:&error];
    if (error) {
        NSLog(@"%@",error);
        return nil;
    }
    return dic;
}


//格式化方法
+ (NSString*)formatNetWork:(long long int)rate {
    
    if(rate <1024) {
        
        return [NSString stringWithFormat:@"%lldB/秒", rate];
        
    }else if(rate >=1024&& rate <1024*1024) {
        
        return [NSString stringWithFormat:@"%.1fKB/秒", (double)rate /1024];
        
    }else if(rate >=1024*1024&& rate <1024*1024*1024){
        
        return [NSString stringWithFormat:@"%.2fMB/秒", (double)rate / (1024*1024)];
        
    } else {
        return @"10Kb/秒";
    };
}



#pragma mark - Private
+ (NSDictionary *)WiFiInfoDic {
    // 在 iOS 12 及以上系统调用该方法时, 开启授权 Capabilities -> Access WiFi Information => YES
    CFArrayRef wifis = CNCopySupportedInterfaces();
    if (!wifis || CFArrayGetCount(wifis) == 0) {
        return  nil;
    }
    NSArray *interface = (__bridge_transfer NSArray *)wifis;
    NSDictionary *info = nil;
    for (NSString *name in interface) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)name);
    }
    
    if (info == nil) {
        return nil;
    }
    // NSLog(@"%@", info);
    //    NSString *ssid = info[@"SSID"]; //  WiFi 的名称
    //    NSString *bssid = info[@"BSSID"]; // WiFi 的路由器的 Mac 地址
    return info;
}

/** 广播地址、子网掩码、端口等，组装成一个字典。 */
+ (NSMutableDictionary *)getLocalInfoForCurrentWiFi {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        //*/
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    //----192.168.1.255 广播地址
                    NSString *broadcast = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                    if (broadcast) {
                        [dict setObject:broadcast forKey:@"ifa_dstaddr"];
                    }
                    //                    NSLog(@"ifa_dstaddr--%@",broadcast);
                    //--192.168.1.106 本机地址
                    NSString *localIp = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    if (localIp) {
                        [dict setObject:localIp forKey:@"ifa_addr"];
                    }
                    //                    NSLog(@"ifa_addr--%@",localIp);
                    //--255.255.255.0 子网掩码地址
                    NSString *netmask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                    if (netmask) {
                        [dict setObject:netmask forKey:@"ifa_netmask"];
                    }
                    //                    NSLog(@"ifa_netmask--%@",netmask);
                    //--en0 端口地址
                    NSString *interface = [NSString stringWithUTF8String:temp_addr->ifa_name];
                    if (interface) {
                        [dict setObject:interface forKey:@"ifa_name"];
                    }
                    //                    NSLog(@"ifa_name--%@",interface);
                    return dict;
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return dict;
}



@end
