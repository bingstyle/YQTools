//
//  UIView+Toast_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString * const YQToastPositionTop;
extern NSString * const YQToastPositionCenter;
extern NSString * const YQToastPositionBottom;

@interface UIView (Toast_yq)

// each makeToast method creates a view and displays it as toast
- (void)yq_makeToast:(NSString *)message;
- (void)yq_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position;
- (void)yq_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position image:(UIImage *)image;
- (void)yq_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position title:(NSString *)title;
- (void)yq_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position title:(NSString *)title image:(UIImage *)image;

// displays toast with an activity spinner
- (void)yq_makeToastActivity;
- (void)yq_makeToastActivity:(id)position;
- (void)yq_hideToastActivity;

// the showToast methods display any view as toast
- (void)yq_showToast:(UIView *)toast;
- (void)yq_showToast:(UIView *)toast duration:(NSTimeInterval)interval position:(id)point;
- (void)yq_showToast:(UIView *)toast duration:(NSTimeInterval)interval position:(id)point
          tapCallback:(void(^)(void))tapCallback;

@end
