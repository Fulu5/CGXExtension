//
//  UIAlertController+CGXExtension.m
//  CGXAttempt
//
//  Created by 曹曹 on 2018/1/10.
//  Copyright © 2018年 曹曹. All rights reserved.
//

#import "UIAlertController+CGXExtension.h"

@implementation UIAlertController (CGXExtension)

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
              actionTitles:(NSArray<NSString *> *)actions
               cancelTitle:(NSString *)cancelTitle
                completion:(void(^)(NSInteger index))completion {
    [self showAlertWithTitle:title
                     message:message
                 cancelTitle:cancelTitle
                 cancelStyle:UIAlertActionStyleDefault
                 otherTitles:actions
                       style:UIAlertControllerStyleAlert
                otherHandler:completion
               cancelHandler:nil];
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancelTitle
               cancelStyle:(UIAlertActionStyle)cancelStyle
               otherTitles:(NSArray<NSString *> *)otherTitles
                     style:(UIAlertControllerStyle)style
              otherHandler:(void (^)(NSInteger))otherHandler
             cancelHandler:(dispatch_block_t)cancelHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    for (NSInteger i = 0; i < otherTitles.count; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:otherTitles[i]
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
            !otherHandler ?: otherHandler(i);
        }];
        [alert addAction:action];
    }
    if (cancelTitle.length) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle
                                                         style:cancelStyle
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           !cancelHandler ?: cancelHandler();
                                                       }];
        [alert addAction:cancel];
    }
    UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [vc presentViewController:alert animated:YES completion:nil];
}

@end
