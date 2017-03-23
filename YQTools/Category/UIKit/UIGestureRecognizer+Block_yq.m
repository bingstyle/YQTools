//
//  UIGestureRecognizer+Block_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/3/23.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "UIGestureRecognizer+Block_yq.h"
#import "NSObject+Block_yq.h"

@import ObjectiveC.runtime;

static const void *BKGestureRecognizerBlockKey = &BKGestureRecognizerBlockKey;
static const void *BKGestureRecognizerDelayKey = &BKGestureRecognizerDelayKey;
static const void *BKGestureRecognizerShouldHandleActionKey = &BKGestureRecognizerShouldHandleActionKey;

@interface UIGestureRecognizer (BlocksKitInternal)

@property (nonatomic, setter = yq_setShouldHandleAction:) BOOL yq_shouldHandleAction;

- (void)yq_handleAction:(UIGestureRecognizer *)recognizer;

@end

@implementation UIGestureRecognizer (Block_yq)

+ (instancetype)yq_recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay
{
    return [[[self class] alloc] yq_initWithHandler:block delay:delay];
}

- (instancetype)yq_initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay
{
    self = [self initWithTarget:self action:@selector(yq_handleAction:)];
    if (!self) return nil;
    
    self.yq_handler = block;
    self.yq_handlerDelay = delay;
    
    return self;
}

+ (instancetype)yq_recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block
{
    return [self yq_recognizerWithHandler:block delay:0.0];
}

- (instancetype)yq_initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block
{
    return (self = [self yq_initWithHandler:block delay:0.0]);
}

- (void)yq_handleAction:(UIGestureRecognizer *)recognizer
{
    void (^handler)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) = recognizer.yq_handler;
    if (!handler) return;
    
    NSTimeInterval delay = self.yq_handlerDelay;
    CGPoint location = [self locationInView:self.view];
    void (^block)(void) = ^{
        if (!self.yq_shouldHandleAction) return;
        handler(self, self.state, location);
    };
    
    self.yq_shouldHandleAction = YES;
    
    [NSObject yq_performAfterDelay:delay usingBlock:block];
}

- (void)yq_setHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))handler
{
    objc_setAssociatedObject(self, BKGestureRecognizerBlockKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))yq_handler
{
    return objc_getAssociatedObject(self, BKGestureRecognizerBlockKey);
}

- (void)yq_setHandlerDelay:(NSTimeInterval)delay
{
    NSNumber *delayValue = delay ? @(delay) : nil;
    objc_setAssociatedObject(self, BKGestureRecognizerDelayKey, delayValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)yq_handlerDelay
{
    return [objc_getAssociatedObject(self, BKGestureRecognizerDelayKey) doubleValue];
}

- (void)yq_setShouldHandleAction:(BOOL)flag
{
    objc_setAssociatedObject(self, BKGestureRecognizerShouldHandleActionKey, @(flag), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)yq_shouldHandleAction
{
    return [objc_getAssociatedObject(self, BKGestureRecognizerShouldHandleActionKey) boolValue];
}

- (void)yq_cancel
{
    self.yq_shouldHandleAction = NO;
}

@end
