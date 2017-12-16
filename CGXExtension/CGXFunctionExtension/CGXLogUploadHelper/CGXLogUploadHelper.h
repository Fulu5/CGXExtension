//
//  CGXLogUploadHelper.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGXLogUploadHelper : NSObject

+ (NSArray<NSString *> *)logPaths;

+ (BOOL)deleteLogAtPath:(NSString *)logPath error:(NSError **)error;

@end
