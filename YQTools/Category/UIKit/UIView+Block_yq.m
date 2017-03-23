//
//  UIView+Block_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/3/23.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "UIView+Block_yq.h"
#import "UIGestureRecognizer+Block_yq.h"
@import ObjectiveC.runtime;

static char yq_kActionHandlerLongPressBlockKey;
static char yq_kActionHandlerLongPressGestureKey;

@implementation UIView (Block_yq)

- (void)yq_whenTouches:(NSUInteger)numberOfTouches tapped:(NSUInteger)numberOfTaps handler:(void (^)(void))block
{
    if (!block) return;
    
    UITapGestureRecognizer *gesture = [UITapGestureRecognizer yq_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        if (state == UIGestureRecognizerStateRecognized) block();
    }];
    
    gesture.numberOfTouchesRequired = numberOfTouches;
    gesture.numberOfTapsRequired = numberOfTaps;
    
    [self.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[UITapGestureRecognizer class]]) return;
        
        UITapGestureRecognizer *tap = obj;
        BOOL rightTouches = (tap.numberOfTouchesRequired == numberOfTouches);
        BOOL rightTaps = (tap.numberOfTapsRequired == numberOfTaps);
        if (rightTouches && rightTaps) {
            [gesture requireGestureRecognizerToFail:tap];
        }
    }];
    
    [self addGestureRecognizer:gesture];
}

- (void)yq_whenTapped:(void (^)(void))block
{
    [self yq_whenTouches:1 tapped:1 handler:block];
}

- (void)yq_whenDoubleTapped:(void (^)(void))block
{
    [self yq_whenTouches:1 tapped:2 handler:block];
}

- (void)yq_eachSubview:(void (^)(UIView *subview))block
{
    NSParameterAssert(block != nil);
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        block(subview);
    }];
}

- (void)yq_whenLongPressed:(void (^)(UIGestureRecognizer * _Nonnull))block
{
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &yq_kActionHandlerLongPressGestureKey);
    if (!gesture)
    {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(yq_handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &yq_kActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &yq_kActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}
- (void)yq_handleActionForLongPressGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        void(^block)(UIGestureRecognizer *gestureRecoginzer) = objc_getAssociatedObject(self, &yq_kActionHandlerLongPressBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}

@end
