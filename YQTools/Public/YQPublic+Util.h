//
//  YQPublic+Util.h
//  Tools
//
//  Created by weixb on 16/12/14.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import "YQPublic.h"
#import <UIKit/UIKit.h>

@interface YQPublic (Util)

/**
 *  把JSON格式的字符串转换成字典
 *
 *  @param jsonString JSON格式的字符串
 *
 *  @return 返回字典
 */
+ (NSDictionary *)jsonStringToDictionary:(NSString *)jsonString;
/**
 *  把字典转换成JSON格式的字符串
 *
 *  @param dic 字典
 *
 *  @return 返回JSON格式的字符串
 */
+ (NSString*)dictionaryToJsonString:(NSDictionary *)dic;
/**
 *  图片base64编码字符串
 *
 *  @param image 图片
 *
 *  @return 字符串
 */
+ (NSString *)imageToString:(UIImage *)image;
/**
 *  根据base编码生产图片
 *
 *  @param string base64
 *
 *  @return 图片
 */
+ (UIImage *)stringToUIImage:(NSString *)string;
/**
 *  拨打电话号码
 *
 *  @param number 号码字符串
 */
+ (void)makePhoneCallWithNumber:(NSString *)number;
/**
 *  根据出生日期计算星座
 *
 *  @param m 出生月
 *  @param d 出生日
 *
 *  @return 星座字符串
 */
+ (NSString *)getAstroWithMonth:(int)m day:(int)d;
/**
 *  计算生肖
 *
 *  @param year 出生年
 *
 *  @return 生肖字符串
 */
+ (NSString *)getZodiacWithYear:(NSString *)year;
/**
 *  获取沙盒plist路径
 *
 *  @param plistName plist名称
 *
 *  @return 文件路径
 */
+ (NSString *)getSandboxFilePath:(NSString *)plistName;
/**
 *  从沙盒文件中初始化数组
 *
 *  @param plistName plist名称
 *
 *  @return 数组
 */
+ (NSMutableArray *)initWithFilePlistName:(NSString *)plistName;

/**
 *  MD5加密字符串
 */
+ (NSString *)MD5StringFromString:(NSString *)str;
/**
 *  根据各种情况判断字符串是否为空 是空返回yes
 */
+ (BOOL)isEmptyString:(NSString *)str;
/**
 *  将中文字符串转为拼音
 *
 *  @param string 中文
 *
 *  @return 拼音
 */
+ (NSString *)chineseStringToPinyin:(NSString *)string;

@end
