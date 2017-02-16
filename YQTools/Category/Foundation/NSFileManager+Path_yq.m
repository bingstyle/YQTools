//
//  NSFileManager+Path_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "NSFileManager+Path_yq.h"

@implementation NSFileManager (Path_yq)

+ (NSURL *)yq_URLForDirectory:(NSSearchPathDirectory)directory
{
    return [self.defaultManager URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
}

+ (NSString *)yq_pathForDirectory:(NSSearchPathDirectory)directory
{
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES)[0];
}

+ (NSURL *)yq_documentsURL
{
    return [self yq_URLForDirectory:NSDocumentDirectory];
}

+ (NSString *)yq_documentsPath
{
    return [self yq_pathForDirectory:NSDocumentDirectory];
}

+ (NSURL *)yq_libraryURL
{
    return [self yq_URLForDirectory:NSLibraryDirectory];
}

+ (NSString *)yq_libraryPath
{
    return [self yq_pathForDirectory:NSLibraryDirectory];
}

+ (NSURL *)yq_cachesURL
{
    return [self yq_URLForDirectory:NSCachesDirectory];
}

+ (NSString *)yq_cachesPath
{
    return [self yq_pathForDirectory:NSCachesDirectory];
}

+ (BOOL)yq_addSkipBackupAttributeToFile:(NSString *)path
{
    return [[NSURL.alloc initFileURLWithPath:path] setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
}

+ (double)yq_availableDiskSpace
{
    NSDictionary *attributes = [self.defaultManager attributesOfFileSystemForPath:self.yq_documentsPath error:nil];
    
    return [attributes[NSFileSystemFreeSize] unsignedLongLongValue] / (double)0x100000;
}

@end
