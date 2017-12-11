//
//  CGXExtensionDefine.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#define kCGXExtensionErrorDomain [[NSBundle mainBundle] bundleIdentifier]

typedef NS_ENUM(NSInteger, CGXExtensionErrorCode) {
    CGXExtensionErrorCodeUndefine     = -1      ,   //未定义
    CGXExtensionErrorCodeSuccess      = 0       ,   //成功
    CGXExtensionErrorCodeServerError  = 500     ,   //服务器内部错误
    CGXExtensionErrorCodeLostNetwork  = -100    ,   //当前无网络
    CGXExtensionErrorCodeInputError   = 100     ,   //输入错误
    CGXExtensionErrorCodeCancelled    = -999    ,   //用户取消
};
