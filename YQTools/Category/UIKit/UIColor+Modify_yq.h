//
//  UIColor+Modify_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Modify_yq)

- (UIColor *)yq_invertedColor;
- (UIColor *)yq_colorForTranslucency;
- (UIColor *)yq_lightenColor:(CGFloat)lighten;
- (UIColor *)yq_darkenColor:(CGFloat)darken;

@end
