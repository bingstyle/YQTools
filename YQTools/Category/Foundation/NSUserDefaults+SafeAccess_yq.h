//
//  NSUserDefaults+SafeAccess_yq.h
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (SafeAccess_yq)

+ (NSString *)yq_stringForKey:(NSString *)defaultName;

+ (NSArray *)yq_arrayForKey:(NSString *)defaultName;

+ (NSDictionary *)yq_dictionaryForKey:(NSString *)defaultName;

+ (NSData *)yq_dataForKey:(NSString *)defaultName;

+ (NSArray *)yq_stringArrayForKey:(NSString *)defaultName;

+ (NSInteger)yq_integerForKey:(NSString *)defaultName;

+ (float)yq_floatForKey:(NSString *)defaultName;

+ (double)yq_doubleForKey:(NSString *)defaultName;

+ (BOOL)yq_boolForKey:(NSString *)defaultName;

+ (NSURL *)yq_URLForKey:(NSString *)defaultName;

#pragma mark - WRITE FOR STANDARD

+ (void)yq_setObject:(id)value forKey:(NSString *)defaultName;

#pragma mark - READ ARCHIVE FOR STANDARD

+ (id)yq_arcObjectForKey:(NSString *)defaultName;

#pragma mark - WRITE ARCHIVE FOR STANDARD

+ (void)yq_setArcObject:(id)value forKey:(NSString *)defaultName;

@end
