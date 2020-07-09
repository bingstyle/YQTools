//
//  UIView+Alert_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/12/19.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Alert_yq)

#pragma mark - show in window

- (void)yq_showInWindow;

// backgoundTapDismissEnable default NO
- (void)yq_showInWindowWithBackgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable;

- (void)yq_showInWindowWithOriginY:(CGFloat)OriginY;

- (void)yq_showInWindowWithOriginY:(CGFloat)OriginY backgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable;


#pragma mark - hide

// this will judge and call right method
- (void)yq_hideView;

- (void)yq_hideInWindow;

@end
