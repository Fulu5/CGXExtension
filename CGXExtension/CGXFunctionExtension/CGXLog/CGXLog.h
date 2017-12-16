//
//  CGXLog.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaLumberjack.h"

#ifdef DEBUG
static DDLogLevel const ddlogLevel = DDLogLevelVerbose;
#else
static DDLogLevel const DDLogLevel = DDLogLevelError;
#endif

@interface CGXLog : NSObject

+ (NSString *)logsDirecroty;

@end
