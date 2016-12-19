//
//  UIColor+Util_yq.h
//  Tools
//
//  Created by weixb on 16/12/19.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util_yq)

/**
 *  由16进制字符串获取颜色
 *
 *  @param hexRGBString
 *
 *  @return
 */
+ (UIColor *)yq_colorWithHexRGB:(NSString *)hexRGBString;

@end
