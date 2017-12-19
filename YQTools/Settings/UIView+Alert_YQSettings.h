//
//  UIView+Alert_YQSettings.h
//  YQSettingsDemo
//
//  Created by weixb on 2017/12/19.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Alert_YQSettings)

#pragma mark - show in window

- (void)showInWindow;

// backgoundTapDismissEnable default NO
- (void)showInWindowWithBackgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable;

- (void)showInWindowWithOriginY:(CGFloat)OriginY;

- (void)showInWindowWithOriginY:(CGFloat)OriginY backgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable;


#pragma mark - hide

// this will judge and call right method
- (void)hideView;

- (void)hideInWindow;

@end
