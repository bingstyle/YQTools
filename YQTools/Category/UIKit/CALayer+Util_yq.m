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
 *  @param color
 */
- (void)setBorderColorWithUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

@end
