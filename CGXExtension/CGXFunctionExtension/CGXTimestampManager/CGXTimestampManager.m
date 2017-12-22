//
//  CGXTimestampManager.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/20.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "CGXTimestampManager.h"
#import "CGXMacroExtensionHeader.h"

@interface CGXTimestampManager ()

/** 服务器时间和本地当前的时间差 */
@property (nonatomic, assign) NSTimeInterval timestampDelta;

@end

@implementation CGXTimestampManager

+ (NSTimeInterval)timestamp {
    return [CGXTimestampManager localTimestamp] + [CGXTimestampManager sharedInstance].timestampDelta;
}

+ (void)setServerTimestamp:(NSTimeInterval)serverTimestamp {
    if (serverTimestamp > 0) {
        //缓存服务器时间与本地时间的差值
        [CGXTimestampManager sharedInstance].timestampDelta = serverTimestamp - [CGXTimestampManager localTimestamp];
    }
}

+ (NSTimeInterval)localTimestamp {
    return [NSDate date].timeIntervalSince1970;
}

SharedInstanceImplementation

@end
