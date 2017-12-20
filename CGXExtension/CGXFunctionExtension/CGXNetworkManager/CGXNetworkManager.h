//
//  CGXNetworkManager.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/19.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

typedef NS_ENUM(NSInteger, CGXNetworkReachabilityStatus) {
    //未知网络
    CGXNetworkReachabilityStatusUnknown         = -1,
    //无法连接
    CGXNetworkReachabilityStatusNorReachable    = 0,
    //WWAN网络
    CGXNetworkReachabilityStatusViaWWAN         = 1,
    //WiFi网络
    CGXNetworkReachabilityStatusViaWiFi         = 2,
};

/**
 * GET:     获取资源，不会改动资源
 * POST:    创建记录
 * PATCH:   改变资源状态或更新部分属性
 * PUT:     更新全部属性
 * DELETE:  删除资源
 */
typedef NS_ENUM(NSInteger, NetworkManagerHTTPMethod) {
    GET = 0,
    POST,
    PUT,
    DELETE,
    PATCH,
};

typedef void(^CGXNetworkManagerUploadProgressChangedBlock)(CGFloat progress);
typedef void(^CGXNetworkManagerDownloadCompletionBlock)(NSURL *filePath, NSError *error);
typedef void(^CGXNetworkManagerMultiFilesDownloadCompletionBlock)(NSArray<NSURL *> *filePaths, NSError *error);

@class CGXNetworkResult;

@interface CGXNetworkManager : NSObject

/** 通用参数 */
@property (nonatomic, strong) NSMutableDictionary *commonParams;
/** 通用请求头 */
@property (nonatomic, strong) NSMutableDictionary *commonHeaders;
/** 普通请求 */
@property (nonatomic, strong) AFHTTPSessionManager  *sessionManager;
/** 上传下载 */
@property (nonatomic, strong) AFURLSessionManager   *taskManager;

#pragma mark - Request

/**
 *  根据相应接口获取数据-基础方法
 *
 *  @param params           数据字典
 *  @param interfaceAddress 接口地址
 *  @param completion       接口返回处理方法
 *  @param method           网络请求方法
 */
- (NSURLSessionTask *)sendRequestWithParams:(NSDictionary *)params
                                     interfaceAddress:(NSString *)interfaceAddress
                                           completion:(void (^)(CGXNetworkResult *result))completion
                                               method:(NetworkManagerHTTPMethod)method;

/**
 *  根据相应接口获取数据-带有loadingStatus不带failure
 *
 *  @param params           数据字典
 *  @param interfaceAddress 接口地址
 *  @param completion       接口返回处理方法
 *  @param loadingStatus    是否显示加载提示  nil则不提示
 *  @param method           网络请求方法
 */
- (NSURLSessionTask *)sendRequestWithParams:(NSDictionary *)params
                                     interfaceAddress:(NSString *)interfaceAddress
                                           completion:(void (^)(CGXNetworkResult *result))completion
                                        loadingStatus:(NSString *)loadingStatus
                                               method:(NetworkManagerHTTPMethod)method;

/**
 *  根据相应接口获取数据-半完整-不带上传
 *
 *  @param params           数据字典
 *  @param interfaceAddress 接口地址
 *  @param completion       接口返回处理方法
 *  @param networkFailure   网络失败处理方法
 *  @param loadingStatus    是否显示加载提示  nil则不提示
 *  @param method           网络请求方法
 */
- (NSURLSessionTask *)sendRequestWithParams:(NSDictionary *)params
                                     interfaceAddress:(NSString *)interfaceAddress
                                           completion:(void (^)(CGXNetworkResult *result))completion
                                       networkFailure:(void (^)(NSError *error))networkFailure
                                        loadingStatus:(NSString *)loadingStatus
                                               method:(NetworkManagerHTTPMethod)method;

/**
 根据相应接口获取数据-完整

 @param params              参数字典
 @param uploadObjectsArray  上传文件数组(仅在 POST 下生效)
 @param interfaceAddress    接口地址
 @param completion          成功回调
 @param networkFailure      失败回调
 @param loadingStatus       是否显示加载提示
 @param uploadProgressBlock 上传进度
 @param timeoutInterval     超时时间
 @param method              请求姿势
 */
- (NSURLSessionTask *)sendRequestWithParams:(NSDictionary *)params
                         uploadObjectsArray:(NSArray *)uploadObjectsArray
                           interfaceAddress:(NSString *)interfaceAddress
                                 completion:(void (^)(CGXNetworkResult *result))completion
                             networkFailure:(void (^)(NSError *error))networkFailure
                              loadingStatus:(NSString *)loadingStatus
                             uploadProgress:(CGXNetworkManagerUploadProgressChangedBlock)uploadProgressBlock
                            timeoutInterval:(NSTimeInterval)timeoutInterval
                                     method:(NetworkManagerHTTPMethod)method;

#pragma mark - Upload & Download

/**
 *  根据 URL 下载文件
 *
 *  @param URL              文件 URL
 *  @param completion       下载完毕后执行的方法
 */
- (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)URL
                                   completion:(CGXNetworkManagerDownloadCompletionBlock)completion;

/**
 *  根据 URL 下载文件
 *
 *  @param URL              文件 URL
 *  @param directory        下载目录
 *  @param completion       下载完毕后执行的方法
 */
- (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)URL
                                    directory:(NSURL *)directory
                                   completion:(CGXNetworkManagerDownloadCompletionBlock)completion;

/**
 *  根据 URL 下载文件
 *
 *  @param URL              文件 URL
 *  @param directory        下载目录
 *  @param loadingStatus    是否显示加载提示  nil则不提示 不为nil则同时显示下载进度
 *  @param completion       下载完毕后执行的方法
 */
- (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)URL
                                    directory:(NSURL *)directory
                                loadingStatus:(NSString *)loadingStatus
                                   completion:(CGXNetworkManagerDownloadCompletionBlock)completion;

/**
 *  根据 URLArray 下载文件
 *
 *  @param URLArray         文件 URLArray
 *  @param directory        下载目录 所有的文件都下载到这个目录
 *  @param completion       下载完毕后执行的方法
 */
- (NSArray<NSURLSessionDownloadTask *> *)downloadWithURLArray:(NSArray<NSString *> *)URLArray
                                                    directory:(NSURL *)directory
                                                   completion:(CGXNetworkManagerMultiFilesDownloadCompletionBlock)completion;

#pragma mark - Cancel

/** 取消所有普通请求 */
- (void)cancelAllRequest;
/** 取消所有上传下载 */
- (void)cancelAllTasks;
/** 取消所有网络请求及上传下载 */
- (void)cancelAllRequestAndTasks;

#pragma mark - Return Data Handle

/** 子类重写此方法来新增请求参数 */
- (void)willSendHTTPRequestWithParams:(NSMutableDictionary *)params NS_REQUIRES_SUPER;
/** 处理请求成功 */
- (void)handleSuccessWithURLSessionTask:(NSURLSessionTask *)task result:(CGXNetworkResult *)result NS_REQUIRES_SUPER;
/** 处理请求失败 */
- (void)handleFailureWithURLSessionTask:(NSURLSessionTask *)task result:(CGXNetworkResult *)result NS_REQUIRES_SUPER;

#pragma mark - New

/** 默认全局的 manager */
+ (instancetype)sharedInstance;
/** 新建一个 manager */
+ (instancetype)newManager;

@end
