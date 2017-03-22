//
//  YQConvert.h
//  Tools
//
//  Created by weixb on 16/12/19.
//  Copyright © 2016年 weixb. All rights reserved.
//  类型转换文件

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YQConvert : NSObject
/**
 *  时间戳转换为日期NSDate
 *
 *  @param timestamp 时间戳
 *
 *  @return 时间字符串
 */
+ (NSDate *)dateWithTimestamp:(double)timestamp;

/**
 *  日期NSDate转换为时间戳
 *
 *  @param date 时间date
 *
 *  @return 时间戳
 */
+ (double)timestampWithDate:(NSDate *)date;


/**
 *  base64编码字符串转换为图片
 *
 *  @param base64String 字符串
 *
 *  @return 图片
 */
+ (UIImage *)imageWithBase64String:(NSString *)base64String;

/**
 *  图片转换为base64编码字符串
 *
 *  @param image 图片
 *
 *  @return 字符串
 */
+ (NSString *)base64StringWithImage:(UIImage *)image;

/**
 *  JSON字符串转换为字典
 *
 *  @param jsonString JSON格式的字符串
 *
 *  @return 字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 *  字典转换为JSON字符串
 *
 *  @param dic 字典
 *
 *  @return JSON格式的字符串
 */
+ (NSString*)jsonStringWithDictionary:(NSDictionary *)dic;


@end
