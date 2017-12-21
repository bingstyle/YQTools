//
//  UIView+Border_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/7/24.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, YQViewBorderType) {
    YQViewBorderTop = 1<<1,
    YQViewBorderLeft = 1<<2,
    YQViewBorderBottom = 1<<3,
    YQViewBorderRight = 1<<4,
    YQViewBorderLeftAndBottom = 1<<5,
    YQViewBorderRightAndBottom = 1<<6,
};

@interface UIView (Border_yq)

/** 边框类型(在view的frame确定后设置该属性) */
@property (nonatomic, assign) YQViewBorderType yq_borderType;

@end
