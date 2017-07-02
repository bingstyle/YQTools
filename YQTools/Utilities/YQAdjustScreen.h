//
//  YQAdjustScreen.h
//  YQToolsDemo
//
//  Created by weixb on 2017/3/22.
//  Copyright © 2017年 weixb. All rights reserved.
//

#ifndef YQAdjustScreen_h
#define YQAdjustScreen_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define ORIGIN_WIDTH 375
#define ORIGIN_HEIGHT 667
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

#define DH_INLINE static inline

// 屏幕竖直方向的比例
DH_INLINE CGFloat YQVerticalMutiplier()
{
    return SCREEN_SIZE.height/ORIGIN_HEIGHT;
}
/**
 *  屏幕水平方向的比例
 *
 *  @return 屏幕宽:iphone6宽
 */
DH_INLINE CGFloat YQHorizentalMutiplier()
{
    return SCREEN_SIZE.width/ORIGIN_WIDTH;
}

DH_INLINE CGPoint YQFlexibleCenter (CGPoint iphone6Center)
{
    CGFloat x = iphone6Center.x * YQHorizentalMutiplier();
    CGFloat y = iphone6Center.y * YQVerticalMutiplier();
    return CGPointMake(x, y);
}

DH_INLINE CGSize YQFlexibleSize(CGSize iphone6Size)
{
    CGFloat width = iphone6Size.width * YQHorizentalMutiplier();
    CGFloat height = iphone6Size.height *YQVerticalMutiplier();
    return CGSizeMake(width, height);
    
}

DH_INLINE  CGRect YQFrameWithCenterAndSize(CGPoint iphone6Center, CGSize iphone6Size)
{
    CGRect frame;
    frame.origin.x = iphone6Center.x - iphone6Size.width/2;
    frame.origin.y = iphone6Center.y - iphone6Size.height/2;
    frame.size = iphone6Size;
    return frame;
}

DH_INLINE CGPoint YQCenterFromFrame(CGRect frame)
{
    CGPoint center;
    center.x = frame.origin.x + frame.size.width/2;
    center.y = frame.origin.y + frame.size.height/2;
    return center;
}

DH_INLINE CGRect YQFlexibleFrame(CGRect iphone6Frame)
{
    // 拿到iphone6 frame的center
    CGPoint center = YQCenterFromFrame(iphone6Frame);
    // 对center进行等比例缩放
    CGPoint flexibleCenter = YQFlexibleCenter(center);
    // 对size进行等比例缩放
    CGSize flexibleSize = YQFlexibleSize(iphone6Frame.size);
    // 通过center和size合成frame
    return YQFrameWithCenterAndSize(flexibleCenter, flexibleSize);
}

#endif /* YQAdjustScreen_h */
