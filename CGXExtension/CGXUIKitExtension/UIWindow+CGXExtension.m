//
//  UIWindow+CGXExtension.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "UIWindow+CGXExtension.h"

@implementation UIWindow (CGXExtension)

+ (UIWindow *)window {
    return [[UIApplication sharedApplication].delegate window];
}

+ (UIViewController *)rootViewController {
    return [[self window] rootViewController];
}

@end
