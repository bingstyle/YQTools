//
//  UIView+Alert_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/12/19.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "UIView+Alert_yq.h"
#import "UIView+AutoLayout_yq.h"

@interface YQShowAlertView : UIView

@property (nonatomic, weak) UIView *alertView;
@property (nonatomic, weak) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, assign) BOOL backgoundTapDismissEnable;  // default NO
@property (nonatomic, assign) CGFloat alertViewOriginY;  // default center Y
@property (nonatomic, assign) CGFloat alertViewEdging;   // default 15

+(void)yq_showAlertViewWithView:(UIView *)alertView;

+ (void)yq_showAlertViewWithView:(UIView *)alertView backgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable;

+(void)yq_showAlertViewWithView:(UIView *)alertView originY:(CGFloat)originY;

+(void)yq_showAlertViewWithView:(UIView *)alertView originY:(CGFloat)originY backgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable;

+ (instancetype)alertViewWithView:(UIView *)alertView;

- (void)yq_show;

- (void)yq_hide;

@end

@implementation YQShowAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        _backgoundTapDismissEnable = NO;
        _alertViewEdging = 15;
        
        [self yq_addBackgroundView];
        
        [self yq_addSingleGesture];
    }
    return self;
}

- (instancetype)initWithAlertView:(UIView *)tipView
{
    if (self = [self initWithFrame:CGRectZero]) {
        
        [self addSubview:tipView];
        _alertView = tipView;
    }
    return self;
}

+ (instancetype)alertViewWithView:(UIView *)tipView
{
    return [[self alloc]initWithAlertView:tipView];
}

+ (void)yq_showAlertViewWithView:(UIView *)alertView
{
    [self yq_showAlertViewWithView:alertView backgoundTapDismissEnable:NO];
}

+ (void)yq_showAlertViewWithView:(UIView *)alertView backgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable
{
    YQShowAlertView *showTipView = [self alertViewWithView:alertView];
    showTipView.backgoundTapDismissEnable = backgoundTapDismissEnable;
    [showTipView yq_show];
}

+ (void)yq_showAlertViewWithView:(UIView *)alertView originY:(CGFloat)originY
{
    [self yq_showAlertViewWithView:alertView
                        originY:originY backgoundTapDismissEnable:NO];
}

+ (void)yq_showAlertViewWithView:(UIView *)alertView originY:(CGFloat)originY backgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable
{
    YQShowAlertView *showTipView = [self alertViewWithView:alertView];
    showTipView.alertViewOriginY = originY;
    showTipView.backgoundTapDismissEnable = backgoundTapDismissEnable;
    [showTipView yq_show];
}

- (void)yq_addBackgroundView
{
    if (_backgroundView == nil) {
        UIView *backgroundView = [[UIView alloc]initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _backgroundView = backgroundView;
    }
    [self insertSubview:_backgroundView atIndex:0];
    _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self yq_addConstraintToView:_backgroundView edgeInset:UIEdgeInsetsZero];
}

- (void)yq_setBackgroundView:(UIView *)backgroundView
{
    if (_backgroundView != backgroundView) {
        [_backgroundView removeFromSuperview];
        _backgroundView = backgroundView;
        [self yq_addBackgroundView];
        [self yq_addSingleGesture];
    }
}
- (void)yq_setBackgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable
{
    _backgoundTapDismissEnable = backgoundTapDismissEnable;
    _singleTap.enabled = backgoundTapDismissEnable;
}

- (void)yq_didMoveToSuperview
{
    if (self.superview) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self.superview yq_addConstraintToView:self edgeInset:UIEdgeInsetsZero];
        [self yq_layoutAlertView];
    }
}

- (void)yq_layoutAlertView
{
    _alertView.translatesAutoresizingMaskIntoConstraints = NO;
    // center X
    [self yq_addConstraintCenterXToView:_alertView centerYToView:nil];
    
    // width, height
    if (!CGSizeEqualToSize(_alertView.frame.size,CGSizeZero)) {
        [_alertView yq_addConstraintWidth:CGRectGetWidth(_alertView.frame) height:CGRectGetHeight(_alertView.frame)];
        
    }else {
        BOOL findAlertViewWidthConstraint = NO;
        for (NSLayoutConstraint *constraint in _alertView.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                findAlertViewWidthConstraint = YES;
                break;
            }
        }
        
        if (!findAlertViewWidthConstraint) {
            [_alertView yq_addConstraintWidth:CGRectGetWidth(self.superview.frame)-2*_alertViewEdging height:0];
        }
    }
    
    // topY
    NSLayoutConstraint *alertViewCenterYConstraint = [self yq_addConstraintCenterYToView:_alertView constant:0];
    
    if (_alertViewOriginY > 0) {
        [_alertView layoutIfNeeded];
        alertViewCenterYConstraint.constant = _alertViewOriginY - (CGRectGetHeight(self.superview.frame) - CGRectGetHeight(_alertView.frame))/2;
    }
}

#pragma mark - add Gesture
- (void)yq_addSingleGesture
{
    self.userInteractionEnabled = YES;
    //单指单击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.enabled = _backgoundTapDismissEnable;
    //增加事件者响应者，
    [_backgroundView addGestureRecognizer:singleTap];
    _singleTap = singleTap;
}

#pragma mark 手指点击事件
- (void)yq_singleTap:(UITapGestureRecognizer *)sender
{
    [self yq_hide];
}

- (void)yq_show
{
    if (self.superview == nil) {
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    }
    self.alpha = 0;
    _alertView.transform = CGAffineTransformScale(_alertView.transform,0.1,0.1);
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self->_alertView.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    } completion:nil];
    
}

- (void)yq_hide
{
    if (self.superview) {
        [UIView animateWithDuration:0.3 animations:^{
            self->_alertView.transform = CGAffineTransformScale(self->_alertView.transform,0.1,0.1);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)yq_dealloc
{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end



@implementation UIView (Alert_yq)

#pragma mark - show in window

- (void)yq_showInWindow
{
    [self yq_showInWindowWithBackgoundTapDismissEnable:NO];
}

- (void)yq_showInWindowWithBackgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable
{
    if (self.superview) {
        [self removeFromSuperview];
    }
    [YQShowAlertView yq_showAlertViewWithView:self backgoundTapDismissEnable:backgoundTapDismissEnable];
}

- (void)yq_showInWindowWithOriginY:(CGFloat)OriginY
{
    [self yq_showInWindowWithOriginY:OriginY backgoundTapDismissEnable:NO];
}

- (void)yq_showInWindowWithOriginY:(CGFloat)OriginY backgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable
{
    if (self.superview) {
        [self removeFromSuperview];
    }
    [YQShowAlertView yq_showAlertViewWithView:self originY:OriginY backgoundTapDismissEnable:backgoundTapDismissEnable];
}

- (void)yq_hideInWindow
{
    if ([self yq_isShowInWindow]) {
        [(YQShowAlertView *)self.superview yq_hide];
    }else {
        NSLog(@"self.superview is nil, or isn't YQShowAlertView");
    }
}


#pragma mark - hide

- (BOOL)yq_isShowInWindow
{
    if (self.superview && [self.superview isKindOfClass:[YQShowAlertView class]]) {
        return YES;
    }
    return NO;
}

- (void)yq_hideView
{
    if ([self yq_isShowInWindow]) {
        [self yq_hideInWindow];
    }else {
        NSLog(@"self.viewController is nil, or isn't TYAlertController,or self.superview is nil, or isn't YQShowAlertView");
    }
}

@end
