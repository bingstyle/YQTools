//
//  YQSandbox.h
//  Tools
//
//  Created by weixb on 16/12/19.
//  Copyright © 2016年 weixb. All rights reserved.
//  APP沙盒文件

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SandboxType) {
    DocumentType = 0,
    LibraryType,
    CacheType,
    TempType,
};
@interface YQSandbox : NSObject

//获取程序的根目录（home目录）
+ (NSString *)homePath;

//获取Document目录
+ (NSString *)documentPath;

//获取Library目录
+ (NSString *)libraryPath;

//获取Library中的Cache
+ (NSString *)cachePath;

//获取temp目录
+ (NSString *)tempPath;

/**
 *  通过文件名获取沙盒文件路径
 *
 *  @param fileName 文件名
 *  @param type     路径目录类型
 *
 *  @return 文件路径
 */
+ (NSString *)sandboxFilePathWithFileName:(NSString *)fileName pathType:(SandboxType)type;

/**
 *  从文件中初始化plist数组(如果沙盒中没找到文件,会在bundle中查找)
 *
 *  @param plistName plist名字
 *  @param type      沙盒路径类型
 *
 *  @return 数组
 */
+ (NSMutableArray *)dataArrayWithPlistName:(NSString *)plistName pathType:(SandboxType)type;

@end
