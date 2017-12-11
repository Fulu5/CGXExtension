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
