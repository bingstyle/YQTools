//
//  CALayer+Util_wxb.m
//  Tools
//
//  Created by weixb on 16/10/26.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import "CALayer+Util_wxb.h"

@implementation CALayer (Util_wxb)

- (void)setBorderColorWithUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

@end
