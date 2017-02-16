//
//  UIScrollView+Addition_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "UIScrollView+Addition_yq.h"

@implementation UIScrollView (Addition_yq)
//frame
- (CGFloat)yq_contentWidth {
    return self.contentSize.width;
}
- (void)setYq_contentWidth:(CGFloat)width {
    self.contentSize = CGSizeMake(width, self.frame.size.height);
}
- (CGFloat)yq_contentHeight {
    return self.contentSize.height;
}
- (void)setYq_contentHeight:(CGFloat)height {
    self.contentSize = CGSizeMake(self.frame.size.width, height);
}
- (CGFloat)yq_contentOffsetX {
    return self.contentOffset.x;
}
- (void)setYq_contentOffsetX:(CGFloat)x {
    self.contentOffset = CGPointMake(x, self.contentOffset.y);
}
- (CGFloat)yq_contentOffsetY {
    return self.contentOffset.y;
}
- (void)setYq_contentOffsetY:(CGFloat)y {
    self.contentOffset = CGPointMake(self.contentOffset.x, y);
}
//


- (CGPoint)yq_topContentOffset
{
    return CGPointMake(0.0f, -self.contentInset.top);
}
- (CGPoint)yq_bottomContentOffset
{
    return CGPointMake(0.0f, self.contentSize.height + self.contentInset.bottom - self.bounds.size.height);
}
- (CGPoint)yq_leftContentOffset
{
    return CGPointMake(-self.contentInset.left, 0.0f);
}
- (CGPoint)yq_rightContentOffset
{
    return CGPointMake(self.contentSize.width + self.contentInset.right - self.bounds.size.width, 0.0f);
}
- (JKScrollDirection)yq_ScrollDirection
{
    JKScrollDirection direction;
    
    if ([self.panGestureRecognizer translationInView:self.superview].y > 0.0f)
    {
        direction = JKScrollDirectionUp;
    }
    else if ([self.panGestureRecognizer translationInView:self.superview].y < 0.0f)
    {
        direction = JKScrollDirectionDown;
    }
    else if ([self.panGestureRecognizer translationInView:self].x < 0.0f)
    {
        direction = JKScrollDirectionLeft;
    }
    else if ([self.panGestureRecognizer translationInView:self].x > 0.0f)
    {
        direction = JKScrollDirectionRight;
    }
    else
    {
        direction = JKScrollDirectionWTF;
    }
    
    return direction;
}
- (BOOL)yq_isScrolledToTop
{
    return self.contentOffset.y <= [self yq_topContentOffset].y;
}
- (BOOL)yq_isScrolledToBottom
{
    return self.contentOffset.y >= [self yq_bottomContentOffset].y;
}
- (BOOL)yq_isScrolledToLeft
{
    return self.contentOffset.x <= [self yq_leftContentOffset].x;
}
- (BOOL)yq_isScrolledToRight
{
    return self.contentOffset.x >= [self yq_rightContentOffset].x;
}
- (void)yq_scrollToTopAnimated:(BOOL)animated
{
    [self setContentOffset:[self yq_topContentOffset] animated:animated];
}
- (void)yq_scrollToBottomAnimated:(BOOL)animated
{
    [self setContentOffset:[self yq_bottomContentOffset] animated:animated];
}
- (void)yq_scrollToLeftAnimated:(BOOL)animated
{
    [self setContentOffset:[self yq_leftContentOffset] animated:animated];
}
- (void)yq_scrollToRightAnimated:(BOOL)animated
{
    [self setContentOffset:[self yq_rightContentOffset] animated:animated];
}
- (NSUInteger)yq_verticalPageIndex
{
    return (self.contentOffset.y + (self.frame.size.height * 0.5f)) / self.frame.size.height;
}
- (NSUInteger)yq_horizontalPageIndex
{
    return (self.contentOffset.x + (self.frame.size.width * 0.5f)) / self.frame.size.width;
}
- (void)yq_scrollToVerticalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated
{
    [self setContentOffset:CGPointMake(0.0f, self.frame.size.height * pageIndex) animated:animated];
}
- (void)yq_scrollToHorizontalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated
{
    [self setContentOffset:CGPointMake(self.frame.size.width * pageIndex, 0.0f) animated:animated];
}

@end
