//
//  NSDictionary+CGXExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CGXExtension)

/** 将字典转为 JSON data */
- (NSData *)JSONData;
/** 将字典转为字符串 */
- (NSString *)JSONString;

+ (NSDictionary *)dictionaryWithJSONString:(NSString *)JSONString;

/** 将 key,value 排序后拼接成字符串 */
- (NSString *)sortedKeyValueString;

@end
