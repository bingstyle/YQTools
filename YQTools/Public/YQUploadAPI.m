//
//  YQUploadAPI.m
//  Tools
//
//  Created by weixb on 16/12/20.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import "YQUploadAPI.h"
#import <AFNetworking.h>

@implementation YQUploadAPI

static AFHTTPSessionManager *manager;

+ (instancetype)manager {
    static id instance = nil;
    // 使用GCD
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 保证代码执行一次
        manager = [AFHTTPSessionManager manager];
    });
    return instance;
}
#pragma mark 上传单张图片
+ (NSURLSessionTask *)uploadImageWithURL:(NSString *)URLString
                                   image:(UIImage *)image
                                  params:(NSDictionary *)params
                                progress:(YQUploadAPIProgress)progress
                                 success:(YQUploadAPISuccessBlock)success
                                 failure:(YQUploadAPIFailureBlock)failure;
{
    NSArray *array = [NSArray arrayWithObject:image];
    return [self uploadImageWithURL:URLString photos:array params:params progress:progress success:success failure:failure];
}

#pragma mark 上传图片
+ (NSURLSessionTask *)uploadImageWithURL:(NSString *)URLString
                                  photos:(NSArray *)photos
                                  params:(NSDictionary *)params
                                progress:(YQUploadAPIProgress)progress
                                 success:(YQUploadAPISuccessBlock)success
                                 failure:(YQUploadAPIFailureBlock)failure;
{
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [self manager];
    return [manager POST:URLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < photos.count; i ++) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
            UIImage *image = photos[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.28);
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"upload%d",i+1] fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
        NSLog(@"uploadProgress is %lld,总字节 is %lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *resultCode = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"result_code"]];
        NSString *resultInfo = [responseObject objectForKey:@"result_info"];
        NSLog(@"resultInfo is %@",resultInfo);
        if ([resultCode isEqualToString:@"1"]) {
            if (success == nil) return ;
            success(task, responseObject);
        }else {
            if (failure == nil) return ;
            failure(task, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure == nil) return ;
        failure(task, error);
    }];
}
#pragma mark - 上传文件
+ (NSURLSessionTask *)uploadFileWithURL:(NSString *)URLString
                               filePath:(NSString *)filePath
                               progress:(YQUploadAPIProgress)progress
                                success:(YQUploadAPISuccessBlock)success
                                failure:(YQUploadAPIFailureBlock)failure
{
    
    AFHTTPSessionManager *manager = [self manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    return [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:filePath] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            if (success == nil) return ;
            success(nil, responseObject);
        } else {
            if (failure == nil) return ;
            failure(nil, error);
        }
    }];
}


@end
