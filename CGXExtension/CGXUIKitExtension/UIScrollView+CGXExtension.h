//
//  UIScrollView+CGXExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CGXLoadStatus) {
    CGXLoadStatusLoading    = 1,
    CGXLoadStatusSuccess    = 2,
    CGXLoadStatusEmpty      = 3,
    CGXLoadStatusFailed     = 4,
};

@interface UIScrollView (CGXExtension)

- (void)triggerLoading;
- (void)setStatusSuccess;
- (void)setStatusFail;
- (void)setStatusEmpty;

- (void)noticeFooterNoMoreData;

//无 pullLoadingBlock 时 此方法无效
- (void)addLoadStatusViewWithPullLoadingBlock:(dispatch_block_t)pullLoadingBlock footerLoadingBlock:(dispatch_block_t)footerLoadingBlock;

//仅 YXDLoadStatusEmpty 和 YXDLoadStatusFailed 有效
- (void)setTitle:(NSString *)title imageName:(NSString *)imageName forStatus:(CGXLoadStatus)status;

@end
