//
//  UIView+Badge_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/7/24.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "UIView+Badge_yq.h"
@import ObjectiveC.runtime;

NSString const *yq_UIView_badgeKey = @"yq_UIView_badgeKey";

NSString const *yq_UIView_badgeBGColorKey = @"yq_UIView_badgeBGColorKey";
NSString const *yq_UIView_badgeTextColorKey = @"yq_UIView_badgeTextColorKey";
NSString const *yq_UIView_badgeFontKey = @"yq_UIView_badgeFontKey";
NSString const *yq_UIView_badgePaddingKey = @"yq_UIView_badgePaddingKey";
NSString const *yq_UIView_badgeMinSizeKey = @"yq_UIView_badgeMinSizeKey";
NSString const *yq_UIView_badgeOriginXKey = @"yq_UIView_badgeOriginXKey";
NSString const *yq_UIView_badgeOriginYKey = @"yq_UIView_badgeOriginYKey";
NSString const *yq_UIView_shouldHideBadgeAtZeroKey = @"yq_UIView_shouldHideBadgeAtZeroKey";
NSString const *yq_UIView_shouldAnimateBadgeKey = @"yq_UIView_shouldAnimateBadgeKey";
NSString const *yq_UIView_badgeValueKey = @"yq_UIView_badgeValueKey";

@implementation UIView (Badge_yq)

@dynamic yq_badgeValue, yq_badgeBGColor, yq_badgeTextColor, yq_badgeFont;
@dynamic yq_badgePadding, yq_badgeMinSize, yq_badgeOriginX, yq_badgeOriginY;
@dynamic yq_shouldHideBadgeAtZero, yq_shouldAnimateBadge;

- (void)yq_badgeInit
{
    // Default design initialization
    self.yq_badgeBGColor   = [UIColor redColor];
    self.yq_badgeTextColor = [UIColor whiteColor];
    self.yq_badgeFont      = [UIFont systemFontOfSize:12.0];
    self.yq_badgePadding   = 6;
    self.yq_badgeMinSize   = 8;
    self.yq_badgeOriginX   = self.frame.size.width - self.yq_badge.frame.size.width;
    self.yq_badgeOriginY   = -4;
    self.yq_shouldHideBadgeAtZero = YES;
    self.yq_shouldAnimateBadge = YES;
    // Avoids badge to be clipped when animating its scale
    self.clipsToBounds = NO;
}

#pragma mark - Utility methods

// Handle badge display when its properties have been changed (color, font, ...)
- (void)yq_refreshBadge
{
    // Change new attributes
    self.yq_badge.textColor        = self.yq_badgeTextColor;
    self.yq_badge.backgroundColor  = self.yq_badgeBGColor;
    self.yq_badge.font             = self.yq_badgeFont;
}

- (CGSize) yq_badgeExpectedSize
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
    self.yq_badge.frame = CGRectMake(self.yq_badgeOriginX, self.yq_badgeOriginY, minWidth + padding, minHeight + padding);
    self.yq_badge.layer.cornerRadius = (minHeight + padding) / 2;
    self.yq_badge.layer.masksToBounds = YES;
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
    NSTimeInterval duration = animated ? 0.2 : 0;
    [UIView animateWithDuration:duration animations:^{
        [self yq_updateBadgeFrame];
    }];
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
    return objc_getAssociatedObject(self, &yq_UIView_badgeKey);
}
-(void)setYq_badge:(UILabel *)badgeLabel
{
    objc_setAssociatedObject(self, &yq_UIView_badgeKey, badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// Badge value to be display
-(NSString *)yq_badgeValue {
    return objc_getAssociatedObject(self, &yq_UIView_badgeValueKey);
}
-(void) setYq_badgeValue:(NSString *)badgeValue
{
    objc_setAssociatedObject(self, &yq_UIView_badgeValueKey, badgeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // When changing the badge value check if we need to remove the badge
    if (!badgeValue || [badgeValue isEqualToString:@""] || ([badgeValue isEqualToString:@"0"] && self.yq_shouldHideBadgeAtZero)) {
        [self yq_removeBadge];
    } else if (!self.yq_badge) {
        // Create a new badge because not existing
        self.yq_badge                      = [[UILabel alloc] initWithFrame:CGRectMake(self.yq_badgeOriginX, self.yq_badgeOriginY, 20, 20)];
        self.yq_badge.textColor            = self.yq_badgeTextColor;
        self.yq_badge.backgroundColor      = self.yq_badgeBGColor;
        self.yq_badge.font                 = self.yq_badgeFont;
        self.yq_badge.textAlignment        = NSTextAlignmentCenter;
        [self yq_badgeInit];
        [self addSubview:self.yq_badge];
        [self yq_updateBadgeValueAnimated:NO];
    } else {
        [self yq_updateBadgeValueAnimated:YES];
    }
}

// Badge background color
-(UIColor *)yq_badgeBGColor {
    return objc_getAssociatedObject(self, &yq_UIView_badgeBGColorKey);
}
-(void)setYq_badgeBGColor:(UIColor *)badgeBGColor
{
    objc_setAssociatedObject(self, &yq_UIView_badgeBGColorKey, badgeBGColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.yq_badge) {
        [self yq_refreshBadge];
    }
}

// Badge text color
-(UIColor *)yq_badgeTextColor {
    return objc_getAssociatedObject(self, &yq_UIView_badgeTextColorKey);
}
-(void)setYq_badgeTextColor:(UIColor *)badgeTextColor
{
    objc_setAssociatedObject(self, &yq_UIView_badgeTextColorKey, badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.yq_badge) {
        [self yq_refreshBadge];
    }
}

// Badge font
-(UIFont *)yq_badgeFont {
    return objc_getAssociatedObject(self, &yq_UIView_badgeFontKey);
}
-(void)setYq_badgeFont:(UIFont *)badgeFont
{
    objc_setAssociatedObject(self, &yq_UIView_badgeFontKey, badgeFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.yq_badge) {
        [self yq_refreshBadge];
    }
}

// Padding value for the badge
-(CGFloat) yq_badgePadding {
    NSNumber *number = objc_getAssociatedObject(self, &yq_UIView_badgePaddingKey);
    return number.floatValue;
}
-(void) setYq_badgePadding:(CGFloat)badgePadding
{
    NSNumber *number = [NSNumber numberWithDouble:badgePadding];
    objc_setAssociatedObject(self, &yq_UIView_badgePaddingKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.yq_badge) {
        [self yq_updateBadgeFrame];
    }
}

// Minimum size badge to small
-(CGFloat) yq_badgeMinSize {
    NSNumber *number = objc_getAssociatedObject(self, &yq_UIView_badgeMinSizeKey);
    return number.floatValue;
}
-(void) setYq_badgeMinSize:(CGFloat)badgeMinSize
{
    NSNumber *number = [NSNumber numberWithDouble:badgeMinSize];
    objc_setAssociatedObject(self, &yq_UIView_badgeMinSizeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.yq_badge) {
        [self yq_updateBadgeFrame];
    }
}

// Values for offseting the badge over the BarButtonItem you picked
-(CGFloat) yq_badgeOriginX {
    NSNumber *number = objc_getAssociatedObject(self, &yq_UIView_badgeOriginXKey);
    return number.floatValue;
}
-(void) setYq_badgeOriginX:(CGFloat)badgeOriginX
{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginX];
    objc_setAssociatedObject(self, &yq_UIView_badgeOriginXKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.yq_badge) {
        [self yq_updateBadgeFrame];
    }
}

-(CGFloat) yq_badgeOriginY {
    NSNumber *number = objc_getAssociatedObject(self, &yq_UIView_badgeOriginYKey);
    return number.floatValue;
}
-(void) setYq_badgeOriginY:(CGFloat)badgeOriginY
{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginY];
    objc_setAssociatedObject(self, &yq_UIView_badgeOriginYKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.yq_badge) {
        [self yq_updateBadgeFrame];
    }
}

// In case of numbers, remove the badge when reaching zero
-(BOOL) yq_shouldHideBadgeAtZero {
    NSNumber *number = objc_getAssociatedObject(self, &yq_UIView_shouldHideBadgeAtZeroKey);
    return number.boolValue;
}
- (void)setYq_shouldHideBadgeAtZero:(BOOL)shouldHideBadgeAtZero
{
    NSNumber *number = [NSNumber numberWithBool:shouldHideBadgeAtZero];
    objc_setAssociatedObject(self, &yq_UIView_shouldHideBadgeAtZeroKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// Badge has a bounce animation when value changes
-(BOOL) yq_shouldAnimateBadge {
    NSNumber *number = objc_getAssociatedObject(self, &yq_UIView_shouldAnimateBadgeKey);
    return number.boolValue;
}
- (void)setYq_shouldAnimateBadge:(BOOL)shouldAnimateBadge
{
    NSNumber *number = [NSNumber numberWithBool:shouldAnimateBadge];
    objc_setAssociatedObject(self, &yq_UIView_shouldAnimateBadgeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
