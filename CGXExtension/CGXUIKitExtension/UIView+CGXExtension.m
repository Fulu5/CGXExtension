//
//  UIView+CGXExtension.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "UIView+CGXExtension.h"

@implementation UIView (CGXExtension)

- (void)setOrginX:(CGFloat)orginX {
    CGRect frame = self.frame;
    frame.origin.x = orginX;
    self.frame = frame;
}

- (CGFloat)orginX {
    return self.frame.origin.x;
}

- (void)setOrginY:(CGFloat)orginY {
    CGRect frame = self.frame;
    frame.origin.y = orginY;
    self.frame = frame;
}

- (CGFloat)orginY {
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setCornerWidth:(CGFloat)width {
    self.layer.cornerRadius = width;
    self.layer.masksToBounds = YES;
}

- (void)setBorderColor:(UIColor *)color width:(CGFloat)width {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

@end
