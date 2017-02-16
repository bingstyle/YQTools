//
//  NSNumber+CGFloat_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "NSNumber+CGFloat_yq.h"

@implementation NSNumber (CGFloat_yq)

- (CGFloat)yq_CGFloatValue
{
#if (CGFLOAT_IS_DOUBLE == 1)
    CGFloat result = [self doubleValue];
#else
    CGFloat result = [self floatValue];
#endif
    return result;
}

- (id)initWithyqCGFloat:(CGFloat)value
{
#if (CGFLOAT_IS_DOUBLE == 1)
    self = [self initWithDouble:value];
#else
    self = [self initWithFloat:value];
#endif
    return self;
}
+ (NSNumber *)yq_numberWithCGFloat:(CGFloat)value
{
    NSNumber *result = [[self alloc] initWithyqCGFloat:value];
    return result;
}

@end
