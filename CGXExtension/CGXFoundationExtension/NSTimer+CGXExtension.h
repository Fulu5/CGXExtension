//
//  NSTimer+CGXExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (CGXExtension)

+ (dispatch_source_t)countDownTimerForInterval:(NSUInteger)seconds repeatTimes:(NSUInteger)times action:(void (^)(NSUInteger count))action completion:(void (^)(void))completion;
+ (void)cancelTimer:(dispatch_source_t)timer;
+ (dispatch_source_t)repeatTimerForInterval:(NSTimeInterval)seconds action:(void (^)(void))action startImmdiately:(BOOL)startImmediately;
+ (dispatch_source_t)repeatTimerForInterval:(NSTimeInterval)seconds action:(void (^)(void))action;

@end
