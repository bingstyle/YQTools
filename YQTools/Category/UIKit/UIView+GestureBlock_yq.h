//
//  UIView+GestureBlock_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/3/23.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (GestureBlock_yq)

/**
 *  @brief  添加单击手势
 *
 *  @param block 回调
 */
- (void)yq_whenTapped:(void(^)(UITapGestureRecognizer *tapGesture))block;
/**
 *  @brief  添加双击手势
 *
 *  @param block 回调
 */
- (void)yq_whenDoubleTapped:(void(^)(UITapGestureRecognizer *tapGesture))block;
/**
 *  @brief  添加长按手势
 *
 *  @param block 回调
 */
- (void)yq_whenLongPressed:(void(^)(UILongPressGestureRecognizer *longPressGesture))block;

@end

NS_ASSUME_NONNULL_END
