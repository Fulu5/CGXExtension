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
