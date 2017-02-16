//
//  NSString+Base64_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64_yq)

+ (NSString *)yq_stringWithBase64EncodedString:(NSString *)string;
- (NSString *)yq_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)yq_base64EncodedString;
- (NSString *)yq_base64DecodedString;
- (NSData *)yq_base64DecodedData;

@end
