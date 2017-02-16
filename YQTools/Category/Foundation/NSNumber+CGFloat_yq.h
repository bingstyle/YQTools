//
//  NSNumber+CGFloat_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSNumber (CGFloat_yq)

- (CGFloat)yq_CGFloatValue;

- (id)initWithyqCGFloat:(CGFloat)value;

+ (NSNumber *)yq_numberWithCGFloat:(CGFloat)value;

@end
