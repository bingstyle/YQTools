//
//  UIButton+Badge_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//
//  https://github.com/mikeMTOL/UIBarButtonItem-Badge

#import <UIKit/UIKit.h>

@interface UIButton (Badge_yq)

@property (strong, nonatomic) UILabel *yq_badge;

// Badge value to be display
@property (nonatomic) NSString *yq_badgeValue;
// Badge background color
@property (nonatomic) UIColor *yq_badgeBGColor;
// Badge text color
@property (nonatomic) UIColor *yq_badgeTextColor;
// Badge font
@property (nonatomic) UIFont *yq_badgeFont;
// Padding value for the badge
@property (nonatomic) CGFloat yq_badgePadding;
// Minimum size badge to small
@property (nonatomic) CGFloat yq_badgeMinSize;
// Values for offseting the badge over the BarButtonItem you picked
@property (nonatomic) CGFloat yq_badgeOriginX;
@property (nonatomic) CGFloat yq_badgeOriginY;
// In case of numbers, remove the badge when reaching zero
@property BOOL yq_shouldHideBadgeAtZero;
// Badge has a bounce animation when value changes
@property BOOL yq_shouldAnimateBadge;

@end
