//
//  UINavigationController+Transitions_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Transitions_yq)

- (void)yq_pushViewController:(UIViewController *)controller withTransition:(UIViewAnimationTransition)transition;

- (UIViewController *)yq_popViewControllerWithTransition:(UIViewAnimationTransition)transition;

@end
