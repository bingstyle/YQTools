//
//  UIBarButtonItem+Badge_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "UIBarButtonItem+Badge_yq.h"
#import <objc/runtime.h>

NSString const *yq_UIBarButtonItem_badgeKey = @"yq_UIBarButtonItem_badgeKey";

NSString const *yq_UIBarButtonItem_badgeBGColorKey = @"yq_UIBarButtonItem_badgeBGColorKey";
NSString const *yq_UIBarButtonItem_badgeTextColorKey = @"yq_UIBarButtonItem_badgeTextColorKey";
NSString const *yq_UIBarButtonItem_badgeFontKey = @"yq_UIBarButtonItem_badgeFontKey";
NSString const *yq_UIBarButtonItem_badgePaddingKey = @"yq_UIBarButtonItem_badgePaddingKey";
NSString const *yq_UIBarButtonItem_badgeMinSizeKey = @"yq_UIBarButtonItem_badgeMinSizeKey";
NSString const *yq_UIBarButtonItem_badgeOriginXKey = @"yq_UIBarButtonItem_badgeOriginXKey";
NSString const *yq_UIBarButtonItem_badgeOriginYKey = @"yq_UIBarButtonItem_badgeOriginYKey";
NSString const *yq_UIBarButtonItem_shouldHideBadgeAtZeroKey = @"yq_UIBarButtonItem_shouldHideBadgeAtZeroKey";
NSString const *yq_UIBarButtonItem_shouldAnimateBadgeKey = @"yq_UIBarButtonItem_shouldAnimateBadgeKey";
NSString const *yq_UIBarButtonItem_badgeValueKey = @"yq_UIBarButtonItem_badgeValueKey";

@implementation UIBarButtonItem (Badge_yq)

@dynamic yq_badgeValue, yq_badgeBGColor, yq_badgeTextColor, yq_badgeFont;
@dynamic yq_badgePadding, yq_badgeMinSize, yq_badgeOriginX, yq_badgeOriginY;
@dynamic yq_shouldHideBadgeAtZero, yq_shouldAnimateBadge;

- (void)yq_badgeInit
{
    UIView *superview = nil;
    CGFloat defaultOriginX = 0;
    if (self.customView) {
        superview = self.customView;
        defaultOriginX = superview.frame.size.width - self.yq_badge.frame.size.width/2;
        // Avoids badge to be clipped when animating its scale
        superview.clipsToBounds = NO;
    } else if ([self respondsToSelector:@selector(view)] && [(id)self view]) {
        superview = [(id)self view];
        defaultOriginX = superview.frame.size.width - self.yq_badge.frame.size.width;
    }
    [superview addSubview:self.yq_badge];
    
    // Default design initialization
    self.yq_badgeBGColor   = [UIColor redColor];
    self.yq_badgeTextColor = [UIColor whiteColor];
    self.yq_badgeFont      = [UIFont systemFontOfSize:12.0];
    self.yq_badgePadding   = 6;
    self.yq_badgeMinSize   = 8;
    self.yq_badgeOriginX   = defaultOriginX;
    self.yq_badgeOriginY   = -4;
    self.yq_shouldHideBadgeAtZero = YES;
    self.yq_shouldAnimateBadge = YES;
}

#pragma mark - Utility methods

// Handle badge display when its properties have been changed (color, font, ...)
- (void)yq_refreshBadge
{
    // Change new attributes
    self.yq_badge.textColor        = self.yq_badgeTextColor;
    self.yq_badge.backgroundColor  = self.yq_badgeBGColor;
    self.yq_badge.font             = self.yq_badgeFont;
    
    if (!self.yq_badgeValue || [self.yq_badgeValue isEqualToString:@""] || ([self.yq_badgeValue isEqualToString:@"0"] && self.yq_shouldHideBadgeAtZero)) {
        self.yq_badge.hidden = YES;
    } else {
        self.yq_badge.hidden = NO;
        [self yq_updateBadgeValueAnimated:YES];
    }
    
}

- (CGSize)yq_badgeExpectedSize
{
    // When the value changes the badge could need to get bigger
    // Calculate expected size to fit new value
    // Use an intermediate label to get expected size thanks to sizeToFit
    // We don't call sizeToFit on the true label to avoid bad display
    UILabel *frameLabel = [self yq_duplicateLabel:self.yq_badge];
    [frameLabel sizeToFit];
    
    CGSize expectedLabelSize = frameLabel.frame.size;
    return expectedLabelSize;
}

- (void)yq_updateBadgeFrame
{
    
    CGSize expectedLabelSize = [self yq_badgeExpectedSize];
    
    // Make sure that for small value, the badge will be big enough
    CGFloat minHeight = expectedLabelSize.height;
    
    // Using a const we make sure the badge respect the minimum size
    minHeight = (minHeight < self.yq_badgeMinSize) ? self.yq_badgeMinSize : expectedLabelSize.height;
    CGFloat minWidth = expectedLabelSize.width;
    CGFloat padding = self.yq_badgePadding;
    
    // Using const we make sure the badge doesn't get too smal
    minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize.width;
    self.yq_badge.layer.masksToBounds = YES;
    self.yq_badge.frame = CGRectMake(self.yq_badgeOriginX, self.yq_badgeOriginY, minWidth + padding, minHeight + padding);
    self.yq_badge.layer.cornerRadius = (minHeight + padding) / 2;
}

// Handle the badge changing value
- (void)yq_updateBadgeValueAnimated:(BOOL)animated
{
    // Bounce animation on badge if value changed and if animation authorized
    if (animated && self.yq_shouldAnimateBadge && ![self.yq_badge.text isEqualToString:self.yq_badgeValue]) {
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [animation setFromValue:[NSNumber numberWithFloat:1.5]];
        [animation setToValue:[NSNumber numberWithFloat:1]];
        [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.4f :1.3f :1.f :1.f]];
        [self.yq_badge.layer addAnimation:animation forKey:@"bounceAnimation"];
    }
    
    // Set the new value
    self.yq_badge.text = self.yq_badgeValue;
    
    // Animate the size modification if needed
    if (animated && self.yq_shouldAnimateBadge) {
        [UIView animateWithDuration:0.2 animations:^{
            [self yq_updateBadgeFrame];
        }];
    } else {
        [self yq_updateBadgeFrame];
    }
}

- (UILabel *)yq_duplicateLabel:(UILabel *)labelToCopy
{
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:labelToCopy.frame];
    duplicateLabel.text = labelToCopy.text;
    duplicateLabel.font = labelToCopy.font;
    
    return duplicateLabel;
}

- (void)yq_removeBadge
{
    // Animate badge removal
    [UIView animateWithDuration:0.2 animations:^{
        self.yq_badge.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self.yq_badge removeFromSuperview];
        self.yq_badge = nil;
    }];
}

#pragma mark - getters/setters
-(UILabel*)yq_badge {
    UILabel* lbl = objc_getAssociatedObject(self, &yq_UIBarButtonItem_badgeKey);
    if(lbl==nil) {
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.yq_badgeOriginX, self.yq_badgeOriginY, 20, 20)];
        [self setYq_badge:lbl];
        [self yq_badgeInit];
        [self.customView addSubview:lbl];
        lbl.textAlignment = NSTextAlignmentCenter;
    }
    return lbl;
}
-(void)setYq_badge:(UILabel *)badgeLabel
{
    objc_setAssociatedObject(self, &yq_UIBarButtonItem_badgeKey, badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// Badge value to be display
-(NSString *)yq_badgeValue {
    return objc_getAssociatedObject(self, &yq_UIBarButtonItem_badgeValueKey);
}
-(void)setYq_vadgeValue:(NSString *)badgeValue
{
    objc_setAssociatedObject(self, &yq_UIBarButtonItem_badgeValueKey, badgeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // When changing the badge value check if we need to remove the badge
    [self yq_updateBadgeValueAnimated:YES];
    [self yq_refreshBadge];
}

// Badge background color
-(UIColor *)badgeBGColor {
    return objc_getAssociatedObject(self, &yq_UIBarButtonItem_badgeBGColorKey);
}
-(void)setBadgeBGColor:(UIColor *)badgeBGColor
{
    objc_setAssociatedObject(self, &yq_UIBarButtonItem_badgeBGColorKey, badgeBGColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.yq_badge) {
        [self yq_refreshBadge];
    }
}

// Badge text color
-(UIColor *)badgeTextColor {
    return objc_getAssociatedObject(self, &yq_UIBarButtonItem_badgeTextColorKey);
}
-(void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    objc_setAssociatedObject(self, &yq_UIBarButtonItem_badgeTextColorKey, badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.yq_badge) {
        [self yq_refreshBadge];
    }
}

// Badge font
-(UIFont *)badgeFont {
    return objc_getAssociatedObject(self, &yq_UIBarButtonItem_badgeFontKey);
}
-(void)setBadgeFont:(UIFont *)badgeFont
{
    objc_setAssociatedObject(self, &yq_UIBarButtonItem_badgeFontKey, badgeFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.yq_badge) {
        [self yq_refreshBadge];
    }
}

// Padding value for the badge
-(CGFloat) badgePadding {
    NSNumber *number = objc_getAssociatedObject(self, &yq_UIBarButtonItem_badgePaddingKey);
    return number.floatValue;
}
-(void) setBadgePadding:(CGFloat)badgePadding
{
    NSNumber *number = [NSNumber numberWithDouble:badgePadding];
    objc_setAssociatedObject(self, &yq_UIBarButtonItem_badgePaddingKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.yq_badge) {
        [self yq_updateBadgeFrame];
    }
}

// Minimum size badge to small
-(CGFloat)yq_badgeMinSize {
    NSNumber *number = objc_getAssociatedObject(self, &yq_UIBarButtonItem_badgeMinSizeKey);
    return number.floatValue;
}
-(void) setYq_badgeMinSize:(CGFloat)badgeMinSize
{
    NSNumber *number = [NSNumber numberWithDouble:badgeMinSize];
    objc_setAssociatedObject(self, &yq_UIBarButtonItem_badgeMinSizeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.yq_badge) {
        [self yq_updateBadgeFrame];
    }
}

// Values for offseting the badge over the BarButtonItem you picked
-(CGFloat)yq_badgeOriginX {
    NSNumber *number = objc_getAssociatedObject(self, &yq_UIBarButtonItem_badgeOriginXKey);
    return number.floatValue;
}
-(void) setYq_badgeOriginX:(CGFloat)badgeOriginX
{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginX];
    objc_setAssociatedObject(self, &yq_UIBarButtonItem_badgeOriginXKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.yq_badge) {
        [self yq_updateBadgeFrame];
    }
}

-(CGFloat)yq_badgeOriginY {
    NSNumber *number = objc_getAssociatedObject(self, &yq_UIBarButtonItem_badgeOriginYKey);
    return number.floatValue;
}
-(void) setYq_badgeOriginY:(CGFloat)badgeOriginY
{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginY];
    objc_setAssociatedObject(self, &yq_UIBarButtonItem_badgeOriginYKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.yq_badge) {
        [self yq_updateBadgeFrame];
    }
}

// In case of numbers, remove the badge when reaching zero
-(BOOL) shouldHideBadgeAtZero {
    NSNumber *number = objc_getAssociatedObject(self, &yq_UIBarButtonItem_shouldHideBadgeAtZeroKey);
    return number.boolValue;
}
- (void)setShouldHideBadgeAtZero:(BOOL)shouldHideBadgeAtZero
{
    NSNumber *number = [NSNumber numberWithBool:shouldHideBadgeAtZero];
    objc_setAssociatedObject(self, &yq_UIBarButtonItem_shouldHideBadgeAtZeroKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(self.yq_badge) {
        [self yq_refreshBadge];
    }
}

// Badge has a bounce animation when value changes
-(BOOL) yq_shouldAnimateBadge {
    NSNumber *number = objc_getAssociatedObject(self, &yq_UIBarButtonItem_shouldAnimateBadgeKey);
    return number.boolValue;
}
- (void)setYq_shouldAnimateBadge:(BOOL)shouldAnimateBadge
{
    NSNumber *number = [NSNumber numberWithBool:shouldAnimateBadge];
    objc_setAssociatedObject(self, &yq_UIBarButtonItem_shouldAnimateBadgeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(self.yq_badge) {
        [self yq_refreshBadge];
    }
}

@end
