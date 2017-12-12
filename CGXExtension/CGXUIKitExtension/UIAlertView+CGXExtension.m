//
//  UIAlertView+CGXExtension.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "UIAlertView+CGXExtension.h"
#import "CustomIOSAlertView.h"

static CGXExtensionAlertViewDismissBlock _dismissBlock;
static CGXExtensionAlertViewCancelBlock _cancelBlock;

@implementation UIAlertView (CGXExtension)

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                      otherButtonTitles:(NSArray<NSString *> *)otherButtons
                              onDismiss:(CGXExtensionAlertViewDismissBlock)dismissed
                               onCancel:(CGXExtensionAlertViewCancelBlock)cancelled {
    
    _dismissBlock = dismissed;
    _cancelBlock = cancelled;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:[self self]
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    for (NSString *title in otherButtons) {
        [alert addButtonWithTitle:title];
    }
    [alert show];
    return alert;
}

+ (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger) buttonIndex {
    if(buttonIndex == [alertView cancelButtonIndex]) {
        if (_cancelBlock) {
            _cancelBlock();
        }
    } else {
        if (_dismissBlock) {
            _dismissBlock(buttonIndex - 1); // cancel button is button 0
        }
    }
}

+(dispatch_block_t)alertCustomView:(UIView *)view {
    CustomIOSAlertView *customAlertView = [CustomIOSAlertView new];
    [customAlertView setButtonTitles:nil];
    [customAlertView setContainerView:view];
    [customAlertView setUseMotionEffects:TRUE];
    [customAlertView show];
    return ^{
        [customAlertView close];
    };
}

@end
