//
//  WXBNavigationBar.h
//  Test
//
//  Created by WeiXinbing on 2019/7/26.
//  Copyright © 2019 xinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (wxb_default)

@end

@interface UINavigationController (wxb_nav)

/// 全屏返回手势
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *wxb_fullscreenPopGestureRecognizer;

/// 视图控制器能够自己控制导航条的外观，
/// 不是全局方法，而是检查“wxb_prefersNavigationBarHidden”属性。
/// 默认为YES，如果不需要禁用它。
@property (nonatomic, assign) BOOL wxb_viewControllerBasedNavigationBarAppearanceEnabled;

@end


@interface UIViewController (wxb_nav)

/**
 导航栏背景透明度
 */
@property (nonatomic, assign) CGFloat wxb_navBarBackgroundAlpha;

/**
 是否禁用返回手势
 */
@property (nonatomic, assign) BOOL wxb_interactivePopDisabled;

/**
 是否隐藏导航栏，默认为NO
 */
@property (nonatomic, assign) BOOL wxb_prefersNavigationBarHidden;


@end


NS_ASSUME_NONNULL_END
