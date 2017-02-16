//
//  UITextField+Select_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Select_yq)

/**
 *  @brief  当前选中的字符串范围
 *
 *  @return NSRange
 */
- (NSRange)yq_selectedRange;
/**
 *  @brief  选中所有文字
 */
- (void)yq_selectAllText;
/**
 *  @brief  选中指定范围的文字
 *
 *  @param range NSRange范围
 */
- (void)yq_setSelectedRange:(NSRange)range;

@end
