//
//  NSFileManager+File_yq.h
//  YQToolsDemo
//
//  Created by WeiXinbing on 2020/7/20.
//  Copyright © 2020 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (File_yq)

#pragma mark - 沙盒目录相关
// 沙盒的主目录路径
+ (NSString *)yq_homePath;
// 沙盒中tmp的目录路径
+ (NSString *)yq_tmpPath;

// 沙盒中Documents的目录路径
+ (NSURL *)yq_documentsURL;
+ (NSString *)yq_documentsPath;
// 沙盒中Library的目录路径
+ (NSURL *)yq_libraryURL;
+ (NSString *)yq_libraryPath;
// 沙盒中Library/Caches的目录路径
+ (NSURL *)yq_cachesURL;
+ (NSString *)yq_cachesPath;


#pragma mark - 遍历文件夹
/**
 文件遍历
 
 @param path 目录的绝对路径
 @param deep 是否深遍历 (1. 浅遍历：返回当前目录下的所有文件和文件夹；
 2. 深遍历：返回当前目录下及子目录下的所有文件和文件夹)
 @return 遍历结果数组
 */
+ (NSArray *)yq_listFilesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep;
// 遍历沙盒主目录
+ (NSArray *)yq_listFilesInHomeDirectoryByDeep:(BOOL)deep;
// 遍历Documents目录
+ (NSArray *)yq_listFilesInDocumentDirectoryByDeep:(BOOL)deep;
// 遍历Library目录
+ (NSArray *)yq_listFilesInLibraryDirectoryByDeep:(BOOL)deep;
// 遍历Caches目录
+ (NSArray *)yq_listFilesInCachesDirectoryByDeep:(BOOL)deep;
// 遍历tmp目录
+ (NSArray *)yq_listFilesInTmpDirectoryByDeep:(BOOL)deep;


#pragma mark - 创建文件(夹)
// 创建文件夹
+ (BOOL)yq_createDirectoryAtPath:(NSString *)path;
// 创建文件夹(错误信息error)
+ (BOOL)yq_createDirectoryAtPath:(NSString *)path error:(NSError **)error;

// 创建文件
+ (BOOL)yq_createFileAtPath:(NSString *)path;
// 创建文件(错误信息error)
+ (BOOL)yq_createFileAtPath:(NSString *)path error:(NSError **)error;
// 创建文件，是否覆盖
+ (BOOL)yq_createFileAtPath:(NSString *)path overwrite:(BOOL)overwrite;
// 创建文件，是否覆盖(错误信息error)
+ (BOOL)yq_createFileAtPath:(NSString *)path overwrite:(BOOL)overwrite error:(NSError **)error;
// 创建文件，文件内容
+ (BOOL)yq_createFileAtPath:(NSString *)path content:(NSObject *)content;
// 创建文件，文件内容(错误信息error)
+ (BOOL)yq_createFileAtPath:(NSString *)path content:(NSObject *)content error:(NSError **)error;
// 创建文件，文件内容，是否覆盖
+ (BOOL)yq_createFileAtPath:(NSString *)path content:(NSObject *)content overwrite:(BOOL)overwrite;
// 创建文件，文件内容，是否覆盖(错误信息error)
+ (BOOL)yq_createFileAtPath:(NSString *)path content:(nullable NSObject *)content overwrite:(BOOL)overwrite error:(NSError **)error;

#pragma mark - 删除文件(夹)
// 删除文件
+ (BOOL)yq_removeItemAtPath:(NSString *)path;
// 删除文件(错误信息error)
+ (BOOL)yq_removeItemAtPath:(NSString *)path error:(NSError **)error;
// 清空Caches文件夹
+ (BOOL)yq_clearCachesDirectory;
// 清空tmp文件夹
+ (BOOL)yq_clearTmpDirectory;

#pragma mark - 复制文件(夹)
// 复制文件
+ (BOOL)yq_copyItemAtPath:(NSString *)path toPath:(NSString *)toPath;
// 复制文件(错误信息error)
+ (BOOL)yq_copyItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError **)error;
// 复制文件，是否覆盖
+ (BOOL)yq_copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite;
// 复制文件，是否覆盖(错误信息error)
+ (BOOL)yq_copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError **)error;

#pragma mark - 移动文件(夹)
// 移动文件
+ (BOOL)yq_moveItemAtPath:(NSString *)path toPath:(NSString *)toPath;
// 移动文件(错误信息error)
+ (BOOL)yq_moveItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError **)error;
// 移动文件，是否覆盖
+ (BOOL)yq_moveItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite;
// 移动文件，是否覆盖(错误信息error)
+ (BOOL)yq_moveItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError **)error;

#pragma mark - 判断文件(夹)
// 判断文件路径是否存在
+ (BOOL)yq_isExistsAtPath:(NSString *)path;
// 判断路径是否为空(判空条件是文件大小为0，或者是文件夹下没有子文件)
+ (BOOL)yq_isEmptyItemAtPath:(NSString *)path;
// 判断路径是否为空(错误信息error)
+ (BOOL)yq_isEmptyItemAtPath:(NSString *)path error:(NSError **)error;
// 判断目录是否是文件夹
+ (BOOL)yq_isDirectoryAtPath:(NSString *)path;
// 判断目录是否是文件夹(错误信息error)
+ (BOOL)yq_isDirectoryAtPath:(NSString *)path error:(NSError **)error;
// 判断目录是否是文件
+ (BOOL)yq_isFileAtPath:(NSString *)path;
// 判断目录是否是文件(错误信息error)
+ (BOOL)yq_isFileAtPath:(NSString *)path error:(NSError **)error;
// 判断目录是否可以执行
+ (BOOL)yq_isExecutableItemAtPath:(NSString *)path;
// 判断目录是否可读
+ (BOOL)yq_isReadableItemAtPath:(NSString *)path;
// 判断目录是否可写
+ (BOOL)yq_isWritableItemAtPath:(NSString *)path;

#pragma mark - 获取文件(夹)大小
// 获取目录大小
+ (unsigned long long)yq_sizeOfItemAtPath:(NSString *)path;
// 获取目录大小(错误信息error)
+ (unsigned long long)yq_sizeOfItemAtPath:(NSString *)path error:(NSError **)error;
// 获取文件大小
+ (unsigned long long)yq_sizeOfFileAtPath:(NSString *)path;
// 获取文件大小(错误信息error)
+ (unsigned long long)yq_sizeOfFileAtPath:(NSString *)path error:(NSError **)error;
// 获取文件夹大小
+ (unsigned long long)yq_sizeOfDirectoryAtPath:(NSString *)path;
// 获取文件夹大小(错误信息error)
+ (unsigned long long)yq_sizeOfDirectoryAtPath:(NSString *)path error:(NSError **)error;

#pragma mark - 获取格式化后的文件大小
// 获取目录大小，返回格式化后的数值
+ (NSString *)yq_sizeFormattedOfItemAtPath:(NSString *)path;
// 获取目录大小，返回格式化后的数值(错误信息error)
+ (NSString *)yq_sizeFormattedOfItemAtPath:(NSString *)path error:(NSError **)error;
// 获取文件大小，返回格式化后的数值
+ (NSString *)yq_sizeFormattedOfFileAtPath:(NSString *)path;
// 获取文件大小，返回格式化后的数值(错误信息error)
+ (NSString *)yq_sizeFormattedOfFileAtPath:(NSString *)path error:(NSError **)error;
// 获取文件夹大小，返回格式化后的数值
+ (NSString *)yq_sizeFormattedOfDirectoryAtPath:(NSString *)path;
// 获取文件夹大小，返回格式化后的数值(错误信息error)
+ (NSString *)yq_sizeFormattedOfDirectoryAtPath:(NSString *)path error:(NSError **)error;

#pragma mark - 写入文件内容
// 写入文件内容
+ (BOOL)yq_writeFileAtPath:(NSString *)path content:(NSObject *)content;
// 写入文件内容(错误信息error)
+ (BOOL)yq_writeFileAtPath:(NSString *)path content:(NSObject *)content error:(NSError **)error;


@end

NS_ASSUME_NONNULL_END
