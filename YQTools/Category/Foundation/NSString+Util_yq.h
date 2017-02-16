//
//  NSString+Util_yq.h
//  Tools
//
//  Created by weixb on 16/12/19.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util_yq)

/**
 *  根据各种情况判断字符串是否为空 是空返回yes
 */
+ (BOOL)yq_isEmptyString:(NSString *)str;
/**
 *  将中文字符串转为拼音
 *
 *  @param string 中文
 *
 *  @return 拼音
 */
+ (NSString *)yq_pinyinWithChineseString:(NSString *)string;

@end
