//
//  UIScrollView+Addition_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, JKScrollDirection) {
    JKScrollDirectionUp,
    JKScrollDirectionDown,
    JKScrollDirectionLeft,
    JKScrollDirectionRight,
    JKScrollDirectionWTF
};

@interface UIScrollView (Addition_yq)

@property(nonatomic) CGFloat yq_contentWidth;
@property(nonatomic) CGFloat yq_contentHeight;
@property(nonatomic) CGFloat yq_contentOffsetX;
@property(nonatomic) CGFloat yq_contentOffsetY;

- (CGPoint)yq_topContentOffset;
- (CGPoint)yq_bottomContentOffset;
- (CGPoint)yq_leftContentOffset;
- (CGPoint)yq_rightContentOffset;

- (JKScrollDirection)yq_ScrollDirection;

- (BOOL)yq_isScrolledToTop;
- (BOOL)yq_isScrolledToBottom;
- (BOOL)yq_isScrolledToLeft;
- (BOOL)yq_isScrolledToRight;
- (void)yq_scrollToTopAnimated:(BOOL)animated;
- (void)yq_scrollToBottomAnimated:(BOOL)animated;
- (void)yq_scrollToLeftAnimated:(BOOL)animated;
- (void)yq_scrollToRightAnimated:(BOOL)animated;

- (NSUInteger)yq_verticalPageIndex;
- (NSUInteger)yq_horizontalPageIndex;

- (void)yq_scrollToVerticalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated;
- (void)yq_scrollToHorizontalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated;

@end
