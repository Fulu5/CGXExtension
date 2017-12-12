//
//  UIApplication+CGXExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (CGXExtension)

+ (NSString *)bundleIdentifier;
+ (NSString *)appName;
+ (NSString *)appVersion;
+ (NSString *)buildVersion;

+ (UIImage *)appIcon;

+ (void)callPhone:(NSString *)phone;

@end
