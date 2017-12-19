//
//  CGXLog.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaLumberjack.h"

/**
 日志
 Debug  : Error, warning, info, debug and verbose logs
 Release: Error logs only
 */

#ifdef DEBUG
static DDLogLevel const ddLogLevel = DDLogLevelVerbose;//固定写法
#else
static DDLogLevel const ddLogLevel = DDLogLevelError;
#endif

@interface CGXLog : NSObject

+ (NSString *)logsDirecroty;

@end
