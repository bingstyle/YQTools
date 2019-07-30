//
//  WXBNavigationBar.m
//
//  Created by WeiXinbing on 2019/7/26.
//  Copyright © 2019 xinwei. All rights reserved.
//

#import "WXBNavigationBar.h"
@import ObjectiveC.runtime;

static inline void wxb_swizzling_exchangeMethod(Class clazz ,SEL originalSelector, SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector);
    
    BOOL success = class_addMethod(clazz, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

typedef void (^_WXBViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

#pragma mark - Private
@interface UIViewController ()

@property (nonatomic, copy) _WXBViewControllerWillAppearInjectBlock wxb_willAppearInjectBlock;

@end


@interface _WXBFullscreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation _WXBFullscreenPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Ignore when no view controller is pushed into the navigation stack.
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    // Disable when the active view controller doesn't allow interactive pop.
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController.wxb_interactivePopDisabled) {
        return NO;
    }
    
    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // Prevent calling the handler when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return YES;
}

@end


#pragma mark - Public

@implementation UINavigationBar (wxb_default)

/** 更新导航栏背景透明度 */
- (void)updateNavBarBackgroundAlpha:(CGFloat)alpha {

    self.translucent = YES; // 修正translucent为YES，此属性可能被隐式修改，在使用 setBackgroundImage:forBarMetrics: 方法时，如果 image 里的像素点没有 alpha 通道或者 alpha 全部等于 1 会使得 translucent 变为 NO 或者 nil。
    [self setShadowImage:alpha < 1 ? [UIImage new] : nil];

    UIView *barBackgroundView = self.subviews.firstObject;
    if (@available(iOS 11.0, *)) {
        for (UIView *view in barBackgroundView.subviews) {
            view.alpha = alpha;
        }
        [barBackgroundView.subviews.firstObject setHidden:alpha == 0];
    } else {
        barBackgroundView.alpha = alpha;
    }
}

@end

/**
 UINavigationController 扩展
 */

@implementation UINavigationController (wxb_nav)

#pragma mark - call swizzling methods active 主动调用交换方法
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wxb_swizzling_exchangeMethod([UINavigationController class] ,NSSelectorFromString(@"_updateInteractiveTransition:"),    @selector(wxb_updateInteractiveTransition:));
        wxb_swizzling_exchangeMethod([UINavigationController class], @selector(popToViewController:animated:), @selector(wxb_popToViewController:animated:));
        wxb_swizzling_exchangeMethod([UINavigationController class], @selector(popToRootViewControllerAnimated:), @selector(wxb_popToRootViewControllerAnimated:));
        wxb_swizzling_exchangeMethod([UINavigationController class], @selector(pushViewController:animated:), @selector(wxb_pushViewController:animated:));
    });
}

#pragma mark - Getter & Setter
- (BOOL)wxb_viewControllerBasedNavigationBarAppearanceEnabled {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) {
        return number.boolValue;
    }
    self.wxb_viewControllerBasedNavigationBarAppearanceEnabled = YES;
    return YES;
}
- (void)setWxb_viewControllerBasedNavigationBarAppearanceEnabled:(BOOL)enabled {
    SEL key = @selector(wxb_viewControllerBasedNavigationBarAppearanceEnabled);
    objc_setAssociatedObject(self, key, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (_WXBFullscreenPopGestureRecognizerDelegate *)wxb_popGestureRecognizerDelegate
{
    _WXBFullscreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    
    if (!delegate) {
        delegate = [[_WXBFullscreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}
- (UIPanGestureRecognizer *)wxb_fullscreenPopGestureRecognizer
{
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

#pragma mark - runtime交换后的方法
// 交换的方法，监控滑动手势
- (void)wxb_updateInteractiveTransition:(CGFloat)percentComplete {
    [self wxb_updateInteractiveTransition:(percentComplete)];
    UIViewController *topVC = self.topViewController;
    if (topVC != nil) {
        id<UIViewControllerTransitionCoordinator> coor = topVC.transitionCoordinator;
        if (coor != nil) {
            // 随着滑动的过程设置导航栏透明度渐变
            CGFloat fromAlpha = [coor viewControllerForKey:UITransitionContextFromViewControllerKey].wxb_navBarBackgroundAlpha;
            CGFloat toAlpha = [coor viewControllerForKey:UITransitionContextToViewControllerKey].wxb_navBarBackgroundAlpha;
            CGFloat nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete;
            
            [self.navigationBar updateNavBarBackgroundAlpha:nowAlpha];
            
            if (@available(iOS 10.0, *))
            {
                [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    [self dealInteractionChanges:context];
                }];
            }
            else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context){
                    [self dealInteractionChanges:context];
                }];
#pragma clang diagnostic pop
            }
        }
    }
}

- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    if ([context isCancelled]) {// 自动取消了返回手势
        NSTimeInterval cancelDuration = [context transitionDuration] * (double)[context percentComplete];
        [UIView animateWithDuration:cancelDuration animations:^{
            CGFloat nowAlpha = [context viewControllerForKey:UITransitionContextFromViewControllerKey].wxb_navBarBackgroundAlpha;
            NSLog(@"自动取消返回到alpha：%f", nowAlpha);
            [self.navigationBar updateNavBarBackgroundAlpha:nowAlpha];
        }];
    } else {// 自动完成了返回手势
        NSTimeInterval finishDuration = [context transitionDuration] * (double)(1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            CGFloat nowAlpha = [context viewControllerForKey:
                                 UITransitionContextToViewControllerKey].wxb_navBarBackgroundAlpha;
            NSLog(@"自动完成返回到alpha：%f", nowAlpha);
            [self.navigationBar updateNavBarBackgroundAlpha:nowAlpha];
        }];
    }
}

#pragma mark - Pop
static CGFloat popDuration = 0.3;
static int popDisplayCount = 0;
- (CGFloat)popProgress {
    CGFloat all = 60 * popDuration;
    int current = MIN(all, popDisplayCount);
    return current / all;
}

- (NSArray<UIViewController *> *)wxb_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {

    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(popNeedDisplay)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        popDisplayCount = 0;
    }];
    [CATransaction setAnimationDuration:popDuration];
    [CATransaction begin];
    NSArray<UIViewController *> *vcs = [self wxb_popToViewController:viewController animated:animated];
    [CATransaction commit];
    return vcs;
}

- (NSArray<UIViewController *> *)wxb_popToRootViewControllerAnimated:(BOOL)animated {
    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(popNeedDisplay)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        popDisplayCount = 0;
    }];
    [CATransaction setAnimationDuration:popDuration];
    [CATransaction begin];
    NSArray<UIViewController *> *vcs = [self wxb_popToRootViewControllerAnimated:animated];
    [CATransaction commit];
    return vcs;
}
- (void)popNeedDisplay {
    if (self.topViewController != nil && self.topViewController.transitionCoordinator != nil) {
        popDisplayCount += 1;
        CGFloat progress = [self popProgress];
        
        CGFloat fromAlpha = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey].wxb_navBarBackgroundAlpha;
        CGFloat toAlpha = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey].wxb_navBarBackgroundAlpha;
        CGFloat nowAlpha = fromAlpha + (toAlpha - fromAlpha) * progress;
        
        [self.navigationBar updateNavBarBackgroundAlpha:nowAlpha];
    }
}

#pragma mark - Push
static CGFloat pushDuration = 0.5;
static int pushDisplayCount = 0;
- (CGFloat)pushProgress {
    CGFloat all = 60 * pushDuration;
    int current = MIN(all, pushDisplayCount);
    return current / all;
}

- (void)wxb_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.wxb_fullscreenPopGestureRecognizer]) {

        // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.wxb_fullscreenPopGestureRecognizer];

        // Forward the gesture events to the private handler of the onboard gesture recognizer.
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.wxb_fullscreenPopGestureRecognizer.delegate = self.wxb_popGestureRecognizerDelegate;
        [self.wxb_fullscreenPopGestureRecognizer addTarget:internalTarget action:internalAction];

        // Disable the onboard gesture recognizer.
        self.interactivePopGestureRecognizer.enabled = NO;
    }

    // Handle perferred navigation bar appearance.
    [self wxb_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];


    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(pushNeedDisplay)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        pushDisplayCount = 0;
    }];
    [CATransaction setAnimationDuration:pushDuration];
    [CATransaction begin];
    [self wxb_pushViewController:viewController animated:animated];
    [CATransaction commit];
}

- (void)pushNeedDisplay {
    if (self.topViewController != nil && self.topViewController.transitionCoordinator != nil) {
        pushDisplayCount += 1;
        CGFloat progress = [self pushProgress];
        CGFloat fromAlpha = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey].wxb_navBarBackgroundAlpha;
        CGFloat toAlpha = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey].wxb_navBarBackgroundAlpha;
        CGFloat nowAlpha = fromAlpha + (toAlpha - fromAlpha) * progress;
        
        [self.navigationBar updateNavBarBackgroundAlpha:nowAlpha];
    }
}

- (void)wxb_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController
{
    if (!self.wxb_viewControllerBasedNavigationBarAppearanceEnabled) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    _WXBViewControllerWillAppearInjectBlock block = ^(UIViewController *viewController, BOOL animated) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf setNavigationBarHidden:viewController.wxb_prefersNavigationBarHidden animated:animated];
        }
    };

    // Setup will appear inject block to appearing view controller.
    // Setup disappearing view controller as well, because not every view controller is added into
    // stack by pushing, maybe by "-setViewControllers:".
    appearingViewController.wxb_willAppearInjectBlock = block;
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.wxb_willAppearInjectBlock) {
        disappearingViewController.wxb_willAppearInjectBlock = block;
    }
}

@end


/**
 UIViewController 扩展
 */

@implementation UIViewController (wxb_nav)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wxb_swizzling_exchangeMethod([UIViewController class] ,@selector(viewWillAppear:),    @selector(wxb_viewWillAppear:));
    });
}

- (void)wxb_viewWillAppear:(BOOL)animated
{
    // Forward to primary implementation.
    [self wxb_viewWillAppear:animated];

    if (self.wxb_willAppearInjectBlock) {
        self.wxb_willAppearInjectBlock(self, animated);
    }
}

#pragma mark - Getter & Setter
- (_WXBViewControllerWillAppearInjectBlock)wxb_willAppearInjectBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setWxb_willAppearInjectBlock:(_WXBViewControllerWillAppearInjectBlock)block {
    objc_setAssociatedObject(self, @selector(wxb_willAppearInjectBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)wxb_navBarBackgroundAlpha {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number ? number.floatValue : 1;
}
- (void)setWxb_navBarBackgroundAlpha:(CGFloat)alpha {
    objc_setAssociatedObject(self, @selector(wxb_navBarBackgroundAlpha), @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController.navigationBar updateNavBarBackgroundAlpha:alpha];
}

- (BOOL)wxb_interactivePopDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setWxb_interactivePopDisabled:(BOOL)disabled {
    objc_setAssociatedObject(self, @selector(wxb_interactivePopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)wxb_prefersNavigationBarHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setWxb_prefersNavigationBarHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, @selector(wxb_prefersNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
