//
//  UIView+AutoLayout_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/12/19.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoLayout_yq)

- (void)yq_addConstraintToView:(UIView *)view edgeInset:(UIEdgeInsets)edgeInset;

- (void)yq_addConstraintWithView:(UIView *)view topView:(UIView *)topView leftView:(UIView *)leftView
                   bottomView:(UIView *)bottomView rightView:(UIView *)rightView edgeInset:(UIEdgeInsets)edgeInset;

- (void)yq_addConstraintWithLeftView:(UIView *)leftView toRightView:(UIView *)rightView constant:(CGFloat)constant;

- (NSLayoutConstraint *)yq_addConstraintWithTopView:(UIView *)topView toBottomView:(UIView *)bottomView constant:(CGFloat)constant;

- (void)yq_addConstraintWidth:(CGFloat)width height:(CGFloat)height;

- (void)yq_addConstraintEqualWithView:(UIView *)view widthToView:(UIView *)wView heightToView:(UIView *)hView;

- (NSLayoutConstraint *)yq_addConstraintCenterYToView:(UIView *)yView constant:(CGFloat)constant;

- (void)yq_addConstraintCenterXToView:(UIView *)xView centerYToView:(UIView *)yView;

- (void)yq_removeConstraintWithAttribte:(NSLayoutAttribute)attr;

- (void)yq_removeConstraintWithView:(UIView *)view attribute:(NSLayoutAttribute)attr;

- (void)yq_removeAllConstraints;

@end
