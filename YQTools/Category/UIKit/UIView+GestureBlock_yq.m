//
//  UIView+GestureBlock_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/3/23.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "UIView+GestureBlock_yq.h"
@import ObjectiveC.runtime;
/* 单击key */
static char yq_kActionHandlerTapBlockKey;
static char yq_kActionHandlerTapGestureKey;
/* 双击key */
static char yq_kActionHandlerDoubleTapBlockKey;
static char yq_kActionHandlerDoubleTapGestureKey;
/* 长按key */
static char yq_kActionHandlerLongPressBlockKey;
static char yq_kActionHandlerLongPressGestureKey;

@implementation UIView (GestureBlock_yq)

- (void)yq_whenTapped:(void (^)(UITapGestureRecognizer * _Nonnull))block {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &yq_kActionHandlerTapGestureKey);
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yq_handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &yq_kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &yq_kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)yq_handleActionForTapGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        void(^block)(UITapGestureRecognizer *) = objc_getAssociatedObject(self, &yq_kActionHandlerTapBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}
- (void)yq_whenDoubleTapped:(void (^)(UITapGestureRecognizer * _Nonnull))block {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &yq_kActionHandlerDoubleTapGestureKey);
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yq_handleActionForDoubleTapGesture:)];
        gesture.numberOfTouchesRequired = 1; //点击手指数
        gesture.numberOfTapsRequired = 2; //点击次数
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &yq_kActionHandlerDoubleTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &yq_kActionHandlerDoubleTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)yq_handleActionForDoubleTapGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        void(^block)(UITapGestureRecognizer *) = objc_getAssociatedObject(self, &yq_kActionHandlerDoubleTapBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}

- (void)yq_whenLongPressed:(void (^)(UILongPressGestureRecognizer * _Nonnull))block
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
- (void)yq_handleActionForLongPressGesture:(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        void(^block)(UILongPressGestureRecognizer *) = objc_getAssociatedObject(self, &yq_kActionHandlerLongPressBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}

@end
