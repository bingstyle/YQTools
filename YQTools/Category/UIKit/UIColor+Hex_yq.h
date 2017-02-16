//
//  UIColor+Hex_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex_yq)

+ (UIColor *)yq_colorWithHex:(UInt32)hex;
+ (UIColor *)yq_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
+ (UIColor *)yq_colorWithHexString:(NSString *)hexString;
- (NSString *)yq_HEXString;
///值不需要除以255.0
+ (UIColor *)yq_colorWithWholeRed:(CGFloat)red
                             green:(CGFloat)green
                              blue:(CGFloat)blue
                             alpha:(CGFloat)alpha;
///值不需要除以255.0
+ (UIColor *)yq_colorWithWholeRed:(CGFloat)red
                             green:(CGFloat)green
                              blue:(CGFloat)blue;

@end
