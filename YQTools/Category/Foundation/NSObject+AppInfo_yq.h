//
//  NSObject+AppInfo_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AppInfo_yq)

- (NSString *)yq_version;
- (NSString *)yq_build;
- (NSString *)yq_identifier;
- (NSString *)yq_currentLanguage;
- (NSString *)yq_deviceModel;

@end
