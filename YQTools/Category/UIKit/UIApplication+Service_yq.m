//
//  UIApplication+Service_yq.m
//  YQToolsDemo
//
//  Created by WeiXinbing on 2019/1/22.
//  Copyright © 2019 weixb. All rights reserved.
//

#import "UIApplication+Service_yq.h"
@import WebKit;

@implementation UIApplication (Service_yq)

+ (void)yq_directPhoneCallWithPhoneNum:(NSString *)phoneNum {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:phoneNum]] options:@{} completionHandler:nil];
}

+ (void)yq_phoneCallWithPhoneNum:(NSString *)phoneNum contentView:(UIView *)view {
    
    WKWebView *webView = [WKWebView new];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:phoneNum]]]];
    [view addSubview:webView];
}

+ (void)yq_jumpToAppReviewPageWithAppId:(NSString *)appId {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=" stringByAppendingString:appId]] options:@{} completionHandler:nil];
}

+ (void)yq_sendEmailToAddress:(NSString *)address {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"mailto://" stringByAppendingString:address]] options:@{} completionHandler:nil];
}

@end
