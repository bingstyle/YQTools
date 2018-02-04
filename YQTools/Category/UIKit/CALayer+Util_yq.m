//
//  CALayer+Util_yq.m
//  Tools
//
//  Created by weixb on 16/12/19.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import "CALayer+Util_yq.h"

@implementation CALayer (Util_yq)

/**
 *  设置边框颜色(用于storyboard的key_value设置)
 *
 *  @param color 边框颜色
 */
- (void)setBorderColorWithUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}
- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.shadowColor = color.CGColor;
    self.shadowOffset = offset;
    self.shadowRadius = radius;
    self.shadowOpacity = 1;
    self.shouldRasterize = YES;
    self.rasterizationScale = [UIScreen mainScreen].scale;
}

@end
