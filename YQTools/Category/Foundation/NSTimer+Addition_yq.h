//
//  NSTimer+Addition_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition_yq)

/**
 *  @brief  暂停NSTimer
 */
- (void)yq_pauseTimer;
/**
 *  @brief  开始NSTimer
 */
- (void)yq_resumeTimer;
/**
 *  @brief  延迟开始NSTimer
 */
- (void)yq_resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
