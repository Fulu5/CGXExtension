//
//  UIDevice+CGXExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (CGXExtension)

+ (NSString *)name;
+ (NSString *)model;
+ (NSString *)localizedModel;
+ (NSString *)systemName;
+ (NSString *)systemVersion;
+ (NSString *)deviceModel;

@end
