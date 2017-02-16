//
//  NSBundle+AppIcon_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "NSBundle+AppIcon_yq.h"

@implementation NSBundle (AppIcon_yq)

- (NSString*)yq_appIconPath {
    NSString* iconFilename = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIconFile"] ;
    NSString* iconBasename = [iconFilename stringByDeletingPathExtension] ;
    NSString* iconExtension = [iconFilename pathExtension] ;
    return [[NSBundle mainBundle] pathForResource:iconBasename
                                           ofType:iconExtension] ;
}

- (UIImage*)yq_appIcon {
    UIImage*appIcon = [[UIImage alloc] initWithContentsOfFile:[self yq_appIconPath]] ;
    return appIcon;
}

@end
