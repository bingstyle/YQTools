//
//  UIColor+Util_wxb.h
//  Tools
//
//  Created by weixb on 16/10/26.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util_wxb)

/**
 *  由16进制字符串获取颜色
 *
 *  @param hexRGBString
 *
 *  @return
 */
+ (UIColor *)colorWithHexRGB:(NSString *)hexRGBString;

@end
