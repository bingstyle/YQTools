//
//  NSString+Util_yq.m
//  Tools
//
//  Created by weixb on 16/12/19.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import "NSString+Util_yq.h"

@implementation NSString (Util_yq)

/**
 *  根据各种情况判断字符串是否为空 是空返回yes
 */
+ (BOOL)yq_isEmptyString:(NSString *)str {
    return  str == nil ||
    str.length == 0 ||
    [str isKindOfClass:[NSNull class]] ||
    ![str isKindOfClass:[NSString class]] ||
    [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0 ||
    [str stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0 ||
    [str isEqualToString:@"null"]||
    [str isEqualToString:@"(null)"] ||
    [str isEqualToString:@"<null>"];
}

/**
 *  将中文字符串转为拼音
 *
 *  @param string 中文
 *
 *  @return 拼音
 */
+ (NSString *)yq_pinyinWithChineseString:(NSString *)string {
    // 将中文字符串转成可变字符串
    NSMutableString *pinyinText = [[NSMutableString alloc] initWithString:string];
    // 先转换为带声调的拼音
    CFStringTransform((__bridge CFMutableStringRef)pinyinText, 0, kCFStringTransformMandarinLatin, NO);// 输出 pinyin: zhōng guó sì chuān
    // 再转换为不带声调的拼音
    CFStringTransform((__bridge CFMutableStringRef)pinyinText, 0, kCFStringTransformStripDiacritics, NO);// 输出 pinyin: zhong guo si chuan
    // 转换为首字母大写拼音
    // NSString *capitalPinyin = [pinyinText capitalizedString];
    // 输出 capitalPinyin: Zhong Guo Si Chuan
    // 替换掉空格
    NSString *newString = [NSString stringWithFormat:@"%@",pinyinText];
    NSString *newStr = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newStr.lowercaseString;
}

@end
