//
//  UIView+Toast_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "UIView+Toast_yq.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

/*
 *  CONFIGURE THESE VALUES TO ADJUST LOOK & FEEL,
 *  DISPLAY DURATION, ETC.
 */

// general appearance
static const CGFloat YQToastMaxWidth            = 0.8;      // 80% of parent view width
static const CGFloat YQToastMaxHeight           = 0.8;      // 80% of parent view height
static const CGFloat YQToastHorizontalPadding   = 10.0;
static const CGFloat YQToastVerticalPadding     = 10.0;
static const CGFloat YQToastCornerRadius        = 10.0;
static const CGFloat YQToastOpacity             = 0.8;
static const CGFloat YQToastFontSize            = 16.0;
static const CGFloat YQToastMaxTitleLines       = 0;
static const CGFloat YQToastMaxMessageLines     = 0;
static const NSTimeInterval YQToastFadeDuration = 0.2;

// shadow appearance
static const CGFloat YQToastShadowOpacity       = 0.8;
static const CGFloat YQToastShadowRadius        = 6.0;
static const CGSize  YQToastShadowOffset        = { 4.0, 4.0 };
static const BOOL    YQToastDisplayShadow       = YES;

// display duration
static const NSTimeInterval YQToastDefaultDuration  = 3.0;

// image view size
static const CGFloat YQToastImageViewWidth      = 80.0;
static const CGFloat YQToastImageViewHeight     = 80.0;

// activity
static const CGFloat YQToastActivityWidth       = 100.0;
static const CGFloat YQToastActivityHeight      = 100.0;
static const NSString * YQToastActivityDefaultPosition = @"center";

// interaction
static const BOOL YQToastHidesOnTap             = YES;     // excludes activity views

// associative reference keys
static const NSString * YQToastTimerKey         = @"YQToastTimerKey";
static const NSString * YQToastActivityViewKey  = @"YQToastActivityViewKey";
static const NSString * YQToastTapCallbackKey   = @"YQToastTapCallbackKey";

// positions
NSString * const YQToastPositionTop             = @"top";
NSString * const YQToastPositionCenter          = @"center";
NSString * const YQToastPositionBottom          = @"bottom";

@interface UIView (WXBToastPrivate)

- (void)yq_hideToast:(UIView *)toast;
- (void)yq_toastTimerDidFinish:(NSTimer *)timer;
- (void)yq_handleToastTapped:(UITapGestureRecognizer *)recognizer;
- (CGPoint)yq_centerPointForPosition:(id)position withToast:(UIView *)toast;
- (UIView *)yq_viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image;
- (CGSize)yq_sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end

@implementation UIView (Toast_yq)

#pragma mark - Toast Methods

- (void)yq_makeToast:(NSString *)message {
    [self yq_makeToast:message duration:YQToastDefaultDuration position:nil];
}

- (void)yq_makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position {
    UIView *toast = [self yq_viewForMessage:message title:nil image:nil];
    [self yq_showToast:toast duration:duration position:position];
}

- (void)yq_makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position title:(NSString *)title {
    UIView *toast = [self yq_viewForMessage:message title:title image:nil];
    [self yq_showToast:toast duration:duration position:position];
}

- (void)yq_makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position image:(UIImage *)image {
    UIView *toast = [self yq_viewForMessage:message title:nil image:image];
    [self yq_showToast:toast duration:duration position:position];
}

- (void)yq_makeToast:(NSString *)message duration:(NSTimeInterval)duration  position:(id)position title:(NSString *)title image:(UIImage *)image {
    UIView *toast = [self yq_viewForMessage:message title:title image:image];
    [self yq_showToast:toast duration:duration position:position];
}

- (void)yq_showToast:(UIView *)toast {
    [self yq_showToast:toast duration:YQToastDefaultDuration position:nil];
}


- (void)yq_showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)position {
    [self yq_showToast:toast duration:duration position:position tapCallback:nil];
    
}


- (void)yq_showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)position
          tapCallback:(void(^)(void))tapCallback
{
    toast.center = [self yq_centerPointForPosition:position withToast:toast];
    toast.alpha = 0.0;
    
    if (YQToastHidesOnTap) {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:toast action:@selector(yq_handleToastTapped:)];
        [toast addGestureRecognizer:recognizer];
        toast.userInteractionEnabled = YES;
        toast.exclusiveTouch = YES;
    }
    
    [self addSubview:toast];
    
    [UIView animateWithDuration:YQToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(yq_toastTimerDidFinish:) userInfo:toast repeats:NO];
                         // associate the timer with the toast view
                         objc_setAssociatedObject (toast, &YQToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         objc_setAssociatedObject (toast, &YQToastTapCallbackKey, tapCallback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
}


- (void)yq_hideToast:(UIView *)toast {
    [UIView animateWithDuration:YQToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         toast.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [toast removeFromSuperview];
                     }];
}

#pragma mark - Events

- (void)yq_toastTimerDidFinish:(NSTimer *)timer {
    [self yq_hideToast:(UIView *)timer.userInfo];
}

- (void)yq_handleToastTapped:(UITapGestureRecognizer *)recognizer {
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(self, &YQToastTimerKey);
    [timer invalidate];
    
    void (^callback)(void) = objc_getAssociatedObject(self, &YQToastTapCallbackKey);
    if (callback) {
        callback();
    }
    [self yq_hideToast:recognizer.view];
}

#pragma mark - Toast Activity Methods

- (void)yq_makeToastActivity {
    [self yq_makeToastActivity:YQToastActivityDefaultPosition];
}

- (void)yq_makeToastActivity:(id)position {
    // sanity
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &YQToastActivityViewKey);
    if (existingActivityView != nil) return;
    
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YQToastActivityWidth, YQToastActivityHeight)];
    activityView.center = [self yq_centerPointForPosition:position withToast:activityView];
    activityView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:YQToastOpacity];
    activityView.alpha = 0.0;
    activityView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    activityView.layer.cornerRadius = YQToastCornerRadius;
    
    if (YQToastDisplayShadow) {
        activityView.layer.shadowColor = [UIColor blackColor].CGColor;
        activityView.layer.shadowOpacity = YQToastShadowOpacity;
        activityView.layer.shadowRadius = YQToastShadowRadius;
        activityView.layer.shadowOffset = YQToastShadowOffset;
    }
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2);
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    // associate the activity view with self
    objc_setAssociatedObject (self, &YQToastActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:activityView];
    
    [UIView animateWithDuration:YQToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         activityView.alpha = 1.0;
                     } completion:nil];
}

- (void)yq_hideToastActivity {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &YQToastActivityViewKey);
    if (existingActivityView != nil) {
        [UIView animateWithDuration:YQToastFadeDuration
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             existingActivityView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [existingActivityView removeFromSuperview];
                             objc_setAssociatedObject (self, &YQToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }
}

#pragma mark - Helpers

- (CGPoint)yq_centerPointForPosition:(id)point withToast:(UIView *)toast {
    if([point isKindOfClass:[NSString class]]) {
        if([point caseInsensitiveCompare:YQToastPositionTop] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width/2, (toast.frame.size.height / 2) + YQToastVerticalPadding);
        } else if([point caseInsensitiveCompare:YQToastPositionCenter] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        }
    } else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
    // default to bottom
    return CGPointMake(self.bounds.size.width/2, (self.bounds.size.height - (toast.frame.size.height / 2)) - YQToastVerticalPadding);
}

- (CGSize)yq_sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [string sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
}

- (UIView *)yq_viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image {
    // sanity
    if((message == nil) && (title == nil) && (image == nil)) return nil;
    
    // dynamically build a toast view with any combination of message, title, & image.
    UILabel *messageLabel = nil;
    UILabel *titleLabel = nil;
    UIImageView *imageView = nil;
    
    // create the parent view
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = YQToastCornerRadius;
    
    if (YQToastDisplayShadow) {
        wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
        wrapperView.layer.shadowOpacity = YQToastShadowOpacity;
        wrapperView.layer.shadowRadius = YQToastShadowRadius;
        wrapperView.layer.shadowOffset = YQToastShadowOffset;
    }
    
    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:YQToastOpacity];
    
    if(image != nil) {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(YQToastHorizontalPadding, YQToastVerticalPadding, YQToastImageViewWidth, YQToastImageViewHeight);
    }
    
    CGFloat imageWidth, imageHeight, imageLeft;
    
    // the imageView frame values will be used to size & position the other views
    if(imageView != nil) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = YQToastHorizontalPadding;
    } else {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    if (title != nil) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = YQToastMaxTitleLines;
        titleLabel.font = [UIFont boldSystemFontOfSize:YQToastFontSize];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 1.0;
        titleLabel.text = title;
        
        // size the title label according to the length of the text
        CGSize maxSizeTitle = CGSizeMake((self.bounds.size.width * YQToastMaxWidth) - imageWidth, self.bounds.size.height * YQToastMaxHeight);
        CGSize expectedSizeTitle = [self yq_sizeForString:title font:titleLabel.font constrainedToSize:maxSizeTitle lineBreakMode:titleLabel.lineBreakMode];
        titleLabel.frame = CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height);
    }
    
    if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = YQToastMaxMessageLines;
        messageLabel.font = [UIFont systemFontOfSize:YQToastFontSize];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        
        // size the message label according to the length of the text
        CGSize maxSizeMessage = CGSizeMake((self.bounds.size.width * YQToastMaxWidth) - imageWidth, self.bounds.size.height * YQToastMaxHeight);
        CGSize expectedSizeMessage = [self yq_sizeForString:message font:messageLabel.font constrainedToSize:maxSizeMessage lineBreakMode:messageLabel.lineBreakMode];
        messageLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);
    }
    
    // titleLabel frame values
    CGFloat titleWidth, titleHeight, titleTop, titleLeft;
    
    if(titleLabel != nil) {
        titleWidth = titleLabel.bounds.size.width;
        titleHeight = titleLabel.bounds.size.height;
        titleTop = YQToastVerticalPadding;
        titleLeft = imageLeft + imageWidth + YQToastHorizontalPadding;
    } else {
        titleWidth = titleHeight = titleTop = titleLeft = 0.0;
    }
    
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;
    
    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = imageLeft + imageWidth + YQToastHorizontalPadding;
        messageTop = titleTop + titleHeight + YQToastVerticalPadding;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }
    
    CGFloat longerWidth = MAX(titleWidth, messageWidth);
    CGFloat longerLeft = MAX(titleLeft, messageLeft);
    
    // wrapper width uses the longerWidth or the image width, whatever is larger. same logic applies to the wrapper height
    CGFloat wrapperWidth = MAX((imageWidth + (YQToastHorizontalPadding * 2)), (longerLeft + longerWidth + YQToastHorizontalPadding));
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + YQToastVerticalPadding), (imageHeight + (YQToastVerticalPadding * 2)));
    
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    if(titleLabel != nil) {
        titleLabel.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight);
        [wrapperView addSubview:titleLabel];
    }
    
    if(messageLabel != nil) {
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [wrapperView addSubview:messageLabel];
    }
    
    if(imageView != nil) {
        [wrapperView addSubview:imageView];
    }
    
    return wrapperView;
}

@end
