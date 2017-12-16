//
//  UIButton+CGXExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIButtonImageAlignment) {
    UIButtonImageAlignmentLeft  = 0,//default
    UIButtonImageAlignmentRight = 1,
};

@interface UIButton (CGXExtension)

/** 设置 UIButton 图片位置*/
- (void)setImageAlignment:(UIButtonImageAlignment)imageAlignment;

@end
