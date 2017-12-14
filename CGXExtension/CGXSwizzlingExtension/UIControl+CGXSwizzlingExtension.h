//
//  UIControl+CGXSwizzlingExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (CGXSwizzlingExtension)

/** 设置UIControl的响应时间间隔,默认0.5s */
@property (nonatomic, assign) NSTimeInterval acceptEventInterval;

@end
