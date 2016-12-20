//
//  YQUploadAPI.h
//  Tools
//
//  Created by weixb on 16/12/20.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^YQUploadAPISuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void(^YQUploadAPIFailureBlock)(NSURLSessionDataTask *task, NSError *error);
typedef void (^YQUploadAPIProgress)(int64_t bytesWritten,
                                int64_t totalBytesWritten);

@interface YQUploadAPI : NSObject

/**
 *  上传图片(单张)
 *
 *  @param path      URL
 *  @param image     图片
 *  @param params    参数
 *  @param progress  上传进度
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (NSURLSessionTask *)uploadImageWithURL:(NSString *)URLString
                                   image:(UIImage *)image
                                  params:(NSDictionary *)params
                                progress:(YQUploadAPIProgress)progress
                                 success:(YQUploadAPISuccessBlock)success
                                 failure:(YQUploadAPIFailureBlock)failure;

/**
 *  上传图片(多张)
 *
 *  @param path      URL
 *  @param photos    图片数组
 *  @param params    参数
 *  @param progress  上传进度
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (NSURLSessionTask *)uploadImageWithURL:(NSString *)URLString
                                  photos:(NSArray *)photos
                                  params:(NSDictionary *)params
                                progress:(YQUploadAPIProgress)progress
                                 success:(YQUploadAPISuccessBlock)success
                                 failure:(YQUploadAPIFailureBlock)failure;

/**
 *  上传文件操作
 *
 *  @param URLString URL
 *  @param filePath  文件路径
 *  @param progress  上传进度
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (NSURLSessionTask *)uploadFileWithURL:(NSString *)URLString
                               filePath:(NSString *)filePath
                               progress:(YQUploadAPIProgress)progress
                                success:(YQUploadAPISuccessBlock)success
                                failure:(YQUploadAPIFailureBlock)failure;

@end
