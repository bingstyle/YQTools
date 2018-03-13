//
//  NSObject+Unicode_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2018/3/13.
//  Copyright © 2018年 weixb. All rights reserved.
//

#import "NSObject+Unicode_yq.h"
#ifndef YQ_TARGET_NEED_UNICODE_CONVERSION
#ifdef DEBUG
#define YQ_TARGET_NEED_UNICODE_CONVERSION 1
#else
#define YQ_TARGET_NEED_UNICODE_CONVERSION 0
#endif
#endif

#if YQ_TARGET_NEED_UNICODE_CONVERSION
#import <objc/runtime.h>
static inline void swizzleSelector(Class theClass, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(theClass, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(theClass,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(theClass,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

static inline id stringByReplaceUnicode(NSString *unicodeString)
{
    NSMutableString *convertedString = [unicodeString mutableCopy];
    [convertedString replaceOccurrencesOfString:@"\\U" withString:@"\\u" options:0 range:NSMakeRange(0, convertedString.length)];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
    
    return convertedString;
}


@implementation NSArray (Unicode_yq)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleSelector([self class], @selector(descriptionWithLocale:indent:), @selector(swizzling_descriptionWithLocale:indent:));
    });
}

- (NSString *)swizzling_descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return stringByReplaceUnicode([self swizzling_descriptionWithLocale:locale indent:level]);
}

@end


@implementation NSDictionary (Unicode_yq)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleSelector([self class], @selector(descriptionWithLocale:indent:), @selector(swizzling_descriptionWithLocale:indent:));
    });
}

- (NSString *)swizzling_descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return stringByReplaceUnicode([self swizzling_descriptionWithLocale:locale indent:level]);
}
@end

#endif
