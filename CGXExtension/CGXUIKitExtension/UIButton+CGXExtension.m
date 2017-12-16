//
//  UIButton+CGXExtension.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "UIButton+CGXExtension.h"

@implementation UIButton (CGXExtension)

- (void)setImageAlignment:(UIButtonImageAlignment)imageAlignment {
    switch (imageAlignment) {
        case UIButtonImageAlignmentLeft:
        {
            self.transform = CGAffineTransformIdentity;
            self.titleLabel.transform = CGAffineTransformIdentity;
            self.imageView.transform = CGAffineTransformIdentity;
        }
            break;
        case UIButtonImageAlignmentRight:
        {
            self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
            self.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
            self.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        }
            break;
    }
}

@end
