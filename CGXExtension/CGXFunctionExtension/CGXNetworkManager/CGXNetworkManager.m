//
//  CGXNetworkManager.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/19.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "CGXNetworkManager.h"
#import "CGXNetworkResult.h"
#import "CGXNetworkUploadObject.h"
#import "CGXHUDManager.h"
#import "CGXExtensionDefine.h"
#import "CGXLog.h"
#import "NSString+CGXExtension.h"
#import "CGXFileManager.h"
#import "NSDictionary+CGXExtension.h"

NSString const* kCGXnetworkLoadingStatusDefault = @"正在加载";

NSTimeInterval const kCGXNetworkSessionTimeoutIntervalDefault = 15.;
NSTimeInterval const kCGXNetworkUploadTimeoutIntervalDefault = 600.;// or 0. ?

@implementation CGXNetworkManager

- (NSURLSessionTask *)sendRequestWithParams:(NSDictionary *)params
                                     interfaceAddress:(NSString *)interfaceAddress
                                           completion:(void (^)(CGXNetworkResult *result))completion
                                               method:(NetworkManagerHTTPMethod)method {
    return [self sendRequestWithParams:params
                      interfaceAddress:interfaceAddress
                            completion:completion
                         loadingStatus:nil
                                method:method];
}

- (NSURLSessionTask *)sendRequestWithParams:(NSDictionary *)params
                                     interfaceAddress:(NSString *)interfaceAddress
                                           completion:(void (^)(CGXNetworkResult *result))completion
                                        loadingStatus:(NSString *)loadingStatus
                                               method:(NetworkManagerHTTPMethod)method {
    return [self sendRequestWithParams:params
                      interfaceAddress:interfaceAddress
                            completion:completion
                        networkFailure:nil
                         loadingStatus:loadingStatus
                                method:method];
}

- (NSURLSessionTask *)sendRequestWithParams:(NSDictionary *)params
                                     interfaceAddress:(NSString *)interfaceAddress
                                           completion:(void (^)(CGXNetworkResult *result))completion
                                       networkFailure:(void (^)(NSError *error))networkFailure
                                        loadingStatus:(NSString *)loadingStatus
                                               method:(NetworkManagerHTTPMethod)method {
    return [self sendRequestWithParams:params
                    uploadObjectsArray:nil
                      interfaceAddress:interfaceAddress
                            completion:completion
                        networkFailure:networkFailure
                         loadingStatus:loadingStatus
                        uploadProgress:nil
                       timeoutInterval:kCGXNetworkSessionTimeoutIntervalDefault
                                method:method];
}

- (NSURLSessionTask *)sendRequestWithParams:(NSDictionary *)params
                         uploadObjectsArray:(NSArray *)uploadObjectsArray
                           interfaceAddress:(NSString *)interfaceAddress
                                 completion:(void (^)(CGXNetworkResult *))completion
                             networkFailure:(void (^)(NSError *))networkFailure
                              loadingStatus:(NSString *)loadingStatus
                             uploadProgress:(CGXNetworkManagerUploadProgressChangedBlock)uploadProgressBlock
                            timeoutInterval:(NSTimeInterval)timeoutInterval
                                     method:(NetworkManagerHTTPMethod)method {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if (loadingStatus) {
        [CGXHUDManager showWithStatus:loadingStatus];
    }
    
    NSMutableDictionary *sendParams = nil;
    
#pragma mark - CommonParams
    
    if (params.count || self.commonParams.count) {
        sendParams = [NSMutableDictionary dictionaryWithDictionary:params];
        [sendParams addEntriesFromDictionary:self.commonParams];
    }

#pragma mark - CommonHeaders
    
    /** 设置请求头 */
    [self.commonHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * _Nonnull stop) {
        if ([key isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
            [self.sessionManager.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }];

#pragma mark - WillSendHTTPRequest
    
    /** 添加子类新增的参数 */
    [self willSendHTTPRequestWithParams:sendParams];
    
#pragma mark - Success
    
    void (^successBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask * task, id responseObject) {

        if (!self.sessionManager.operationQueue.operationCount) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }

        CGXNetworkResult *result = [CGXNetworkResult resultWithDictionary:responseObject];

        result.allHeaderFields = ((NSHTTPURLResponse *)task.response).allHeaderFields;

        if (result.code == CGXExtensionErrorCodeSuccess) {
            if (loadingStatus) {
                [CGXHUDManager dismiss];
            }

            DDLogInfo(@"\nSuccess : %@ \n%@", result.message, [CGXNetworkManager responseInfoDescription:task responseObject:responseObject]);

            [self handleSuccessWithURLSessionTask:task result:result];
            
        } else {
            if (loadingStatus) {
                [CGXHUDManager showErrorAndAutoDismissWithTitle:result.message];
            }

            DDLogInfo(@"\nError : %@ \n%@", result.error.localizedDescription, [CGXNetworkManager responseInfoDescription:task responseObject:responseObject]);

            [self handleFailureWithURLSessionTask:task result:result];
        }

        if (completion) {
            completion(result);
        }
    };
    
#pragma mark - Failure
    
    void (^failureBlock)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error) {

        if (!self.taskManager.operationQueue.operationCount) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }

        DDLogError(@"\n------可能原因:请求姿势错误------\nError : %@ \n%@", error.userInfo, [CGXNetworkManager responseInfoDescription:task responseObject:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]]);

        NSString *message = @"网络连接失败";

        if (loadingStatus) {
            [CGXHUDManager showErrorAndAutoDismissWithTitle:message];
        }

        if (networkFailure) {
            networkFailure([NSError errorWithDomain:kCGXExtensionErrorDomain code:CGXExtensionErrorCodeLostNetwork userInfo:@{NSLocalizedDescriptionKey : message}]);
        }
    };
    
#pragma mark - Progress
    
    void (^progressBlock)(NSProgress *uploadProgress) = uploadProgressBlock ?
    ^(NSProgress *uploadProgress) {
        uploadProgressBlock(1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } : nil;
    
    NSURLSessionTask *sessionTask = nil;
    
#pragma mark - 上传
    
    if (uploadObjectsArray.count) {
        
        if (timeoutInterval >= 0) {
            self.sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
        } else {
            self.sessionManager.requestSerializer.timeoutInterval = kCGXNetworkUploadTimeoutIntervalDefault;
        }
        
        void (^constructingBodyBlock)(id<AFMultipartFormData> formData) = uploadObjectsArray.count ?
        ^(id<AFMultipartFormData> formData) {
            for (CGXNetworkUploadObject *uploadObject in uploadObjectsArray) {
                if ([uploadObject isKindOfClass:[CGXNetworkUploadObject class]] && uploadObject.paramName.length && uploadObject.file) {
                    
                    NSData *data = nil;
                    
                    if ([uploadObject.file isKindOfClass:[NSData class]]) {
                        data = uploadObject.file;
                    } else if ([uploadObject.file isKindOfClass:[UIImage class]]) {
                        data = UIImageJPEGRepresentation(uploadObject.file, uploadObject.imageQuality);
                    } else {
                        continue;
                    }
                    
                    [formData appendPartWithFileData:data
                                                name:uploadObject.paramName
                                            fileName:uploadObject.fileName
                                            mimeType:uploadObject.fileType];
                } else {
                    DDLogInfo(@"上传数据格式错误");
                }
            }
        }: nil;
        
        sessionTask = [self.sessionManager POST:interfaceAddress
                                                    parameters:sendParams
                                     constructingBodyWithBlock:constructingBodyBlock
                                                      progress:progressBlock
                                                       success:successBlock
                                                       failure:failureBlock];
        
        [sessionTask resume];
        
    } else {
        
        if (timeoutInterval >= 0) {
            self.sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
        } else {
            self.sessionManager.requestSerializer.timeoutInterval = kCGXNetworkSessionTimeoutIntervalDefault;
        }
        
        switch (method) {
            case GET:
            {
                [self.sessionManager GET:interfaceAddress
                              parameters:sendParams
                                progress:progressBlock
                                 success:successBlock
                                 failure:failureBlock];
            }
                break;
            case POST:
            {
                [self.sessionManager POST:interfaceAddress
                              parameters:sendParams
                                progress:progressBlock
                                 success:successBlock
                                 failure:failureBlock];
            }
                break;
            case PUT:
            {
                [self.sessionManager PUT:interfaceAddress
                              parameters:sendParams
                                 success:successBlock
                                 failure:failureBlock];
            }
                break;
            case DELETE:
            {
                [self.sessionManager DELETE:interfaceAddress
                                 parameters:sendParams
                                    success:successBlock
                                    failure:failureBlock];
            }
                break;
            case PATCH:
            {
                [self.sessionManager PATCH:interfaceAddress
                                parameters:sendParams
                                   success:successBlock
                                   failure:failureBlock];
            }
                break;
                
            default:
                break;
        }
    }
    
    return sessionTask;
}

#pragma mark - Upload & Download

- (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)URL
                                   completion:(CGXNetworkManagerDownloadCompletionBlock)completion {
    return [self downloadWithURL:URL
                       directory:nil
                      completion:completion];
}

- (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)URL
                                    directory:(NSURL *)directory
                                   completion:(CGXNetworkManagerDownloadCompletionBlock)completion {
    return [self downloadWithURL:URL
                       directory:directory
                   loadingStatus:nil
                      completion:completion];
}

- (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)URL
                                    directory:(NSURL *)directory
                                loadingStatus:(NSString *)loadingStatus
                                   completion:(CGXNetworkManagerDownloadCompletionBlock)completion {
    
    if (!URL.length) {
        if (completion) {
            completion(nil,[NSError errorWithDomain:kCGXExtensionErrorDomain code:CGXExtensionErrorCodeInputError userInfo:@{NSLocalizedDescriptionKey : @"下载URL为空"}]);
        }
        return nil;
    }
    
    NSURLSessionDownloadTask *dt = [self.tasksManager downloadTaskWithRequest:URL.URLRequest
                                                                     progress:nil
                                                                  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                      return [CGXNetworkManager downloadDestinationWithDirectory:directory response:response];
                                                                  }
                                                            completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                if (loadingStatus && (error.code == CGXExtensionErrorCodeCancelled)) {
                                                                    [CGXHUDManager showSuccessAndAutoDismissWithTitle:@"下载已取消"];
                                                                }
                                                                
                                                                if (completion) {
                                                                    completion(filePath,error);
                                                                }
                                                            }];
    
    if (loadingStatus) {
        [self.tasksManager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            if (downloadTask == dt) { //同时只显示一个进度
                double progress = totalBytesWritten/(double)totalBytesExpectedToWrite;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (progress < 1) {
                        [CGXHUDManager showProgress:progress status:loadingStatus];
                    } else {
                        [CGXHUDManager showSuccessAndAutoDismissWithTitle:@"下载成功"];
                    }
                });
            }
        }];
    }
    
    [dt resume];
    
    return dt;
}

- (NSArray<NSURLSessionDownloadTask *> *)downloadWithURLArray:(NSArray<NSString *> *)URLArray
                                                    directory:(NSURL *)directory
                                                   completion:(CGXNetworkManagerMultiFilesDownloadCompletionBlock)completion {
    if (!URLArray.count) {
        if (completion) {
            completion(nil,[NSError errorWithDomain:kCGXExtensionErrorDomain code:CGXExtensionErrorCodeInputError userInfo:@{NSLocalizedDescriptionKey : @"下载URL为空"}]);
        }
        return nil;
    }
    
    //下载队列
    NSMutableArray *tasks = [NSMutableArray array];
    //文件地址
    NSMutableArray *filePaths = [NSMutableArray array];
    //创建下载任务
    for (NSString *URL in URLArray) {
        if (!URL.length) {
            continue;
        }
        
        NSURLSessionDownloadTask *dt = [self.tasksManager downloadTaskWithRequest:URL.URLRequest
                                                                         progress:nil
                                                                      destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                          return [CGXNetworkManager downloadDestinationWithDirectory:directory response:response];
                                                                      }
                                                                completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                    if (!error && filePath) {
                                                                        [filePaths addObject:filePath];
                                                                    }
                                                                }];
        //将下载任务添加到队列
        [tasks addObject:dt];
    }
    
    if (!tasks.count) {
        completion(nil,[NSError errorWithDomain:kCGXExtensionErrorDomain code:CGXExtensionErrorCodeInputError userInfo:@{NSLocalizedDescriptionKey : @"没有有效的下载URL"}]);
        return nil;
    }
    
    //下载完成 从队列中移除
    [self.tasksManager setTaskDidCompleteBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSError * _Nonnull error) {
        if ([tasks containsObject:task]) {
            [tasks removeObject:task];
        }
        
        //如果当前没有下载任务 则表示下载全部完成
        if (!tasks.count) {
            if (error.code == CGXExtensionErrorCodeCancelled) {
                completion(filePaths,[NSError errorWithDomain:kCGXExtensionErrorDomain code:CGXExtensionErrorCodeCancelled userInfo:@{NSLocalizedDescriptionKey : @"用户下载取消"}]);
            } else {
                completion(filePaths,error);
            }
        }
    }];
    
    //开始下载
    for (NSURLSessionDownloadTask *dt in tasks) {
        [dt resume];
    }
    
    return tasks;
}

//获取下载目录 若目录不存在则创建目录
+ (NSURL *)downloadDestinationWithDirectory:(NSURL *)directory response:(NSURLResponse *)response {
    NSURL *targetURL = directory?:[[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                          inDomain:NSUserDomainMask
                                                                 appropriateForURL:nil
                                                                            create:NO
                                                                             error:nil] URLByAppendingPathComponent:@"Downloads"];
    if (![CGXFileManager isDirectoryItemAtPath:targetURL.relativePath]) {
        [CGXFileManager createDirectoriesForPath:targetURL.relativePath];
    }
    return [targetURL URLByAppendingPathComponent:[response suggestedFilename]];
}

#pragma mark - Cancel

- (void)cancelAllRequest {
    [self.sessionManager.operationQueue cancelAllOperations];
}

- (void)cancelAllTasks {
    for (NSURLSessionTask *task in self.tasksManager.tasks) {
        [task cancel];
    }
}

- (void)cancelAllRequestAndTasks {
    [self cancelAllRequest];
    [self cancelAllTasks];
}

#pragma mark - Return Data Handle

- (void)willSendHTTPRequestWithParams:(NSMutableDictionary *)params {
    
}

- (void)handleSuccessWithURLSessionTask:(NSURLSessionTask *)task result:(CGXNetworkResult *)result {
    
}

- (void)handleFailureWithURLSessionTask:(NSURLSessionTask *)task result:(CGXNetworkResult *)result {
    
}

#pragma mark - New

+ (instancetype)sharedInstance {
    static id networkManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [[self new] commonInit];
    });
    
    return networkManager;
}

+ (instancetype)newManager {
    return [[self new] commonInit];
}

- (instancetype)commonInit {
    self.commonParams = [NSMutableDictionary dictionary];
    self.commonHeaders = [NSMutableDictionary dictionary];
    self.sessionManager = [AFHTTPSessionManager new];
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                     @"text/html",
                                                                     @"text/json",
                                                                     @"application/json",
                                                                     @"text/plain",
                                                                     @"text/javascript",
                                                                     nil];
    return self;
}

- (AFURLSessionManager *)tasksManager {
    if (_taskManager) {
        return _taskManager;
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _taskManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    return _taskManager;
}

#pragma mark - Private

+ (NSString *)responseInfoDescription:(NSURLSessionDataTask *)task responseObject:(id)object {
    
    NSMutableURLRequest *request = (NSMutableURLRequest *)task.originalRequest;
    NSString *requestBody = @"";
    
    @try {
        
        requestBody = [object JSONPrettyStringEncoded];
        
    } @catch (NSException *exception) {
        
        NSLog(@"\n------Exception Reason------\n%@\n", exception.reason);
        
    } @finally {
        
    }
    
    return [NSString stringWithFormat:
            @" ------RequestURL------: \n %@ %@, \n "
            " ------RequestBody------: \n %@, \n "
            " ------RequestHeader------:\n %@, \n "
            " ------ResponseStatus------:\n %@, \n "
            " ------ResponseBody------:\n %@, \n "
            " ------ResponseHeader-----:\n %@ \n ",
            request.URL, request.HTTPMethod,
            [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding],
            request.allHTTPHeaderFields,
            @(((NSHTTPURLResponse *)task.response).statusCode),
            requestBody,
            ((NSHTTPURLResponse *)task.response).allHeaderFields];
}

@end
