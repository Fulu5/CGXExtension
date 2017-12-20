//
//  CGXTimestampManager.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/20.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGXTimestampManager : NSObject

+ (NSTimeInterval)timestamp;

+ (void)setServerTimestamp:(NSTimeInterval)serverTimestamp;

@end
