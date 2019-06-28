//
//  WXBNetworking.h
//  Gaia
//
//  Created by 魏心兵 on 16/3/31.
//  Copyright © 2016年 Weixb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const YQNetworkStatus;

// 请勿直接使用NSURLSessionDataTask,以减少对第三方的依赖
// 所有接口返回的类型都是基类NSURLSessionTask，若要接收返回值且处理，请转换成对应的子类类型
typedef NSURLSessionTask WXBURLSessionTask;
typedef void(^SuccessBlock)(id response);
typedef void(^FailureBlock)(NSError *error);

typedef NS_ENUM(NSUInteger, WXBRequestType) {
    kWXBRequestTypeJSON = 1,        // 默认
    kWXBRequestTypePlainText  = 2,  // 普通text/html
};
typedef NS_ENUM(NSUInteger, WXBResponseType) {
    kWXBResponseTypeJSON = 1, // 默认
    kWXBResponseTypeXML  = 2, // XML
    // 特殊情况下，一转换服务器就无法识别的，默认会尝试转换成JSON，若失败则需要自己去转换
    kWXBResponseTypeData = 3
};
/**
 *  下载进度
 *
 *  @param bytesRead      已下载的大小
 *  @param totalBytesRead 文件总大小
 */
typedef void(^WXBDownloadProgress)(int64_t bytesRead,
                                   int64_t totalBytesRead);
typedef WXBDownloadProgress WXBGetProgress;
typedef WXBDownloadProgress WXBPostProgress;
/**
 *  上传进度
 *
 *  @param bytesWritten              已上传的大小
 *  @param totalBytesWritten         总上传大小
 */
typedef void (^WXBUploadProgress)(int64_t bytesWritten,
                                  int64_t totalBytesWritten);





@interface YQNetworking : NSObject
/**
 *  GET请求接口，若不指定baseurl，可传完整的url
 *
 *  @param url     接口路径，如/path/getArticleList
 *  @param refreshCache 是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
 *  @param success 接口成功请求到数据的回调
 *  @param fail    接口请求数据失败的回调
 *
 *  @return 返回的对象中有可取消请求的API
 */
+ (WXBURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                          success:(SuccessBlock)success
                             fail:(FailureBlock)fail;
// 多一个params参数，如@{"categoryid" : @(12)}
+ (WXBURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                          success:(SuccessBlock)success
                             fail:(FailureBlock)fail;
// 多一个带进度回调
+ (WXBURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                         progress:(WXBGetProgress)progress
                          success:(SuccessBlock)success
                             fail:(FailureBlock)fail;


/**
 *  POST请求接口，若不指定baseurl，可传完整的url
 *
 *  @param url     接口路径，如/path/getArticleList
 *  @param params  接口中所需的参数，如@{"categoryid" : @(12)}
 *  @param success 接口成功请求到数据的回调
 *  @param fail    接口请求数据失败的回调
 *
 *  @return 返回的对象中有可取消请求的API
 */
+ (WXBURLSessionTask *)postWithUrl:(NSString *)url
                      refreshCache:(BOOL)refreshCache
                            params:(NSDictionary *)params
                           success:(SuccessBlock)success
                              fail:(FailureBlock)fail;
+ (WXBURLSessionTask *)postWithUrl:(NSString *)url
                      refreshCache:(BOOL)refreshCache
                            params:(NSDictionary *)params
                          progress:(WXBPostProgress)progress
                           success:(SuccessBlock)success
                              fail:(FailureBlock)fail;

/**
 *  图片上传接口，若不指定baseurl，可传完整的url
 *
 *  @param url      上传图片的接口路径，如/path/images/
 *  @param photos   图片数组
 *  @param params   参数
 *  @param progress 上传进度
 *  @param success  上传成功回调
 *  @param failure  上传失败回调
 *
 *  @return 返回的对象中有可取消请求的API
 */
+ (WXBURLSessionTask *)uploadImageWithURL:(NSString *)url
                                   photos:(NSArray *)photos
                                   params:(NSDictionary *)params
                                 progress:(WXBUploadProgress)progress
                                  success:(SuccessBlock)success
                                  failure:(FailureBlock)failure;
//上传单张图片
+ (WXBURLSessionTask *)uploadImageWithURL:(NSString *)url
                                    image:(UIImage *)image
                                   params:(NSDictionary *)params
                                 progress:(WXBUploadProgress)progress
                                  success:(SuccessBlock)success
                                  failure:(FailureBlock)failure;
//上传data数据
+ (WXBURLSessionTask *)uploadDataWithURL:(NSString *)url
                                    data:(NSData *)data
                                  params:(NSDictionary *)params
                                progress:(WXBUploadProgress)progress
                                 success:(SuccessBlock)success
                                 failure:(FailureBlock)failure;
/**
 *  上传文件
 *
 *  @param url              上传路径
 *  @param uploadingFile    待上传文件的路径
 *  @param progress         上传进度
 *  @param success          上传成功回调
 *  @param fail             上传失败回调
 *
 *  @return 返回的对象中有可取消请求的API
 */
+ (WXBURLSessionTask *)uploadFileWithUrl:(NSString *)url
                           uploadingFile:(NSString *)uploadingFile
                                progress:(WXBUploadProgress)progress
                                 success:(SuccessBlock)success
                                    fail:(FailureBlock)fail;
/**
 *  下载文件
 *
 *  @param url           下载URL
 *  @param progressBlock 下载进度
 *  @param success       下载成功后的回调
 *  @param failure       下载失败后的回调
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，重新开启下载调用resume方法
 */
+ (WXBURLSessionTask *)downloadWithUrl:(NSString *)url
                              progress:(WXBDownloadProgress)progressBlock
                               success:(void(^)(NSURL *fileUrl))success
                               failure:(FailureBlock)failure;

/**
 *  取消所有请求
 */
+ (void)cancelAllRequest;
/*
 *  取消单个请求。
 *  如果是要取消某个请求，最好是引用接口所返回来的WXBURLSessionTask对象，
 *  然后调用对象的cancel方法。如果不想引用对象，这里额外提供了一种方法来实现取消某个请求
 *
 *  @param url  可以是绝对URL，也可以是path（也就是不包括baseurl）
 */
+ (void)cancelRequestWithURL:(NSString *)url;


/**
 *  缓存
 *
 *  默认只缓存GET请求的数据，对于POST请求是不缓存的。如果要缓存POST获取的数据，需要手动调用设置
 *  对JSON类型数据有效，对于PLIST、XML不确定！
 *
 *  @param isCacheGet           默认为YES
 *  @param shouldCachePost  默认为NO
 */
+ (void)cacheGetRequest:(BOOL)isCacheGet shoulCachePost:(BOOL)shouldCachePost;
/**
 *  清除缓存
 */
+ (void)clearCaches;
/**
 *  获取缓存总大小/bytes
 *
 *  @return 缓存大小
 */
+ (unsigned long long)totalCacheSize;


/**
 *  BaseURL
 *  用于指定网络请求接口的基础url，如：
 *  http://baidu.com或者http://192.168.7.15:8080
 *  通常在AppDelegate中启动时就设置一次就可以了。如果接口有来源
 *  于多个服务器，可以调用更新
 *
 *  @param baseUrl 网络接口的基础url
 */
+ (void)updateBaseUrl:(NSString *)baseUrl;
/**
 *  获取当前的baseUrl
 */
+ (NSString *)baseUrl;


/**
 *
 *  配置公共的请求头，只调用一次即可，通常放在应用启动的时候配置就可以了
 *
 *  @param httpHeaders 只需要将与服务器商定的固定参数设置即可
 */
+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders;

/**
 *  配置请求格式，默认为JSON。如果要求传XML或者PLIST，请在全局配置一下
 *
 *  @param requestType 请求格式，默认为JSON
 *  @param responseType 响应格式，默认为JSO，
 *  @param shouldAutoEncode 默认为NO，是否自动encode url
 *  @param shouldCallbackOnCancelRequest 当取消请求时，是否要回调，默认为YES
 */
+ (void)configRequestType:(WXBRequestType)requestType
             responseType:(WXBResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest;



/**
 *  开启或关闭是否自动将URL使用UTF8编码，用于处理链接中有中文时无法请求的问题
 *
 *  @param shouldAutoEncode YES or NO,默认为NO
 */
+ (void)shouldAutoEncodeUrl:(BOOL)shouldAutoEncode;

/*
 *  格式化接口数据打印日志
 *
 *  开启或关闭接口打印信息
 *
 *  @param isDebug 开发期，最好打开，默认是NO
 */
+ (void)enableInterfaceDebug:(BOOL)isDebug;

//使用AFN框架来检测网络状态的改变
+ (void)AFNReachability;

/**
 *
 *  配置请求超时重试次数(不支持上传下载接口)
 *
 *  @param number 默认重试次数为3
 */
+ (void)setNumberOfTimesToRetryOnTimeout:(NSInteger)number;

@end
