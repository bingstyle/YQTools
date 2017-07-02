//
//  UIView+GestureBlock_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/3/23.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "UIView+GestureBlock_yq.h"
@import ObjectiveC.runtime;

#define yq_objcAssociatedGesturekKey (__bridge const void *)(block)
#define yq_objcAssociatedBlockkKey (__bridge const void *)(gesture)

@implementation UIView (GestureBlock_yq)

/* 轻击手势key */
//static char yq_kActionHandlerTapBlockKey;

- (void)yq_whenTouches:(NSUInteger)numberOfTouches taps:(NSUInteger)numberOfTaps block:(void (^)(UITapGestureRecognizer * _Nonnull))block {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, yq_objcAssociatedGesturekKey);
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yq_handleActionForTapGesture:)];
        gesture.numberOfTouchesRequired = numberOfTouches; //触摸手指数
        gesture.numberOfTapsRequired = numberOfTaps; //点击次数
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, yq_objcAssociatedGesturekKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, yq_objcAssociatedBlockkKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)yq_handleActionForTapGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        void(^block)(UITapGestureRecognizer *) = objc_getAssociatedObject(self, yq_objcAssociatedBlockkKey);
        if (block) block(gesture);
    }
}

/* 单击 */
- (void)yq_whenTapped:(void (^)(UITapGestureRecognizer * _Nonnull))block {
    [self yq_whenTouches:1 taps:1 block:block];
}
/* 双击 */
- (void)yq_whenDoubleTapped:(void (^)(UITapGestureRecognizer * _Nonnull))block {
    [self yq_whenTouches:1 taps:2 block:block];
}

/* 长按手势key */
static char yq_kActionHandlerLongPressBlockKey;

- (void)yq_whenLongPressed:(void (^)(UILongPressGestureRecognizer * _Nonnull))block
{
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, yq_objcAssociatedGesturekKey);
    if (!gesture)
    {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(yq_handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, yq_objcAssociatedGesturekKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &yq_kActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}
- (void)yq_handleActionForLongPressGesture:(UILongPressGestureRecognizer*)gesture
{
    void(^block)(UILongPressGestureRecognizer *) = objc_getAssociatedObject(self, &yq_kActionHandlerLongPressBlockKey);
    if (block) block(gesture);
}

/* 轻扫手势key */
//static char yq_kActionHandlerSwipeBlockKey;

- (void)yq_whenSwipedWithTouches:(NSUInteger)numberOfTouches direction:(UISwipeGestureRecognizerDirection)direction block:(void (^)(UISwipeGestureRecognizer * _Nonnull))block {
    UISwipeGestureRecognizer *gesture = objc_getAssociatedObject(self, yq_objcAssociatedGesturekKey);
    if (!gesture)
    {
        gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(yq_handleActionForSwipeGesture:)];
        gesture.numberOfTouchesRequired = numberOfTouches; //触摸手指数
        gesture.direction = direction; //轻扫方向
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, yq_objcAssociatedGesturekKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, yq_objcAssociatedBlockkKey, block, OBJC_ASSOCIATION_COPY);
}
/* 单指轻扫 */
- (void)yq_whenSwipedWithDirection:(UISwipeGestureRecognizerDirection)direction block:(void (^)(UISwipeGestureRecognizer * _Nonnull))block {
    [self yq_whenSwipedWithTouches:1 direction:direction block:block];
}
- (void)yq_whenSwipedLeft:(void (^)(UISwipeGestureRecognizer * _Nonnull))block {
    [self yq_whenSwipedWithDirection:UISwipeGestureRecognizerDirectionLeft block:block];
}
- (void)yq_whenSwipedRight:(void (^)(UISwipeGestureRecognizer * _Nonnull))block {
    [self yq_whenSwipedWithDirection:UISwipeGestureRecognizerDirectionRight block:block];
}
- (void)yq_whenSwipedUp:(void (^)(UISwipeGestureRecognizer * _Nonnull))block {
    [self yq_whenSwipedWithDirection:UISwipeGestureRecognizerDirectionUp block:block];
}
- (void)yq_whenSwipedDown:(void (^)(UISwipeGestureRecognizer * _Nonnull))block {
    [self yq_whenSwipedWithDirection:UISwipeGestureRecognizerDirectionDown block:block];
}

- (void)yq_handleActionForSwipeGesture:(UISwipeGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        void(^block)(UISwipeGestureRecognizer *) = objc_getAssociatedObject(self, yq_objcAssociatedBlockkKey);
        if (block) block(gesture);
    }
}

/* 捏合手势key */
static char yq_kActionHandlerPinchBlockKey;

- (void)yq_whenPinch:(void (^)(UIPinchGestureRecognizer * _Nonnull))block {
    UIPinchGestureRecognizer *gesture = objc_getAssociatedObject(self, yq_objcAssociatedGesturekKey);
    if (!gesture)
    {
        gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(yq_handleActionForPinchGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, yq_objcAssociatedGesturekKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &yq_kActionHandlerPinchBlockKey, block, OBJC_ASSOCIATION_COPY);
}
- (void)yq_handleActionForPinchGesture:(UIPinchGestureRecognizer*)gesture
{
    void(^block)(UIPinchGestureRecognizer *) = objc_getAssociatedObject(self, &yq_kActionHandlerPinchBlockKey);
    if (block) block(gesture);
}

/* 拖动手势key */
static char yq_kActionHandlerPanBlockKey;

- (void)yq_whenPan:(void (^)(UIPanGestureRecognizer * _Nonnull))block {
    UIPanGestureRecognizer *gesture = objc_getAssociatedObject(self, yq_objcAssociatedGesturekKey);
    if (!gesture)
    {
        gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(yq_handleActionForPanGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, yq_objcAssociatedGesturekKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &yq_kActionHandlerPanBlockKey, block, OBJC_ASSOCIATION_COPY);
}
- (void)yq_handleActionForPanGesture:(UIPanGestureRecognizer*)gesture
{
    void(^block)(UIPanGestureRecognizer *) = objc_getAssociatedObject(self, &yq_kActionHandlerPanBlockKey);
    if (block) block(gesture);
}

/* 旋转手势key */
static char yq_kActionHandlerRotationBlockKey;

- (void)yq_whenRotation:(void (^)(UIRotationGestureRecognizer * _Nonnull))block {
    UIRotationGestureRecognizer *gesture = objc_getAssociatedObject(self, yq_objcAssociatedGesturekKey);
    if (!gesture)
    {
        gesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(yq_handleActionForRotationGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, yq_objcAssociatedGesturekKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &yq_kActionHandlerRotationBlockKey, block, OBJC_ASSOCIATION_COPY);
}
- (void)yq_handleActionForRotationGesture:(UIRotationGestureRecognizer*)gesture
{
    void(^block)(UIRotationGestureRecognizer *) = objc_getAssociatedObject(self, &yq_kActionHandlerRotationBlockKey);
    if (block) block(gesture);
}

@end








