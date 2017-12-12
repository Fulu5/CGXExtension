//
//  UIView+CGXExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CGXExtension)

@property(nonatomic, assign) CGFloat orginX;
@property(nonatomic, assign) CGFloat orginY;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@property(nonatomic, assign) CGPoint origin;
@property(nonatomic, assign) CGSize size;

/** 设置 cornerRadius */
- (void)setCornerWidth:(CGFloat)width;
/** 设置边界颜色和宽度 */
- (void)setBorderColor:(UIColor *)color width:(CGFloat)width;

@end
