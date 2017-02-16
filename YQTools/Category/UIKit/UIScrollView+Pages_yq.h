//
//  UIScrollView+Pages_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Pages_yq)

- (NSInteger)yq_pages;
- (NSInteger)yq_currentPage;
- (CGFloat)yq_scrollPercent;

- (CGFloat)yq_pagesY;
- (CGFloat)yq_pagesX;
- (CGFloat)yq_currentPageY;
- (CGFloat)yq_currentPageX;
- (void)yq_setPageY:(CGFloat)page;
- (void)yq_setPageX:(CGFloat)page;
- (void)yq_setPageY:(CGFloat)page animated:(BOOL)animated;
- (void)yq_setPageX:(CGFloat)page animated:(BOOL)animated;

@end
