//
//  CGXHUDManager.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "CGXHUDManager.h"

static NSTimeInterval const minHUDShowDuration = 1;
static NSTimeInterval const maxHUDShowDuration = 3;

@implementation CGXHUDManager

+ (void)showWithDuration:(CGFloat)duration {
    [self showWithDuration:duration completion:nil];
}

+ (void)showWithDuration:(CGFloat)duration completion:(dispatch_block_t)completion {
    [self show];
    [self dismissWithDelay:duration completion:completion];
}

+ (void)showWithtitle:(NSString *)title duration:(CGFloat)duration {
    [self showWithtitle:title duration:duration completion:nil];
}

+ (void)showWithtitle:(NSString *)title duration:(CGFloat)duration completion:(dispatch_block_t)completion {
    [self showWithStatus:title];
    [self dismissWithDelay:duration completion:completion];
}

+ (void)showAndAutoDismissWithtitle:(NSString *)title {
    [self showAndAutoDismissWithtitle:title completion:nil];
}

+ (void)showAndAutoDismissWithtitle:(NSString *)title completion:(dispatch_block_t)completion {
    [self showWithStatus:title];
    [self dismissWithDelay:[self displayDurationForString:title] completion:completion];
}

+ (void)showSuccessWithTitle:(NSString *)title duration:(CGFloat)duration {
    [self showSuccessWithTitle:title duration:duration completion:nil];
}

+ (void)showSuccessWithTitle:(NSString *)title duration:(CGFloat)duration completion:(dispatch_block_t)completion {
    [self showSuccessWithStatus:title];
    [self dismissWithDelay:duration completion:completion];
}

+ (void)showSuccessAndAutoDismissWithTitle:(NSString *)title {
    [self showSuccessAndAutoDismissWithTitle:title completion:nil];
}

+ (void)showSuccessAndAutoDismissWithTitle:(NSString *)title completion:(dispatch_block_t)completion {
    [self showSuccessWithTitle:title duration:[self displayDurationForString:title] completion:completion];
}

+ (void)showErrorWithTitle:(NSString *)title duration:(CGFloat)duration {
    [self showErrorWithTitle:title duration:duration completion:nil];
}

+ (void)showErrorWithTitle:(NSString *)title duration:(CGFloat)duration completion:(dispatch_block_t)completion {
    [self showErrorWithStatus:title];
    [self dismissWithDelay:duration completion:completion];
}

+ (void)showErrorAndAutoDismissWithTitle:(NSString *)title {
    [self showErrorAndAutoDismissWithTitle:title completion:nil];
}

+ (void)showErrorAndAutoDismissWithTitle:(NSString *)title completion:(dispatch_block_t)completion {
    [self showErrorWithStatus:title];
    [self dismissWithDelay:[self displayDurationForString:title] completion:completion];
}

#pragma mark - 根据文本长度返回HUD展示时间

+ (NSTimeInterval)displayDurationForString:(NSString *)string {
    NSTimeInterval duration = 0.5 + (string.length * 0.15);
    CGFloat min = MAX(minHUDShowDuration, duration);
    return MIN(min, maxHUDShowDuration);
}

@end
