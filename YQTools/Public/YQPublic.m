//
//  WXBPublic.m
//  Tools
//
//  Created by weixb on 16/7/16.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import "YQPublic.h"
#import <CommonCrypto/CommonDigest.h>

@implementation YQPublic
/**
 *  把JSON格式的字符串转换成字典
 *
 *  @param jsonString JSON格式的字符串
 *
 *  @return 返回字典
 */
+ (NSDictionary *)jsonStringToDictionary:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return dic;
}
/**
 *  把字典转换成JSON格式的字符串
 *
 *  @param dic 字典
 *
 *  @return 返回JSON格式的字符串
 */
+ (NSString*)dictionaryToJsonString:(NSDictionary *)dic {
    
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
/**
 *  图片base64编码字符串
 *
 *  @param image 图片
 *
 *  @return 字符串
 */
+ (NSString *)imageToString:(UIImage *)image {
    
    NSData *data = UIImageJPEGRepresentation(image, 1);
    
    return [data base64EncodedStringWithOptions:0];
}

/**
 *  根据base编码生产图片
 *
 *  @param string base64
 *
 *  @return 图片
 */
+ (UIImage *)stringToUIImage:(NSString *)string {
    if(string){
        NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:0];
        
        return [UIImage imageWithData:data];
    }
    return nil;
}
/**
 *  拨打电话号码
 *
 *  @param number 号码字符串
 */
+ (void)makePhoneCallWithNumber:(NSString *)number {
    NSInteger length = number.length;
    NSString *realNumber = [NSString string];
    
    for (NSInteger i = 0 ; i <length; i++)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [number substringWithRange:range];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        NSNumber *subnum = [numberFormatter numberFromString:subString];
        if ( subnum || [subString isEqualToString:@"-"])
        {
            realNumber = [realNumber stringByAppendingString:subString];
        }
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"tel://", realNumber]]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"tel://", realNumber]]];
    }
}
#pragma mark - 计算星座
+ (NSString *)getAstroWithMonth:(int)m day:(int)d {
    NSString *astroString = @"摩羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手摩羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    if (m<1||m>12||d<1||d>31){
        return @"错误日期格式!";
    }
    if(m==2 && d>29)
    {
        return @"错误日期格式!!";
    }else if(m==4 || m==6 || m==9 || m==11) {
        if (d>30) {
            return @"错误日期格式!!!";
        }
    }
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    return result;
}
#pragma mark - 计算生肖
+ (NSString *)getZodiacWithYear:(NSString *)year {
    NSInteger constellation = ([year integerValue] - 4)%12;
    NSString * result;
    switch (constellation) {
        case 0:result = @"鼠";break;
        case 1:result = @"牛";break;
        case 2:result = @"虎";break;
        case 3:result = @"兔";break;
        case 4:result = @"龙";break;
        case 5:result = @"蛇";break;
        case 6:result = @"马";break;
        case 7:result = @"羊";break;
        case 8:result = @"猴";break;
        case 9:result = @"鸡";break;
        case 10:result = @"狗";break;
        case 11:result = @"猪";break;
        default:
            break;
    }
    return result;
}
#pragma mark - plist
// 获取沙盒plist路径
+ (NSString *)getSandboxFilePath:(NSString *)plistName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = paths.firstObject;
    NSString *filePath = [basePath stringByAppendingPathComponent:plistName];
    return filePath;
}
// 从沙盒文件中初始化数组
+ (NSMutableArray *)initWithFilePlistName:(NSString *)plistName {
    NSMutableArray * dataArray;
    // 取boundle中的属性列表文件路径
    NSString *bundlePath= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    // 取沙盒中的文件路径
    NSString * sandBoxPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.plist",plistName]];
    // 创建文件管理器
    NSFileManager * fileManger = [NSFileManager defaultManager];
    // 判断文件是否存在
    if ([fileManger fileExistsAtPath:sandBoxPath]) {
        dataArray = [[NSMutableArray alloc] initWithContentsOfFile:sandBoxPath];
    }else{
        dataArray = [[NSMutableArray alloc] initWithContentsOfFile:bundlePath];
    }
    return dataArray;
}

/**
 *  MD5加密字符串
 */
+ (NSString *)MD5StringFromString:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

/**
 *  根据各种情况判断字符串是否为空 是空返回yes
 */
+ (BOOL)isEmptyString:(NSString *)str {
    return  str == nil || [str isKindOfClass:[NSNull class]] || ![str isKindOfClass:[NSString class]] || str.length == 0 || [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0 || [str stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0 || [str isEqualToString:@"null"]|| [str isEqualToString:@"(null)"] || [str isEqualToString:@"<null>"];
}

/**
 *  将中文字符串转为拼音
 *
 *  @param string 中文
 *
 *  @return 拼音
 */
+ (NSString *)chineseStringToPinyin:(NSString *)string {
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
