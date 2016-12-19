//
//  WXBPublic.h
//  Tools
//
//  Created by weixb on 16/7/16.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YQPublic : NSObject
/**
 *  将对象中的Null类型转化成@""
 *
 *  @param myObj 被转化对象
 *
 *  @return 返回对象
 */
+ (id)nullToEmptyStrign:(id)myObj;

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



@end
