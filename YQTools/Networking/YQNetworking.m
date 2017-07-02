//
//  WXBNetworking.m
//  Gaia
//
//  Created by 魏心兵 on 16/3/31.
//  Copyright © 2016年 Weixb. All rights reserved.
//

#import "YQNetworking.h"

#import <CommonCrypto/CommonDigest.h>
@interface NSString (md5)

+ (NSString *)wxbnetworking_md5:(NSString *)string;

@end

@implementation NSString (md5)

+ (NSString *)wxbnetworking_md5:(NSString *)string {
    if (string == nil || [string length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([string UTF8String], (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}
@end
/*****************************以上为 字符串MD5加密分类****************************/


#if __has_include(<AFNetworking/AFNetworkActivityIndicatorManager.h>)
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#else
#import "AFNetworkActivityIndicatorManager.h"
#endif

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

// 项目打包上线都不会打印日志，因此可放心。
#ifdef DEBUG
#define WXBAppLog(format, ...) do { \
fprintf(stderr, "<%s : 第%d行> %s\n", \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
__LINE__, __func__);\
(NSLog)((format), ##__VA_ARGS__);\
} while (0)
#else
#define WXBAppLog(...)
#endif


#define CODE_TIMEOUT -1001
static NSString *sg_privateNetworkBaseUrl = nil;
static BOOL sg_isEnableInterfaceDebug = NO;
static BOOL sg_shouldAutoEncode = NO;
static NSDictionary *sg_httpHeaders = nil;
static WXBResponseType sg_responseType = kWXBResponseTypeJSON;
static WXBRequestType  sg_requestType  = kWXBRequestTypeJSON;
static NSMutableArray *sg_requestTasks;
static BOOL sg_cacheGet = YES;
static BOOL sg_cachePost = NO;
static BOOL sg_shouldCallbackOnCancelRequest = YES;
static NSInteger sg_numberOfTimesToRetry = 3;
static NSMutableDictionary *sg_timesOfRetryURLs;

@implementation YQNetworking

+ (void)cacheGetRequest:(BOOL)isCacheGet shoulCachePost:(BOOL)shouldCachePost {
    sg_cacheGet = isCacheGet;
    sg_cachePost = shouldCachePost;
}

+ (void)setNumberOfTimesToRetryOnTimeout:(NSInteger)number {
    sg_numberOfTimesToRetry = number;
}

+ (void)updateBaseUrl:(NSString *)baseUrl {
    sg_privateNetworkBaseUrl = baseUrl;
}

+ (NSString *)baseUrl {
    return sg_privateNetworkBaseUrl;
}

+ (void)enableInterfaceDebug:(BOOL)isDebug {
    sg_isEnableInterfaceDebug = isDebug;
}

+ (BOOL)isDebug {
    return sg_isEnableInterfaceDebug;
}

static inline NSString *cachePath() {
//    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/WXBNetworkingCaches"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths lastObject];
    return [docPath stringByAppendingPathComponent:@"WXBNetworkingCaches"];
}

+ (void)clearCaches {
    NSString *directoryPath = cachePath();
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
        
        if (error) {
            NSLog(@"WXBNetworking clear caches error: %@", error);
        } else {
            NSLog(@"WXBNetworking clear caches ok");
        }
    }
}

+ (unsigned long long)totalCacheSize {
    NSString *directoryPath = cachePath();
    BOOL isDir = NO;
    unsigned long long total = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
            
            if (error == nil) {
                for (NSString *subpath in array) {
                    NSString *path = [directoryPath stringByAppendingPathComponent:subpath];
                    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                                          error:&error];
                    if (!error) {
                        total += [dict[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
        }
    }
    
    return total;
}

+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sg_requestTasks == nil) {
            sg_requestTasks = [[NSMutableArray alloc] init];
        }
    });
    
    return sg_requestTasks;
}
+ (NSMutableDictionary *)allTimesOfRetryURLs {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sg_timesOfRetryURLs == nil) {
            sg_timesOfRetryURLs = [[NSMutableDictionary alloc] init];
        }
    });
    
    return sg_timesOfRetryURLs;
}
+ (void)cancelAllRequest {
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(WXBURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[WXBURLSessionTask class]]) {
                [task cancel];
            }
        }];
        
        [[self allTasks] removeAllObjects];
    };
}

+ (void)cancelRequestWithURL:(NSString *)url {
    if (url == nil) {
        return;
    }
    
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(WXBURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[WXBURLSessionTask class]]
                && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                return;
            }
        }];
    };
}

+ (void)configRequestType:(WXBRequestType)requestType
             responseType:(WXBResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest {
    sg_requestType = requestType;
    sg_responseType = responseType;
    sg_shouldAutoEncode = shouldAutoEncode;
    sg_shouldCallbackOnCancelRequest = shouldCallbackOnCancelRequest;
}

+ (BOOL)shouldEncode {
    return sg_shouldAutoEncode;
}

+ (void)shouldAutoEncodeUrl:(BOOL)shouldAutoEncode {
    sg_shouldAutoEncode = shouldAutoEncode;
}

+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders {
    sg_httpHeaders = httpHeaders;
}

+ (WXBURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                          success:(SuccessBlock)success
                             fail:(FailureBlock)fail {
    return [self getWithUrl:url
               refreshCache:refreshCache
                     params:nil
                    success:success
                       fail:fail];
}

+ (WXBURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                          success:(SuccessBlock)success
                             fail:(FailureBlock)fail {
    return [self getWithUrl:url
               refreshCache:refreshCache
                     params:params
                   progress:nil
                    success:success
                       fail:fail];
}

+ (WXBURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                         progress:(WXBGetProgress)progress
                          success:(SuccessBlock)success
                             fail:(FailureBlock)fail {
    return [self _requestWithUrl:url
                    refreshCache:refreshCache
                       httpMedth:1
                          params:params
                        progress:progress
                         success:success
                            fail:fail];
}

+ (WXBURLSessionTask *)postWithUrl:(NSString *)url
                      refreshCache:(BOOL)refreshCache
                            params:(NSDictionary *)params
                           success:(SuccessBlock)success
                              fail:(FailureBlock)fail {
    return [self postWithUrl:url
                refreshCache:refreshCache
                      params:params
                    progress:nil
                     success:success
                        fail:fail];
}

+ (WXBURLSessionTask *)postWithUrl:(NSString *)url
                      refreshCache:(BOOL)refreshCache
                            params:(NSDictionary *)params
                          progress:(WXBPostProgress)progress
                           success:(SuccessBlock)success
                              fail:(FailureBlock)fail {
    return [self _requestWithUrl:url
                    refreshCache:refreshCache
                       httpMedth:2
                          params:params
                        progress:progress
                         success:success
                            fail:fail];
}

+ (WXBURLSessionTask *)_requestWithUrl:(NSString *)url
                          refreshCache:(BOOL)refreshCache
                             httpMedth:(NSUInteger)httpMethod
                                params:(NSDictionary *)params
                              progress:(WXBDownloadProgress)progress
                               success:(SuccessBlock)success
                                  fail:(FailureBlock)fail {
    //设置请求超时重试次数
    if (![[self allTimesOfRetryURLs] objectForKey:url]) {
        [[self allTimesOfRetryURLs] setObject:@(sg_numberOfTimesToRetry) forKey:url];
    }
    AFHTTPSessionManager *manager = [self manager];
    NSString *absolute = [self absoluteUrlWithPath:url];
    
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            WXBAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    } else {
        NSURL *absouluteURL = [NSURL URLWithString:absolute];
        
        if (absouluteURL == nil) {
            WXBAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    }
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    WXBURLSessionTask *session = nil;
    
    if (httpMethod == 1) {
        if (sg_cacheGet && !refreshCache) {// 获取缓存
            id response = [[self class] cahceResponseWithURL:absolute
                                                   parameters:params];
            if (response) {
                if (success) {
                    [self successResponse:response callback:success];
                    
                    if ([self isDebug]) {
                        [self logWithSuccessResponse:response
                                                 url:absolute
                                              params:params];
                    }
                }
                
                return nil;
            }
        }
        
        session = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self successResponse:responseObject callback:success];
            
            if (sg_cacheGet) {
                [self cacheResponseObject:responseObject request:task.currentRequest parameters:params];
            }
            [[self allTimesOfRetryURLs] removeObjectForKey:url]; //移除关联的超时重试次数
            [[self allTasks] removeObject:task];
            
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject
                                         url:absolute
                                      params:params];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //判断超时重试条件,满足则发起重试请求
            NSInteger timesOfRetry = [[[self allTimesOfRetryURLs] objectForKey:url] integerValue];
            if (error.code == CODE_TIMEOUT && timesOfRetry > 0) {
                [task cancel];
                [self _requestWithUrl:url refreshCache:refreshCache httpMedth:httpMethod params:params progress:progress success:success fail:fail];
                WXBAppLog(@"%@超时重试%@",url,@(timesOfRetry));
                //设置请求超时重试次数
                timesOfRetry--;
                [[self allTimesOfRetryURLs] setObject:@(timesOfRetry) forKey:url];
                return ;
            }
            [[self allTimesOfRetryURLs] removeObjectForKey:url]; //移除关联的超时重试次数
            [[self allTasks] removeObject:task];
            
            [self handleCallbackWithError:error fail:fail];
            
            if ([self isDebug]) {
                [self logWithFailError:error url:absolute params:params];
            }
        }];
    } else if (httpMethod == 2) {
        if (sg_cachePost && !refreshCache) {// 获取缓存
            id response = [[self class] cahceResponseWithURL:absolute
                                                   parameters:params];
            
            if (response) {
                if (success) {
                    [self successResponse:response callback:success];
                    
                    if ([self isDebug]) {
                        [self logWithSuccessResponse:response
                                                 url:absolute
                                              params:params];
                    }
                }
                
                return nil;
            }
        }
        
        session = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self successResponse:responseObject callback:success];
            
            if (sg_cachePost) {
                [self cacheResponseObject:responseObject request:task.currentRequest  parameters:params];
            }
            [[self allTimesOfRetryURLs] removeObjectForKey:url]; //移除关联的超时重试次数
            [[self allTasks] removeObject:task];
            
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject
                                         url:absolute
                                      params:params];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //判断超时重试条件,满足则发起重试请求
            NSInteger timesOfRetry = [[[self allTimesOfRetryURLs] objectForKey:url] integerValue];
            if (error.code == CODE_TIMEOUT && timesOfRetry > 0) {
                [task cancel];
                [self _requestWithUrl:url refreshCache:refreshCache httpMedth:httpMethod params:params progress:progress success:success fail:fail];
                WXBAppLog(@"%@超时重试%@",url,@(timesOfRetry));
                //设置请求超时重试次数
                timesOfRetry--;
                [[self allTimesOfRetryURLs] setObject:@(timesOfRetry) forKey:url];
                return ;
            }
            [[self allTimesOfRetryURLs] removeObjectForKey:url]; //移除关联的超时重试次数
            [[self allTasks] removeObject:task];
            
            [self handleCallbackWithError:error fail:fail];
            
            if ([self isDebug]) {
                [self logWithFailError:error url:absolute params:params];
            }
        }];
    }
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

#pragma mark 上传图片
+ (WXBURLSessionTask *)uploadImageWithURL:(NSString *)url
                                   image:(UIImage *)image
                                  params:(NSDictionary *)params
                                progress:(WXBUploadProgress)progress
                                 success:(SuccessBlock)success
                                 failure:(FailureBlock)failure
{
    NSArray *array = [NSArray arrayWithObject:image];
    return [self uploadImageWithURL:url photos:array params:params progress:progress success:success failure:failure];
}

+ (WXBURLSessionTask *)uploadImageWithURL:(NSString *)url
                                  photos:(NSArray *)photos
                                  params:(NSDictionary *)params
                                progress:(WXBUploadProgress)progress
                                 success:(SuccessBlock)success
                                 failure:(FailureBlock)failure
{
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            WXBAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    } else {
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil) {
            WXBAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    }
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    NSString *absolute = [self absoluteUrlWithPath:url];
    
    AFHTTPSessionManager *manager = [self manager];
    WXBURLSessionTask *session = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < photos.count; i ++) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.png",str];
            UIImage *image = photos[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
            //压缩图片
            if (imageData.length>100*1024) {
                if (imageData.length>1024*1024) {//1M以及以上
                    imageData = UIImageJPEGRepresentation(image, 0.1f);
                }else if (imageData.length>512*1024) {//0.5M-1M
                    imageData = UIImageJPEGRepresentation(image, 0.2f);
                }else if (imageData.length>200*1024) {//0.25M-0.5M
                    imageData = UIImageJPEGRepresentation(image, 0.3f);
                }
            }
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"upload%d",i+1] fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
        NSLog(@"uploadProgress is %lld,总字节 is %lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allTasks] removeObject:task];
        [self successResponse:responseObject callback:success];
        
        if ([self isDebug]) {
            [self logWithSuccessResponse:responseObject
                                     url:absolute
                                  params:params];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[self allTasks] removeObject:task];
        [self handleCallbackWithError:error fail:failure];
        if ([self isDebug]) {
            [self logWithFailError:error url:absolute params:nil];
        }
    }];
    [session resume];
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

+ (WXBURLSessionTask *)uploadFileWithUrl:(NSString *)url
                           uploadingFile:(NSString *)uploadingFile
                                progress:(WXBUploadProgress)progress
                                 success:(SuccessBlock)success
                                    fail:(FailureBlock)fail {
    if ([NSURL URLWithString:uploadingFile] == nil) {
        WXBAppLog(@"uploadingFile无效，无法生成URL。请检查待上传文件是否存在");
        return nil;
    }
    
    NSURL *uploadURL = nil;
    if ([self baseUrl] == nil) {
        uploadURL = [NSURL URLWithString:url];
    } else {
        uploadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]];
    }
    
    if (uploadURL == nil) {
        WXBAppLog(@"URLString无效，无法生成URL。可能是URL中有中文或特殊字符，请尝试Encode URL");
        return nil;
    }
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    AFHTTPSessionManager *manager = [self manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:uploadURL];
    WXBURLSessionTask *session = nil;
    
    [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [[self allTasks] removeObject:session];
        
        [self successResponse:responseObject callback:success];
        
        if (error) {
            [self handleCallbackWithError:error fail:fail];
            
            if ([self isDebug]) {
                [self logWithFailError:error url:response.URL.absoluteString params:nil];
            }
        } else {
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject
                                         url:response.URL.absoluteString
                                      params:nil];
            }
        }
    }];
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

+ (WXBURLSessionTask *)downloadWithUrl:(NSString *)url
                            saveToPath:(NSString *)saveToPath
                              progress:(WXBDownloadProgress)progressBlock
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure {
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            WXBAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    } else {
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil) {
            WXBAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    }
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPSessionManager *manager = [self manager];
    
    WXBURLSessionTask *session = nil;
    
    session = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL URLWithString:saveToPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[self allTasks] removeObject:session];
        
        if (error == nil) {
            if (success) {
                success(filePath.absoluteString);
            }
            
            if ([self isDebug]) {
                WXBAppLog(@"Download success for url %@",
                          [self absoluteUrlWithPath:url]);
            }
        } else {
            [self handleCallbackWithError:error fail:failure];
            
            if ([self isDebug]) {
                WXBAppLog(@"Download fail for url %@, reason : %@",
                          [self absoluteUrlWithPath:url],
                          [error description]);
            }
        }
    }];
    
    [session resume];
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

#pragma mark - Private
+ (AFHTTPSessionManager *)manager {
    // 开启转圈圈
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = nil;;
    if ([self baseUrl] != nil) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
    } else {
        manager = [AFHTTPSessionManager manager];
    }
    
    switch (sg_requestType) {
        case kWXBRequestTypeJSON: {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        }
        case kWXBRequestTypePlainText: {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        }
        default: {
            break;
        }
    }
    
    switch (sg_responseType) {
        case kWXBResponseTypeJSON: {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        }
        case kWXBResponseTypeXML: {
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        }
        case kWXBResponseTypeData: {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        }
        default: {
            break;
        }
    }
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    
    for (NSString *key in sg_httpHeaders.allKeys) {
        if (sg_httpHeaders[key] != nil) {
            [manager.requestSerializer setValue:sg_httpHeaders[key] forHTTPHeaderField:key];
        }
    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    
    // 设置允许同时最大并发数量，过大容易出问题
    manager.operationQueue.maxConcurrentOperationCount = 5;
    // 设置超时限制
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    
    manager.requestSerializer.timeoutInterval = 15.0f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    return manager;
}

+ (void)logWithSuccessResponse:(id)response url:(NSString *)url params:(NSDictionary *)params {
    WXBAppLog(@"\n");
    WXBAppLog(@"\nRequest success, URL: %@\n params:%@\n response:%@\n\n",
              [self generateGETAbsoluteURL:url params:params],
              params,
              [self tryToParseData:response]);
}

+ (void)logWithFailError:(NSError *)error url:(NSString *)url params:(id)params {
    NSString *format = @" params: ";
    if (params == nil || ![params isKindOfClass:[NSDictionary class]]) {
        format = @"";
        params = @"";
    }
    
    WXBAppLog(@"\n");
    if ([error code] == NSURLErrorCancelled) {
        WXBAppLog(@"\nRequest was canceled mannully, URL: %@ %@%@\n\n",
                  [self generateGETAbsoluteURL:url params:params],
                  format,
                  params);
    } else {
        WXBAppLog(@"\nRequest error, URL: %@ %@%@\n errorInfos:%@\n\n",
                  [self generateGETAbsoluteURL:url params:params],
                  format,
                  params,
                  [error localizedDescription]);
    }
}

// 仅对一级字典结构起作用
+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(id)params {
    if (params == nil || ![params isKindOfClass:[NSDictionary class]] || [params count] == 0) {
        return url;
    }
    
    NSString *queries = @"";
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        } else if ([value isKindOfClass:[NSArray class]]) {
            continue;
        } else if ([value isKindOfClass:[NSSet class]]) {
            continue;
        } else {
            queries = [NSString stringWithFormat:@"%@%@=%@&",
                       (queries.length == 0 ? @"&" : queries),
                       key,
                       value];
        }
    }
    
    if (queries.length > 1) {
        queries = [queries substringToIndex:queries.length - 1];
    }
    
    if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1) {
        if ([url rangeOfString:@"?"].location != NSNotFound
            || [url rangeOfString:@"#"].location != NSNotFound) {
            url = [NSString stringWithFormat:@"%@%@", url, queries];
        } else {
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@", url, queries];
        }
    }
    
    return url.length == 0 ? queries : url;
}


+ (id)tryToParseData:(id)responseData {
    if ([responseData isKindOfClass:[NSData class]]) {
        // 尝试解析成JSON
        if (responseData == nil) {
            return responseData;
        } else {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
            
            if (error != nil) {
                return responseData;
            } else {
                return response;
            }
        }
    } else {
        return responseData;
    }
}

+ (void)successResponse:(id)responseData callback:(SuccessBlock)success {
    if (success) {
        success([self tryToParseData:responseData]);
    }
}


+ (NSString *)encodeUrl:(NSString *)url {
    return [self wxb_URLEncode:url];
}

+ (NSString *)wxb_URLEncode:(NSString *)url {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    NSString *newString =
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)url,
                                                              NULL,
                                                              CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
#pragma clang diagnostic pop
    if (newString) {
        return newString;
    }
    
    return url;
}

+ (id)cahceResponseWithURL:(NSString *)url parameters:params {
    id cacheData = nil;
    
    if (url) {
        // Try to get datas from disk
        NSString *directoryPath = cachePath();
        NSString *absoluteURL = [self generateGETAbsoluteURL:url params:params];
        NSString *key = [NSString wxbnetworking_md5:absoluteURL];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        if (data) {
            cacheData = data;
            WXBAppLog(@"Read data from cache for url: %@\n", url);
        }
    }
    
    return cacheData;
}

+ (void)cacheResponseObject:(id)responseObject request:(NSURLRequest *)request parameters:params {
    if (request && responseObject && ![responseObject isKindOfClass:[NSNull class]]) {
        NSString *directoryPath = cachePath();
        
        NSError *error = nil;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error) {
                WXBAppLog(@"create cache dir error: %@\n", error);
                return;
            }
        }
        
        NSString *absoluteURL = [self generateGETAbsoluteURL:request.URL.absoluteString params:params];
        NSString *key = [NSString wxbnetworking_md5:absoluteURL];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSData *data = nil;
        if ([dict isKindOfClass:[NSData class]]) {
            data = responseObject;
        } else {
            data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
        }
        
        if (data && error == nil) {
            BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            if (isOk) {
                WXBAppLog(@"cache file ok for request: %@\n", absoluteURL);
            } else {
                WXBAppLog(@"cache file error for request: %@\n", absoluteURL);
            }
        }
    }
}

+ (NSString *)absoluteUrlWithPath:(NSString *)path {
    if (path == nil || path.length == 0) {
        return @"";
    }
    
    if ([self baseUrl] == nil || [[self baseUrl] length] == 0) {
        return path;
    }
    
    NSString *absoluteUrl = path;
    
    if (![path hasPrefix:@"http://"] && ![path hasPrefix:@"https://"]) {
        absoluteUrl = [NSString stringWithFormat:@"%@%@",
                       [self baseUrl], path];
    }
    
    return absoluteUrl;
}

+ (void)handleCallbackWithError:(NSError *)error fail:(FailureBlock)fail {
    if ([error code] == NSURLErrorCancelled) {
        if (sg_shouldCallbackOnCancelRequest) {
            if (fail) {
                fail(error);
            }
        }
    } else {
        if (fail) {
            fail(error);
        }
    }
}
//使用AFN框架来检测网络状态的改变
+ (void)AFNReachability
{
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听网络状态的改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                alertSureInfo(@"当前没有网络！");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G");
                alertSureInfo(@"正在使用手机流量！");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                alertSureInfo(@"已连接到WiFi网络！");
                break;
                
            default:
                break;
        }
    }];
    
    //3.开始监听
    [manager startMonitoring];
}
static inline void alertSureInfo(NSString *content) {
    [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:sure];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}


@end






