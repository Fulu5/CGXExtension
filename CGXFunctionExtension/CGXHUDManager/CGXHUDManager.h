//
//  CGXHUDManager.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "SVProgressHUD.h"

@interface CGXHUDManager : SVProgressHUD

+ (void)showWithDuration:(CGFloat)duration;
+ (void)showWithDuration:(CGFloat)duration completion:(dispatch_block_t)completion;

+ (void)showWithtitle:(NSString *)title duration:(CGFloat)duration;
+ (void)showWithtitle:(NSString *)title duration:(CGFloat)duration completion:(dispatch_block_t)completion;

+ (void)showAndAutoDismissWithtitle:(NSString *)title;
+ (void)showAndAutoDismissWithtitle:(NSString *)title completion:(dispatch_block_t)completion;

+ (void)showSuccessWithTitle:(NSString *)title duration:(CGFloat)duration;
+ (void)showSuccessWithTitle:(NSString *)title duration:(CGFloat)duration completion:(dispatch_block_t)completion;

+ (void)showSuccessAndAutoDismissWithTitle:(NSString *)title;
+ (void)showSuccessAndAutoDismissWithTitle:(NSString *)title completion:(dispatch_block_t)completion;

+ (void)showErrorWithTitle:(NSString *)title duration:(CGFloat)duration;
+ (void)showErrorWithTitle:(NSString *)title duration:(CGFloat)duration completion:(dispatch_block_t)completion;

+ (void)showErrorAndAutoDismissWithTitle:(NSString *)title;
+ (void)showErrorAndAutoDismissWithTitle:(NSString *)title completion:(dispatch_block_t)completion;


@end
