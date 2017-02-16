//
//  NSUserDefaults+iCloudSync_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (iCloudSync_yq)

- (void)yq_setValue:(id)value  forKey:(NSString *)key iCloudSync:(BOOL)sync;
- (void)yq_setObject:(id)value forKey:(NSString *)key iCloudSync:(BOOL)sync;

- (id)yq_valueForKey:(NSString *)key  iCloudSync:(BOOL)sync;
- (id)yq_objectForKey:(NSString *)key iCloudSync:(BOOL)sync;

- (BOOL)yq_synchronizeAlsoiCloudSync:(BOOL)sync;

@end
