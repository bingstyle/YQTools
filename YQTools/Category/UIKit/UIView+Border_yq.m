//
//  UIView+Border_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/7/24.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "UIView+Border_yq.h"

@implementation UIView (Border_yq)

@dynamic yq_borderType;
/** 设置边框类型 */
- (void)setYq_borderType:(WXBViewBorderType)yq_borderType {
    CGFloat bh = self.layer.borderWidth;
    if (yq_borderType & WXBViewBorderBottom) {
        [self addBottomBorder:self borderHeight:bh];
    }
    if (yq_borderType & WXBViewBorderLeft) {
        [self addLeftBorder:self borderHeight:bh];
    }
    if (yq_borderType & WXBViewBorderRight) {
        [self addRightBorder:self borderHeight:bh];
    }
    if (yq_borderType & WXBViewBorderTop) {
        [self addTopBorder:self borderHeight:bh];
    }
    if (yq_borderType & WXBViewBorderLeftAndBottom) {
        [self addBottomBorder:self borderHeight:bh];
        [self addLeftBorder:self borderHeight:bh];
    }
    if (yq_borderType & WXBViewBorderRightAndBottom) {
        [self addBottomBorder:self borderHeight:bh];
        [self addRightBorder:self borderHeight:bh];
    }
    self.layer.borderWidth = 0;
}

#pragma mark - private
/** 设置边框的frame */
- (void)addTopBorder:(UIView *)vi borderHeight:(CGFloat)bh {
    CGRect frame = CGRectMake(0, 0, vi.frame.size.width, bh);
    [self addBorderLayerWithFrame:frame];
}
- (void)addLeftBorder:(UIView *)vi borderHeight:(CGFloat)bh{
    CGRect frame = CGRectMake(0, 0, bh, vi.frame.size.height);
    [self addBorderLayerWithFrame:frame];
}
- (void)addBottomBorder:(UIView *)vi borderHeight:(CGFloat)bh{
    CGRect frame = CGRectMake(0, vi.frame.size.height-bh, vi.frame.size.width, bh);
    [self addBorderLayerWithFrame:frame];
}
- (void)addRightBorder:(UIView *)vi borderHeight:(CGFloat)bh{
    CGRect frame = CGRectMake(vi.frame.size.width-bh, 0, bh, vi.frame.size.height);
    [self addBorderLayerWithFrame:frame];
}

/** 添加边框到view上 */
- (void)addBorderLayerWithFrame:(CGRect)frame {
    CALayer *border = [CALayer layer];
    border.frame = frame;
    border.backgroundColor = self.layer.borderColor;
    [self.layer addSublayer:border];
}


@end
