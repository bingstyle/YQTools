//
//  NSArray+SafeAccess_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "NSArray+SafeAccess_yq.h"

@implementation NSArray (SafeAccess_yq)

-(id)yq_objectWithIndex:(NSUInteger)index{
    if (index <self.count) {
        return self[index];
    }else{
        return nil;
    }
}

- (NSString*)yq_stringWithIndex:(NSUInteger)index
{
    id value = [self yq_objectWithIndex:index];
    if (value == nil || value == [NSNull null] || [[value description] isEqualToString:@"<null>"])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString*)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    
    return nil;
}


- (NSNumber*)yq_numberWithIndex:(NSUInteger)index
{
    id value = [self yq_objectWithIndex:index];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString*)value];
    }
    return nil;
}

- (NSDecimalNumber *)yq_decimalNumberWithIndex:(NSUInteger)index{
    id value = [self yq_objectWithIndex:index];
    
    if ([value isKindOfClass:[NSDecimalNumber class]]) {
        return value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber * number = (NSNumber*)value;
        return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    } else if ([value isKindOfClass:[NSString class]]) {
        NSString * str = (NSString*)value;
        return [str isEqualToString:@""] ? nil : [NSDecimalNumber decimalNumberWithString:str];
    }
    return nil;
}

- (NSArray*)yq_arrayWithIndex:(NSUInteger)index
{
    id value = [self yq_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSArray class]])
    {
        return value;
    }
    return nil;
}


- (NSDictionary*)yq_dictionaryWithIndex:(NSUInteger)index
{
    id value = [self yq_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSDictionary class]])
    {
        return value;
    }
    return nil;
}

- (NSInteger)yq_integerWithIndex:(NSUInteger)index
{
    id value = [self yq_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value integerValue];
    }
    return 0;
}
- (NSUInteger)yq_unsignedIntegerWithIndex:(NSUInteger)index
{
    id value = [self yq_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value unsignedIntegerValue];
    }
    return 0;
}
- (BOOL)yq_boolWithIndex:(NSUInteger)index
{
    id value = [self yq_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return NO;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value boolValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value boolValue];
    }
    return NO;
}
- (int16_t)yq_int16WithIndex:(NSUInteger)index
{
    id value = [self yq_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}
- (int32_t)yq_int32WithIndex:(NSUInteger)index
{
    id value = [self yq_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}
- (int64_t)yq_int64WithIndex:(NSUInteger)index
{
    id value = [self yq_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value longLongValue];
    }
    return 0;
}

- (char)yq_charWithIndex:(NSUInteger)index{
    
    id value = [self yq_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value charValue];
    }
    return 0;
}

- (short)yq_shortWithIndex:(NSUInteger)index
{
    id value = [self yq_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}
- (float)yq_floatWithIndex:(NSUInteger)index
{
    id value = [self yq_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value floatValue];
    }
    return 0;
}
- (double)yq_doubleWithIndex:(NSUInteger)index
{
    id value = [self yq_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value doubleValue];
    }
    return 0;
}

- (NSDate *)yq_dateWithIndex:(NSUInteger)index dateFormat:(NSString *)dateFormat {
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = dateFormat;
    id value = [self yq_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    
    if ([value isKindOfClass:[NSString class]] && ![value isEqualToString:@""] && !dateFormat) {
        return [formater dateFromString:value];
    }
    return nil;
}

//CG
- (CGFloat)yq_CGFloatWithIndex:(NSUInteger)index
{
    id value = [self yq_objectWithIndex:index];
    
    CGFloat f = [value doubleValue];
    
    return f;
}

- (CGPoint)yq_pointWithIndex:(NSUInteger)index
{
    id value = [self yq_objectWithIndex:index];
    
    CGPoint point = CGPointFromString(value);
    
    return point;
}
- (CGSize)yq_sizeWithIndex:(NSUInteger)index
{
    id value = [self yq_objectWithIndex:index];
    
    CGSize size = CGSizeFromString(value);
    
    return size;
}
- (CGRect)yq_rectWithIndex:(NSUInteger)index
{
    id value = [self yq_objectWithIndex:index];
    
    CGRect rect = CGRectFromString(value);
    
    return rect;
}

@end


#pragma --mark NSMutableArray
@implementation NSMutableArray (SafeAccess_yq)

-(void)yq_addObj:(id)i{
    if (i!=nil) {
        [self addObject:i];
    }
}
-(void)yq_addString:(NSString*)i
{
    if (i!=nil) {
        [self addObject:i];
    }
}
-(void)yq_addBool:(BOOL)i
{
    [self addObject:@(i)];
}
-(void)yq_addInt:(int)i
{
    [self addObject:@(i)];
}
-(void)yq_addInteger:(NSInteger)i
{
    [self addObject:@(i)];
}
-(void)yq_addUnsignedInteger:(NSUInteger)i
{
    [self addObject:@(i)];
}
-(void)yq_addCGFloat:(CGFloat)f
{
    [self addObject:@(f)];
}
-(void)yq_addChar:(char)c
{
    [self addObject:@(c)];
}
-(void)yq_addFloat:(float)i
{
    [self addObject:@(i)];
}
-(void)yq_addPoint:(CGPoint)o
{
    [self addObject:NSStringFromCGPoint(o)];
}
-(void)yq_addSize:(CGSize)o
{
    [self addObject:NSStringFromCGSize(o)];
}
-(void)yq_addRect:(CGRect)o
{
    [self addObject:NSStringFromCGRect(o)];
}

@end
