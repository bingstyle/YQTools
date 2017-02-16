//
//  NSString+Base64_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "NSString+Base64_yq.h"
#import "NSData+Base64_yq.h"

@implementation NSString (Base64_yq)

+ (NSString *)yq_stringWithBase64EncodedString:(NSString *)string
{
    NSData *data = [NSData yq_dataWithBase64EncodedString:string];
    if (data)
    {
        return [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}
- (NSString *)yq_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data yq_base64EncodedStringWithWrapWidth:wrapWidth];
}
- (NSString *)yq_base64EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data yq_base64EncodedString];
}
- (NSString *)yq_base64DecodedString
{
    return [NSString yq_stringWithBase64EncodedString:self];
}
- (NSData *)yq_base64DecodedData
{
    return [NSData yq_dataWithBase64EncodedString:self];
}

@end
