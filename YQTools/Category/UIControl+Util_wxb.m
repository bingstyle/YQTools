//
//  UIControl+Util_wxb.m
//  Tools
//
//  Created by weixb on 16/10/26.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import "UIControl+Util_wxb.h"

@implementation UIControl (Util_wxb)

- (void)configCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}
- (void)configBorderWidth:(CGFloat)width borderColor:(UIColor *)color {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    self.layer.masksToBounds = YES;
}

@end
