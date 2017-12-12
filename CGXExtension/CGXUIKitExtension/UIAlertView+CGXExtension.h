//
//  UIAlertView+CGXExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CGXExtensionAlertViewDismissBlock)(NSInteger buttonIndex);
typedef void (^CGXExtensionAlertViewCancelBlock)(void);

@interface UIAlertView (CGXExtension)

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                      otherButtonTitles:(NSArray<NSString *> *)otherButtons
                              onDismiss:(CGXExtensionAlertViewDismissBlock)dismissed
                               onCancel:(CGXExtensionAlertViewCancelBlock)cancelled;

//在需要关闭时执行返回的block
+ (dispatch_block_t)alertCustomView:(UIView *)view;

@end
