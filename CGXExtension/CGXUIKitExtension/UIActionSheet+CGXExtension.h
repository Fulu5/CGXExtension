//
//  UIActionSheet+CGXExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"

typedef void (^UIActionSheetBlock) (UIActionSheet * __nonnull actionSheet);
typedef void (^UIActionSheetCompletionBlock) (UIActionSheet * __nonnull actionSheet, NSInteger buttonIndex);

@interface UIActionSheet (CGXExtension)

@property (copy, nonatomic, nullable) UIActionSheetCompletionBlock tapBlock;
@property (copy, nonatomic, nullable) UIActionSheetCompletionBlock willDismissBlock;
@property (copy, nonatomic, nullable) UIActionSheetCompletionBlock didDismissBlock;

@property (copy, nonatomic, nullable) UIActionSheetBlock willPresentBlock;
@property (copy, nonatomic, nullable) UIActionSheetBlock didPresentBlock;
@property (copy, nonatomic, nullable) UIActionSheetBlock cancelBlock;


+ (nonnull instancetype)showFromTabBar:(nonnull UITabBar *)tabBar
                             withTitle:(nullable NSString *)title
                     cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                     otherButtonTitles:(nullable NSArray *)otherButtonTitles
                              tapBlock:(nullable UIActionSheetCompletionBlock)tapBlock;

+ (nonnull instancetype)showFromToolbar:(nonnull UIToolbar *)toolbar
                              withTitle:(nullable NSString *)title
                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                 destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                      otherButtonTitles:(nullable NSArray *)otherButtonTitles
                               tapBlock:(nullable UIActionSheetCompletionBlock)tapBlock;

+ (nonnull instancetype)showInView:(nonnull UIView *)view
                         withTitle:(nullable NSString *)title
                 cancelButtonTitle:(nullable NSString *)cancelButtonTitle
            destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                 otherButtonTitles:(nullable NSArray *)otherButtonTitles
                          tapBlock:(nullable UIActionSheetCompletionBlock)tapBlock;

+ (nonnull instancetype)showFromBarButtonItem:(nonnull UIBarButtonItem *)barButtonItem
                                     animated:(BOOL)animated
                                    withTitle:(nullable NSString *)title
                            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                       destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                            otherButtonTitles:(nullable NSArray *)otherButtonTitles
                                     tapBlock:(nullable UIActionSheetCompletionBlock)tapBlock;

+ (nonnull instancetype)showFromRect:(CGRect)rect
                              inView:(nonnull UIView *)view
                            animated:(BOOL)animated
                           withTitle:(nullable NSString *)title
                   cancelButtonTitle:(nullable NSString *)cancelButtonTitle
              destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                   otherButtonTitles:(nullable NSArray *)otherButtonTitles
                            tapBlock:(nullable UIActionSheetCompletionBlock)tapBlock;

#pragma clang diagnostic pop

@end
