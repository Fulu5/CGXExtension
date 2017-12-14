//
//  UIControl+CGXSwizzlingExtension.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "UIControl+CGXSwizzlingExtension.h"
#import "CGXSwizzlingExtensionDefine.h"
#import <objc/runtime.h>

static const CGFloat kCGXControlAcceptEventIntervalDefalut  = 0.5;
static const char *UIControl_acceptEventIntervalKey         = "UIControl_acceptEventInterval";
static const char *UIControl_latestEventTimeKey             = "UIControl_latestEventTime";

@interface UIControl ()

@property (nonatomic, assign) NSTimeInterval latestEventTime;

@end

@implementation UIControl (CGXSwizzlingExtension)

+ (void)load {
    swizzling_exchangeMethod([self class] ,@selector(sendAction:to:forEvent:), @selector(swizzling_sendAction:to:forEvent:));
}

- (void)swizzling_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    if (self.acceptEventInterval <= 0 || ([self class] != [UIButton class])) {
        [self swizzling_sendAction:action to:target forEvent:event];
        return;
    }
    
    if (NSDate.date.timeIntervalSince1970 - self.latestEventTime < self.acceptEventInterval) {
        return;
    }
    
    [self swizzling_sendAction:action to:target forEvent:event];
    
    self.latestEventTime = NSDate.date.timeIntervalSince1970;
}

- (NSTimeInterval)acceptEventInterval {
    NSNumber *interval = objc_getAssociatedObject(self, UIControl_acceptEventIntervalKey);
    if (interval) {
        return interval.doubleValue;
    }
    return kCGXControlAcceptEventIntervalDefalut;
}

- (void)setAcceptEventInterval:(NSTimeInterval)acceptEventInterval {
    objc_setAssociatedObject(self, UIControl_acceptEventIntervalKey, @(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)latestEventTime {
    return [objc_getAssociatedObject(self, UIControl_latestEventTimeKey) doubleValue];
}

- (void)setLatestEventTime:(NSTimeInterval)latestEventTime {
    objc_setAssociatedObject(self, UIControl_latestEventTimeKey, @(latestEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
