
//
//  YQConvert.m
//  Tools
//
//  Created by weixb on 16/12/19.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import "YQConvert.h"

@interface YQConvert ()


@end

@implementation YQConvert

#pragma mark - public
+ (NSDate *)dateWithTimestamp:(double)timestamp {
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timestamp/ 1000.0];
    return date;
}

+ (double)timestampWithDate:(NSDate *)date {
    // *1000 是精确到毫秒，不乘就是精确到秒
    double timestamp = [date timeIntervalSince1970]*1000;
    return timestamp;
}

+ (UIImage *)imageWithBase64String:(NSString *)base64String {
    if(base64String){
        NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:0];
        
        return [UIImage imageWithData:data];
    }
    return nil;
}

+ (NSString *)base64StringWithImage:(UIImage *)image {
    
    NSData *data = UIImageJPEGRepresentation(image, 1);
    
    return [data base64EncodedStringWithOptions:0];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
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

+ (NSString*)jsonStringWithDictionary:(NSDictionary *)dic {
    
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
