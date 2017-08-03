//
//  YQBaseArchiveModel.m
//  YQToolsDemo
//
//  Created by weixb on 2017/7/27.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "YQBaseArchiveModel.h"

@implementation YQBaseArchiveModel

static id instance; // 单例（全局变量）

/** 单例方法 */
+ (instancetype)sharedModel {
    // 使用GCD确保只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 先从归档的文件里面去拿,拿不到,再初始化一个空的对象
        instance = [[self class] unarchive];
        if (!instance) {
            instance = [[[self class] alloc]init];
        }
    });
    return instance;
}

/** alloc 会调用allocWithZone方法 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    // 使用GCD确保只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

/** copy在底层 会调用copyWithZone方法 */
- (id)copyWithZone:(struct _NSZone *)zone {
    
    return instance;
}

#pragma mark - 私有方法
/** 归档路径 */
+ (NSString *)archivePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = paths.firstObject;
    NSString *filePath = [basePath stringByAppendingPathComponent:[[self class] fileName]];
    return filePath;
}

/** 归档文件名 */
+ (NSString *)fileName {
    NSString *name = [NSString stringWithFormat:@"%@.model",NSStringFromClass([self class])];
    return name;
}

// 因为在解档的时候,还没有任何的model实例.所以写成类方法,并把解档的对象返回
// 在model创建的时候调用
+ (instancetype)unarchive {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[[self class] archivePath]];
}

#pragma mark - 接口方法
/** 归档 */
- (void)archive {
    [NSKeyedArchiver archiveRootObject:self toFile:[[self class] archivePath]];
}

/** 删除归档数据 */
- (void)deleteDate {
    // 创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 删除文件
    [fileManager removeItemAtPath:[[self class] archivePath] error:nil];
}


@end
