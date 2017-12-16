//
//  CGXLogUploadHelper.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "CGXLogUploadHelper.h"
#import "CGXLog.h"
#import "CGXFileManager.h"
#import "CGXExtensionDefine.h"

@implementation CGXLogUploadHelper

+ (NSArray<NSString *> *)logPaths {
    NSString *logsDirecrory = [CGXLog logsDirecroty];
    
    if (![CGXFileManager existsItemAtPath:logsDirecrory]) {
        return nil;
    }
    
    NSArray *logsPath = [CGXFileManager listFilesInDirectoryAtPath:logsDirecrory withSuffix:@".log"];
    
    if (logsPath.count) {
        return logsPath;
    }
    
    return nil;
}

+ (BOOL)deleteLogAtPath:(NSString *)logPath error:(NSError **)error {
    if (![CGXFileManager existsItemAtPath:logPath]) {
        *error = [NSError errorWithDomain:kCGXExtensionErrorDomain code:CGXExtensionErrorCodeInputError userInfo:@{NSLocalizedDescriptionKey:@"logPath doesn't exist"}];
        DDLogError(@"%@ %@ Error. logPath -> %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd),logPath);
        return NO;
    }
    return [CGXFileManager removeItemAtPath:logPath error:error];
}

@end
