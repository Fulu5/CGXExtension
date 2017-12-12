//
//  UITableViewCell+CGXExtension.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "UITableViewCell+CGXExtension.h"

@implementation UITableViewCell (CGXExtension)

- (CGFloat)autoLayoutHeight {
    /**
     由于是contentView调用，返回的是contentView的高度
     cell高度比contentView高度多1，也就是分割线的高度
     所以需要加上1才是最终cell的高度
     */
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    /**
     如果cell中使用了UITextView
     由于systemLayoutSizeFittingSize并没有把textView的高度计算在内
     所以需要单独计算textView的高度，并加上contentView的高度
     */
}

@end
