//
//  UIView+Border_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/7/24.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, WXBViewBorderType) {
    WXBViewBorderTop = 1<<1,
    WXBViewBorderLeft = 1<<2,
    WXBViewBorderBottom = 1<<3,
    WXBViewBorderRight = 1<<4,
    WXBViewBorderLeftAndBottom = 1<<5,
    WXBViewBorderRightAndBottom = 1<<6,
};

@interface UIView (Border_yq)

/** 边框类型(在view的frame确定后设置该属性) */
@property (nonatomic, assign) WXBViewBorderType yq_borderType;

@end
