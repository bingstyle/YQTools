//
//  NSFileManager+File_yq.m
//  YQToolsDemo
//
//  Created by WeiXinbing on 2020/7/20.
//  Copyright © 2020 weixb. All rights reserved.
//

#import "NSFileManager+File_yq.h"
@import UIKit;

@implementation NSFileManager (File_yq)

#pragma mark - 沙盒目录相关
+ (NSString *)yq_homePath {
    return NSHomeDirectory();;
}
+ (NSString *)yq_tmpPath {
    return NSTemporaryDirectory();
}

+(NSURL *)yq_documentsURL {
    return [self yq_URLForDirectory:NSDocumentDirectory];
}
+ (NSString *)yq_documentsPath {
    return [self yq_pathForDirectory:NSDocumentDirectory];
}
+ (NSURL *)yq_libraryURL {
    return [self yq_URLForDirectory:NSLibraryDirectory];
}
+ (NSString *)yq_libraryPath {
    return [self yq_pathForDirectory:NSLibraryDirectory];
}
+ (NSURL *)yq_cachesURL {
    return [self yq_URLForDirectory:NSCachesDirectory];
}
+ (NSString *)yq_cachesPath {
    return [self yq_pathForDirectory:NSCachesDirectory];
}

#pragma mark - 遍历文件夹
+ (NSArray *)yq_listFilesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep {
    [self yq_checkPath:&path];
    NSArray *listArr;
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    if (deep) {
        // 深遍历
        NSArray *deepArr = [manager subpathsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = deepArr;
        }else {
            listArr = nil;
        }
    }else {
        // 浅遍历
        NSArray *shallowArr = [manager contentsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = shallowArr;
        }else {
            listArr = nil;
        }
    }
    return listArr;
}

+ (NSArray *)yq_listFilesInHomeDirectoryByDeep:(BOOL)deep {
    return [self yq_listFilesInDirectoryAtPath:[self yq_homePath] deep:deep];
}

+ (NSArray *)yq_listFilesInLibraryDirectoryByDeep:(BOOL)deep {
    return [self yq_listFilesInDirectoryAtPath:[self yq_libraryPath] deep:deep];
}

+ (NSArray *)yq_listFilesInDocumentDirectoryByDeep:(BOOL)deep {
    return [self yq_listFilesInDirectoryAtPath:[self yq_documentsPath] deep:deep];
}

+ (NSArray *)yq_listFilesInTmpDirectoryByDeep:(BOOL)deep {
    return [self yq_listFilesInDirectoryAtPath:[self yq_tmpPath] deep:deep];
}

+ (NSArray *)yq_listFilesInCachesDirectoryByDeep:(BOOL)deep {
    return [self yq_listFilesInDirectoryAtPath:[self yq_cachesPath] deep:deep];
}

#pragma mark - 创建文件(夹)

/// 创建文件夹
/// @param path 文件路径
+ (BOOL)yq_createDirectoryAtPath:(NSString *)path {
    return [self yq_createDirectoryAtPath:path error:nil];
}

+ (BOOL)yq_createDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    [self yq_checkPath:&path];
    /**
     * 参数1：创建的文件夹的路径
     * 参数2：是否创建中间目录的布尔值，一般为YES
     * 参数3: 属性，没有就置为nil
     * 参数4: 错误信息
     */
    BOOL isSuccess = [NSFileManager.defaultManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error];
    return isSuccess;
}


+ (BOOL)yq_createFileAtPath:(NSString *)path {
    return [self yq_createFileAtPath:path content:nil overwrite:YES error:nil];
}

+ (BOOL)yq_createFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [self yq_createFileAtPath:path content:nil overwrite:YES error:error];
}

+ (BOOL)yq_createFileAtPath:(NSString *)path overwrite:(BOOL)overwrite {
    return [self yq_createFileAtPath:path content:nil overwrite:overwrite error:nil];
}

+ (BOOL)yq_createFileAtPath:(NSString *)path overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
    return [self yq_createFileAtPath:path content:nil overwrite:overwrite error:error];
}

+ (BOOL)yq_createFileAtPath:(NSString *)path content:(NSObject *)content {
    return [self yq_createFileAtPath:path content:content overwrite:YES error:nil];
}

+ (BOOL)yq_createFileAtPath:(NSString *)path content:(NSObject *)content error:(NSError *__autoreleasing *)error {
    return [self yq_createFileAtPath:path content:content overwrite:YES error:error];
}

+ (BOOL)yq_createFileAtPath:(NSString *)path content:(NSObject *)content overwrite:(BOOL)overwrite {
    return [self yq_createFileAtPath:path content:content overwrite:overwrite error:nil];
}
/// 创建文件
/// @param path 文件路径
/// @param content 写入文件的内容
/// @param overwrite 是否覆盖
/// @param error 错误信息
+ (BOOL)yq_createFileAtPath:(NSString *)path content:(nullable NSObject *)content overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
    [self yq_checkPath:&path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 如果文件夹路径不存在，那么先创建文件夹
    NSString *directoryPath = path.stringByDeletingLastPathComponent;
    if (![fileManager fileExistsAtPath:directoryPath]) {
        [self yq_createDirectoryAtPath:directoryPath];
        
    }
    // 如果文件存在，并不想覆盖，那么直接返回YES。
    if (!overwrite) {
        if ([fileManager fileExistsAtPath:path]) {
            return YES;
        }
    }
    /**
     *参数1：文件创建的路径
     *参数2：创建文件的内容（NSData类型）
     *参数3：文件相关属性
     */
    BOOL isSuccess = [fileManager createFileAtPath:path contents:nil attributes:nil];
    if (content) {
        [self yq_writeFileAtPath:path content:content error:error];
    }
    return isSuccess;
}

#pragma mark - 删除文件(夹)
+ (BOOL)yq_removeItemAtPath:(NSString *)path {
    return [self yq_removeItemAtPath:path error:nil];
}

+ (BOOL)yq_removeItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    [self yq_checkPath:&path];
    return [[NSFileManager defaultManager] removeItemAtPath:path error:error];
}

+ (BOOL)yq_clearCachesDirectory {
    NSArray *subFiles = [self yq_listFilesInCachesDirectoryByDeep:NO];
    BOOL isSuccess = YES;
    
    for (NSString *file in subFiles) {
        NSString *absolutePath = [[self yq_cachesPath] stringByAppendingPathComponent:file];
        isSuccess &= [self yq_removeItemAtPath:absolutePath];
    }
    return isSuccess;
}

+ (BOOL)yq_clearTmpDirectory {
    NSArray *subFiles = [self yq_listFilesInTmpDirectoryByDeep:NO];
    BOOL isSuccess = YES;
    
    for (NSString *file in subFiles) {
        NSString *absolutePath = [[self yq_tmpPath] stringByAppendingPathComponent:file];
        isSuccess &= [self yq_removeItemAtPath:absolutePath];
    }
    return isSuccess;
}

#pragma mark - 复制文件(夹)
+ (BOOL)yq_copyItemAtPath:(NSString *)path toPath:(NSString *)toPath {
    return [self yq_copyItemAtPath:path toPath:toPath overwrite:NO error:nil];
}

+ (BOOL)yq_copyItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError *__autoreleasing *)error {
    return [self yq_copyItemAtPath:path toPath:toPath overwrite:NO error:error];
}

+ (BOOL)yq_copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite {
    return [self yq_copyItemAtPath:path toPath:toPath overwrite:overwrite error:nil];
}
/*参数1、被复制文件路径
 *参数2、要复制到的目标文件路径
 *参数3、当要复制到的文件路径文件存在，会复制失败，这里传入是否覆盖
 *参数4、错误信息
 */
+ (BOOL)yq_copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
    [self yq_checkPath:&path];
    [self yq_checkPath:&toPath];
    // 先要保证源文件路径存在，不然抛出异常
    if (![NSFileManager.defaultManager fileExistsAtPath:path]) {
        [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在，请检查源文件路径", path];
        return NO;
    }
    //获得目标文件的上级目录
    NSString *toDirPath = toPath.stringByDeletingLastPathComponent;
    if (![NSFileManager.defaultManager fileExistsAtPath:toDirPath]) {
        // 创建复制路径
        if (![self yq_createDirectoryAtPath:toDirPath error:error]) {
            return NO;
        }
    }
    // 如果覆盖，那么先删掉原文件
    if (overwrite) {
        if ([NSFileManager.defaultManager fileExistsAtPath:toPath]) {
            [self yq_removeItemAtPath:toPath error:error];
        }
    }
    // 复制文件，如果不覆盖且文件已存在则会复制失败
    BOOL isSuccess = [[NSFileManager defaultManager] copyItemAtPath:path toPath:toPath error:error];
    return isSuccess;
}

#pragma mark - 移动文件(夹)
+ (BOOL)yq_moveItemAtPath:(NSString *)path toPath:(NSString *)toPath {
    return [self yq_moveItemAtPath:path toPath:toPath overwrite:NO error:nil];
}

+ (BOOL)yq_moveItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError *__autoreleasing *)error {
    return [self yq_moveItemAtPath:path toPath:toPath overwrite:NO error:error];
}

+ (BOOL)yq_moveItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite {
    return [self yq_moveItemAtPath:path toPath:toPath overwrite:overwrite error:nil];
}
#pragma mark - 移动文件(夹)
/*参数1、被移动文件路径
 *参数2、要移动到的目标文件路径
 *参数3、当要移动到的文件路径文件存在，会移动失败，这里传入是否覆盖
 *参数4、错误信息
 */
+ (BOOL)yq_moveItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
    [self yq_checkPath:&path];
    [self yq_checkPath:&toPath];
    // 先要保证源文件路径存在，不然抛出异常
    if (![NSFileManager.defaultManager fileExistsAtPath:path]) {
        [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在，请检查源文件路径", path];
        return NO;
    }
    //获得目标文件的上级目录
    NSString *toDirPath = toPath.stringByDeletingLastPathComponent;
    if (![NSFileManager.defaultManager fileExistsAtPath:toDirPath]) {
        // 创建移动路径
        if (![self yq_createDirectoryAtPath:toDirPath error:error]) {
            return NO;
        }
    }
    // 判断目标路径文件是否存在
    if ([NSFileManager.defaultManager fileExistsAtPath:toPath]) {
        //如果覆盖，删除目标路径文件
        if (overwrite) {
            //删掉目标路径文件
            [self yq_removeItemAtPath:toPath error:error];
        }else {
            //删掉被移动文件
            [self yq_removeItemAtPath:path error:error];
            return YES;
        }
    }
    
    // 移动文件，当要移动到的文件路径文件存在，会移动失败
    BOOL isSuccess = [[NSFileManager defaultManager] moveItemAtPath:path toPath:toPath error:error];
    return isSuccess;
}

#pragma mark - 判断文件(夹)
+ (BOOL)yq_isExistsAtPath:(NSString *)path {
    [self yq_checkPath:&path];
    return [NSFileManager.defaultManager fileExistsAtPath:path];
}
+ (BOOL)yq_isEmptyItemAtPath:(NSString *)path {
    return [self yq_isEmptyItemAtPath:path error:nil];
}
+ (BOOL)yq_isEmptyItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    [self yq_checkPath:&path];
    return ([self yq_isFileAtPath:path error:error] &&
            [self yq_sizeOfItemAtPath:path error:error] == 0) ||
    ([self yq_isDirectoryAtPath:path error:error] &&
     [[self yq_listFilesInDirectoryAtPath:path deep:NO] count] == 0);
}

+ (BOOL)yq_isDirectoryAtPath:(NSString *)path {
    return [self yq_isDirectoryAtPath:path error:nil];
}
+ (BOOL)yq_isDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    [self yq_checkPath:&path];
    NSDictionary *dic = [NSFileManager.defaultManager attributesOfItemAtPath:path error:error];
    return ([dic objectForKey:NSFileType] == NSFileTypeDirectory);
}

+ (BOOL)yq_isFileAtPath:(NSString *)path {
    return [self yq_isFileAtPath:path error:nil];
}
+ (BOOL)yq_isFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    [self yq_checkPath:&path];
    NSDictionary *dic = [NSFileManager.defaultManager attributesOfItemAtPath:path error:error];
    return ([dic objectForKey:NSFileType] == NSFileTypeRegular);
}

+ (BOOL)yq_isExecutableItemAtPath:(NSString *)path {
    [self yq_checkPath:&path];
    return [[NSFileManager defaultManager] isExecutableFileAtPath:path];
}
+ (BOOL)yq_isReadableItemAtPath:(NSString *)path {
    [self yq_checkPath:&path];
    return [[NSFileManager defaultManager] isReadableFileAtPath:path];
}
+ (BOOL)yq_isWritableItemAtPath:(NSString *)path {
    [self yq_checkPath:&path];
    return [[NSFileManager defaultManager] isWritableFileAtPath:path];
}

#pragma mark - 获取文件(夹)大小
+ (unsigned long long)yq_sizeOfItemAtPath:(NSString *)path {
    return [self yq_sizeOfItemAtPath:path error:nil];
}

+ (unsigned long long)yq_sizeOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [NSFileManager.defaultManager attributesOfItemAtPath:path error:error].fileSize;
}

+ (unsigned long long)yq_sizeOfFileAtPath:(NSString *)path {
    return [self yq_sizeOfFileAtPath:path error:nil];
}

+ (unsigned long long)yq_sizeOfFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    if ([self yq_isFileAtPath:path error:error]) {
        return [self yq_sizeOfItemAtPath:path error:error];
    }
    return 0;
}

+ (unsigned long long)yq_sizeOfDirectoryAtPath:(NSString *)path {
    return [self yq_sizeOfDirectoryAtPath:path error:nil];
}
#pragma mark 获取文件夹的大小
+ (unsigned long long)yq_sizeOfDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    [self yq_checkPath:&path];
    if (![NSFileManager.defaultManager fileExistsAtPath:path]) {
        return 0;
    }
    if ([self yq_isDirectoryAtPath:path error:error]) {
        //深遍历文件夹
        NSArray *subPaths = [self yq_listFilesInDirectoryAtPath:path deep:YES];
        NSEnumerator *contentsEnumurator = [subPaths objectEnumerator];
        
        NSString *file;
        unsigned long long int folderSize = 0;
        
        while (file = [contentsEnumurator nextObject]) {
            NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[path stringByAppendingPathComponent:file] error:nil];
            folderSize += fileAttributes.fileSize;
        }
        return folderSize;
    }
    return [self yq_sizeOfItemAtPath:path error:error];
}

#pragma mark - 获取格式化后的文件大小

+ (NSString *)yq_sizeFormattedOfItemAtPath:(NSString *)path {
    return [self yq_sizeFormattedOfItemAtPath:path error:nil];
}

+ (NSString *)yq_sizeFormattedOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [NSByteCountFormatter stringFromByteCount: [self yq_sizeOfItemAtPath:path error:error] countStyle:NSByteCountFormatterCountStyleFile];
}

+ (NSString *)yq_sizeFormattedOfFileAtPath:(NSString *)path {
    return [self yq_sizeFormattedOfFileAtPath:path error:nil];
}

+ (NSString *)yq_sizeFormattedOfFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [NSByteCountFormatter stringFromByteCount: [self yq_sizeOfFileAtPath:path error:error] countStyle:NSByteCountFormatterCountStyleFile];
}

+ (NSString *)yq_sizeFormattedOfDirectoryAtPath:(NSString *)path {
    return [self yq_sizeFormattedOfDirectoryAtPath:path error:nil];
}

+ (NSString *)yq_sizeFormattedOfDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [NSByteCountFormatter stringFromByteCount: [self yq_sizeOfDirectoryAtPath:path error:error] countStyle:NSByteCountFormatterCountStyleFile];
}

#pragma mark - 写入文件内容
+ (BOOL)yq_writeFileAtPath:(NSString *)path content:(NSObject *)content {
    return [self yq_writeFileAtPath:path content:content error:nil];
}
#pragma mark 写入文件内容
/*参数1：文件路径
 *参数2：文件内容
 *参数3：错误信息
 */
+ (BOOL)yq_writeFileAtPath:(NSString *)path content:(NSObject *)content error:(NSError *__autoreleasing *)error {
    [self yq_checkPath:&path];
    //判断文件内容是否为空
    if (!content) {
        [NSException raise:@"非法的文件内容" format:@"文件内容不能为nil"];
        return NO;
    }
    //判断文件(夹)是否存在
    if ([NSFileManager.defaultManager fileExistsAtPath:path]) {
        if ([content isKindOfClass:[NSMutableArray class]]) {//文件内容为可变数组
            [(NSMutableArray *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSArray class]]) {//文件内容为不可变数组
            [(NSArray *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSMutableData class]]) {//文件内容为可变NSMutableData
            [(NSMutableData *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSData class]]) {//文件内容为NSData
            [(NSData *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSMutableDictionary class]]) {//文件内容为可变字典
            [(NSMutableDictionary *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSDictionary class]]) {//文件内容为不可变字典
            [(NSDictionary *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSJSONSerialization class]]) {//文件内容为JSON类型
            [(NSDictionary *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSMutableString class]]) {//文件内容为可变字符串
            [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSString class]]) {//文件内容为不可变字符串
            [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[UIImage class]]) {//文件内容为图片
            [UIImagePNGRepresentation((UIImage *)content) writeToFile:path atomically:YES];
        }else if ([content conformsToProtocol:@protocol(NSCoding)]) {//文件归档
            [NSKeyedArchiver archiveRootObject:content toFile:path];
        }else {
            [NSException raise:@"非法的文件内容" format:@"文件类型%@异常，无法被处理。", NSStringFromClass([content class])];
            
            return NO;
        }
    }else {
        return NO;
    }
    return YES;
}

#pragma mark - Private
+ (NSURL *)yq_URLForDirectory:(NSSearchPathDirectory)directory {
    return [self.defaultManager URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
}
+ (NSString *)yq_pathForDirectory:(NSSearchPathDirectory)directory {
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES)[0];
}
+ (void)yq_checkPath:(NSString **)path {
    // 如果是相对路径, 默认 doc 目录
    if (![*path containsString:NSHomeDirectory()]) {
        *path = [[self yq_documentsPath] stringByAppendingPathComponent:*path];
    }
}

@end
