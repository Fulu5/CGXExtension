//
//  CGXMacroExtensionHeader.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

/*--------------------------------开发中常用到的宏定义--------------------------------------*/

//系统目录
#define kDocuments          ((NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject])
#define kCaches             ((NSString *)[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject])
#define kLibrary            ((NSString *)[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0])
#define kTemp               ((NSString *)[NSString stringWithFormat:@"%@/temp", kCaches])

//屏幕尺寸
#define kScreenWidth        ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight       ([UIScreen mainScreen].bounds.size.height)

//设备尺寸判断
#define kDevice_Is_iPhone4Size         (CGSizeEqualToSize(CGSizeMake(640, 960), [UIScreen mainScreen].bounds.size))
#define kDevice_Is_iPhone5Size         (CGSizeEqualToSize(CGSizeMake(640, 1136), [UIScreen mainScreen].bounds.size))
#define kDevice_Is_iPhone6Size         (CGSizeEqualToSize(CGSizeMake(750, 1334), [UIScreen mainScreen].bounds.size))
#define kDevice_Is_iPhone6PlusSize     (CGSizeEqualToSize(CGSizeMake(1242, 2208), [UIScreen mainScreen].bounds.size))
#define kDevice_Is_iPhoneXSize         (CGSizeEqualToSize(CGSizeMake(1125, 2436), [UIScreen mainScreen].bounds.size))

/** 设置颜色值：UIColorFromHex(0x067AB5) */
#define UIColorFromHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

//GCD相关方法
#define kGCDBackground(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define kGCDMain(block)       dispatch_async(dispatch_get_main_queue(),block)

//SharedInstance
#define SharedInstanceDeclare + (instancetype)sharedInstance;
#define SharedInstanceImplementation \
+ (instancetype)sharedInstance { \
static id sharedInstance = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
sharedInstance = [self new]; \
}); \
return sharedInstance; \
}

/**
 弱引用 - YYKitMacro.h

 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 }];
 
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif
