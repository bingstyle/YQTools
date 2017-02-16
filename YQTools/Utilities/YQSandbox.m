//
//  YQSandbox.m
//  Tools
//
//  Created by weixb on 16/12/19.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import "YQSandbox.h"

@implementation YQSandbox
//当我们创建应用程序时，在每个沙盒中含有三个文件，分别是Document、Library和temp
//获取程序的根目录（home目录）
+ (NSString *)homePath {
    return NSHomeDirectory();
}

//获取Document目录
+ (NSString *)documentPath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray lastObject];
    return path;
}

//获取Library目录
+ (NSString *)libraryPath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray lastObject];
    return path;
}

//获取Library中的Cache
+ (NSString *)cachePath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray lastObject];
    return path;
}

//获取temp目录
+ (NSString *)tempPath {
    return NSTemporaryDirectory();
}

// 获取沙盒文件路径
+ (NSString *)sandboxFilePathWithFileName:(NSString *)fileName pathType:(SandboxType)type {
    NSString *path = nil;
    switch (type) {
        case DocumentType: path = [self documentPath]; break;
        case LibraryType: path = [self libraryPath]; break;
        case CacheType: path = [self cachePath]; break;
        default: path = [self tempPath]; break;
    }
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    return filePath;
}

// 从文件中初始化plist数组
+ (NSMutableArray *)dataArrayWithPlistName:(NSString *)plistName pathType:(SandboxType)type {
    NSMutableArray * dataArray;
    // 取沙盒中的文件路径
    NSString * sandboxPath = [self sandboxFilePathWithFileName:plistName pathType:type];
    // 创建文件管理器
    NSFileManager * fileManger = [NSFileManager defaultManager];
    // 判断文件是否存在
    if ([fileManger fileExistsAtPath:sandboxPath]) {
        dataArray = [[NSMutableArray alloc] initWithContentsOfFile:sandboxPath];
    }else{
        // 取boundle中的属性列表文件路径
        NSString *bundlePath= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
        dataArray = [[NSMutableArray alloc] initWithContentsOfFile:bundlePath];
    }
    return dataArray;
}

@end
