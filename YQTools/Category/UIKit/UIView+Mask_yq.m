//
//  UIView+Mask_yq.m
//  YQToolsDemo
//
//  Created by WeiXinbing on 2019/6/12.
//  Copyright © 2019 weixb. All rights reserved.
//

#import "UIView+Mask_yq.h"

typedef struct {
    CGFloat topLeft;
    CGFloat topRight;
    CGFloat bottomLeft;
    CGFloat bottomRight;
} CornerRadii;

@implementation UIView (Mask_yq)

#pragma mark - Public

/**
 配置不同数量不同大小的圆角, 使用UIBezierPath进行切圆角
 
 @param topLeft 上左
 @param topRight 上右
 @param bottomLeft 下左
 @param bottomRight 下右
 */
- (void)rectCornerWithTopLeft:(CGFloat)topLeft topRight:(CGFloat)topRight bottomLeft:(CGFloat)bottomLeft bottomRight:(CGFloat)bottomRight {
    //切圆角
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CornerRadii corner = CornerRadiiMake(topLeft, topRight, bottomLeft, bottomRight);
    CGPathRef path = CYPathCreateWithRoundedRect(self.bounds, corner);
    shapeLayer.path = path;
    CGPathRelease(path);
    self.layer.mask = shapeLayer;
}

#pragma mark - Private
CornerRadii CornerRadiiMake(CGFloat topLeft,CGFloat topRight,CGFloat bottomLeft,CGFloat bottomRight) {
    return (CornerRadii){
        topLeft,
        topRight,
        bottomLeft,
        bottomRight,
    };
}
//切圆角函数
CGPathRef CYPathCreateWithRoundedRect(CGRect bounds,
                                      CornerRadii cornerRadii)
{
    const CGFloat minX = CGRectGetMinX(bounds);
    const CGFloat minY = CGRectGetMinY(bounds);
    const CGFloat maxX = CGRectGetMaxX(bounds);
    const CGFloat maxY = CGRectGetMaxY(bounds);
    
    const CGFloat topLeftCenterX = minX +  cornerRadii.topLeft;
    const CGFloat topLeftCenterY = minY + cornerRadii.topLeft;
    
    const CGFloat topRightCenterX = maxX - cornerRadii.topRight;
    const CGFloat topRightCenterY = minY + cornerRadii.topRight;
    
    const CGFloat bottomLeftCenterX = minX +  cornerRadii.bottomLeft;
    const CGFloat bottomLeftCenterY = maxY - cornerRadii.bottomLeft;
    
    const CGFloat bottomRightCenterX = maxX -  cornerRadii.bottomRight;
    const CGFloat bottomRightCenterY = maxY - cornerRadii.bottomRight;
    /*
     path : 路径
     m : 变换
     x  y : 画圆的圆心点
     radius : 圆的半径
     startAngle : 起始角度
     endAngle ： 结束角度
     clockwise : 是否是顺时针
     void CGPathAddArc(CGMutablePathRef cg_nullable path,
     const CGAffineTransform * __nullable m,
     CGFloat x, CGFloat y, CGFloat radius, CGFloat startAngle, CGFloat endAngle,
     bool clockwise)
     */
    //虽然顺时针参数是YES，在iOS中的UIView中，这里实际是逆时针
    
    CGMutablePathRef path = CGPathCreateMutable();
    //顶 左
    CGPathAddArc(path, NULL, topLeftCenterX, topLeftCenterY,cornerRadii.topLeft, M_PI, 3 * M_PI_2, NO);
    //顶 右
    CGPathAddArc(path, NULL, topRightCenterX , topRightCenterY, cornerRadii.topRight, 3 * M_PI_2, 0, NO);
    //底 右
    CGPathAddArc(path, NULL, bottomRightCenterX, bottomRightCenterY, cornerRadii.bottomRight,0, M_PI_2, NO);
    //底 左
    CGPathAddArc(path, NULL, bottomLeftCenterX, bottomLeftCenterY, cornerRadii.bottomLeft, M_PI_2,M_PI, NO);
    CGPathCloseSubpath(path);
    return path;
}


@end
