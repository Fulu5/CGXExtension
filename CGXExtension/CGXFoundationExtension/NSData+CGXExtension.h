//
//  NSData+CGXExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (CGXExtension)

+ (instancetype)dataFromResource:(NSString *)name ofType:(NSString *)ext;

/** 将JSON data转为 Foundation object */
- (id)objectFromJSONData;
+ (id)objectFromJSONDataForResource:(NSString *)name ofType:(NSString *)ext;

- (NSString *)hexString;

@end
