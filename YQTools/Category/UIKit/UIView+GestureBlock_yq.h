//
//  UIView+GestureBlock_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/3/23.
//  Copyright © 2017年 weixb. All rights reserved.
//
/* https://github.com/weixinbing/YQTools */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (GestureBlock_yq)
/**
 *  轻击手势
 *
 *  @param numberOfTouches 触摸手指数
 *  @param numberOfTaps    点击次数
 *  @param block           回调
 */
- (void)yq_whenTouches:(NSUInteger)numberOfTouches taps:(NSUInteger)numberOfTaps block:(void(^)(UITapGestureRecognizer *tapGesture))block;
/**
 *  @brief  单击手势
 *
 *  @param block 回调
 */
- (void)yq_whenTapped:(void(^)(UITapGestureRecognizer *tapGesture))block;
/**
 *  @brief  双击手势
 *
 *  @param block 回调
 */
- (void)yq_whenDoubleTapped:(void(^)(UITapGestureRecognizer *tapGesture))block;

/**
 *  @brief  长按手势
 *
 *  @param block 回调
 */
- (void)yq_whenLongPressed:(void(^)(UILongPressGestureRecognizer *longPressGesture))block;

/**
 *  轻扫手势
 *
 *  @param numberOfTouches 触摸手指数
 *  @param direction       轻扫方向
 *  @param block           回调
 */
- (void)yq_whenSwipedWithTouches:(NSUInteger)numberOfTouches direction:(UISwipeGestureRecognizerDirection)direction block:(void(^)(UISwipeGestureRecognizer *swipeGesture))block;
/**
 *  @brief  单指轻扫
 *
 *  @param block 回调
 */
- (void)yq_whenSwipedWithDirection:(UISwipeGestureRecognizerDirection)direction block:(void(^)(UISwipeGestureRecognizer *swipeGesture))block;
- (void)yq_whenSwipedLeft:(void(^)(UISwipeGestureRecognizer *swipeGesture))block;
- (void)yq_whenSwipedRight:(void(^)(UISwipeGestureRecognizer *swipeGesture))block;
- (void)yq_whenSwipedUp:(void(^)(UISwipeGestureRecognizer *swipeGesture))block;
- (void)yq_whenSwipedDown:(void(^)(UISwipeGestureRecognizer *swipeGesture))block;

/**
 *  @brief  捏合手势
 *
 *  @param block 回调
 */
- (void)yq_whenPinch:(void(^)(UIPinchGestureRecognizer *pinchGesture))block;

/**
 *  @brief  拖动手势
 *
 *  @param block 回调
 */
- (void)yq_whenPan:(void(^)(UIPanGestureRecognizer *pinchGesture))block;

/**
 *  @brief  旋转手势
 *
 *  @param block 回调
 */
- (void)yq_whenRotation:(void(^)(UIRotationGestureRecognizer *pinchGesture))block;


@end

NS_ASSUME_NONNULL_END
