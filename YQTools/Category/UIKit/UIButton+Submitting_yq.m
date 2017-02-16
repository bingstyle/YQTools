//
//  UIButton+Submitting_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "UIButton+Submitting_yq.h"
#import <objc/runtime.h>

@interface UIButton ()

@property(nonatomic, strong) UIView *yq_modalView;
@property(nonatomic, strong) UIActivityIndicatorView *yq_spinnerView;
@property(nonatomic, strong) UILabel *yq_spinnerTitleLabel;

@end

@implementation UIButton (Submitting_yq)

- (void)yq_beginSubmitting:(NSString *)title {
    [self yq_endSubmitting];
    
    self.yq_submitting = @YES;
    self.hidden = YES;
    
    self.yq_modalView = [[UIView alloc] initWithFrame:self.frame];
    self.yq_modalView.backgroundColor =
    [self.backgroundColor colorWithAlphaComponent:0.6];
    self.yq_modalView.layer.cornerRadius = self.layer.cornerRadius;
    self.yq_modalView.layer.borderWidth = self.layer.borderWidth;
    self.yq_modalView.layer.borderColor = self.layer.borderColor;
    
    CGRect viewBounds = self.yq_modalView.bounds;
    self.yq_spinnerView = [[UIActivityIndicatorView alloc]
                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.yq_spinnerView.tintColor = self.titleLabel.textColor;
    
    CGRect spinnerViewBounds = self.yq_spinnerView.bounds;
    self.yq_spinnerView.frame = CGRectMake(
                                            15, viewBounds.size.height / 2 - spinnerViewBounds.size.height / 2,
                                            spinnerViewBounds.size.width, spinnerViewBounds.size.height);
    self.yq_spinnerTitleLabel = [[UILabel alloc] initWithFrame:viewBounds];
    self.yq_spinnerTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.yq_spinnerTitleLabel.text = title;
    self.yq_spinnerTitleLabel.font = self.titleLabel.font;
    self.yq_spinnerTitleLabel.textColor = self.titleLabel.textColor;
    [self.yq_modalView addSubview:self.yq_spinnerView];
    [self.yq_modalView addSubview:self.yq_spinnerTitleLabel];
    [self.superview addSubview:self.yq_modalView];
    [self.yq_spinnerView startAnimating];
}

- (void)yq_endSubmitting {
    if (!self.isyqSubmitting.boolValue) {
        return;
    }
    
    self.yq_submitting = @NO;
    self.hidden = NO;
    
    [self.yq_modalView removeFromSuperview];
    self.yq_modalView = nil;
    self.yq_spinnerView = nil;
    self.yq_spinnerTitleLabel = nil;
}

- (NSNumber *)isyqSubmitting {
    return objc_getAssociatedObject(self, @selector(setYq_submitting:));
}

- (void)setYq_submitting:(NSNumber *)submitting {
    objc_setAssociatedObject(self, @selector(setYq_submitting:), submitting, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (UIActivityIndicatorView *)yq_spinnerView {
    return objc_getAssociatedObject(self, @selector(setYq_spinnerView:));
}

- (void)setYq_spinnerView:(UIActivityIndicatorView *)spinnerView {
    objc_setAssociatedObject(self, @selector(setYq_spinnerView:), spinnerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)yq_modalView {
    return objc_getAssociatedObject(self, @selector(setYq_modalView:));
    
}

- (void)setYq_modalView:(UIView *)modalView {
    objc_setAssociatedObject(self, @selector(setYq_modalView:), modalView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)yq_spinnerTitleLabel {
    return objc_getAssociatedObject(self, @selector(setYq_spinnerTitleLabel:));
}

- (void)setYq_spinnerTitleLabel:(UILabel *)spinnerTitleLabel {
    objc_setAssociatedObject(self, @selector(setYq_spinnerTitleLabel:), spinnerTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
