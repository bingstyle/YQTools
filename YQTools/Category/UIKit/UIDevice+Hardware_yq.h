//
//  UIDevice+Hardware_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//
//  https://github.com/fahrulazmi/UIDeviceHardware/blob/master/UIDeviceHardware.m

#import <UIKit/UIKit.h>

@interface UIDevice (Hardware_yq)

+ (NSString *)yq_platform;
+ (NSString *)yq_platformString;


+ (NSString *)yq_macAddress;

//Return the current device CPU frequency
+ (NSUInteger)yq_cpuFrequency;
// Return the current device BUS frequency
+ (NSUInteger)yq_busFrequency;
//current device RAM size
+ (NSUInteger)yq_ramSize;
//Return the current device CPU number
+ (NSUInteger)yq_cpuNumber;
//Return the current device total memory

/// 获取iOS系统的版本号
+ (NSString *)yq_systemVersion;
/// 判断当前系统是否有摄像头
+ (BOOL)yq_hasCamera;
/// 获取手机内存总量, 返回的是字节数
+ (NSUInteger)yq_totalMemoryBytes;
/// 获取手机可用内存, 返回的是字节数
+ (NSUInteger)yq_freeMemoryBytes;

/// 获取手机硬盘空闲空间, 返回的是字节数
+ (long long)yq_freeDiskSpaceBytes;
/// 获取手机硬盘总空间, 返回的是字节数
+ (long long)yq_totalDiskSpaceBytes;

@end
