//
//  NSArray+CGXExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CGXExtension)

/** 将数组转为 JSON data */
- (NSData *)JSONData;
/** 将数组转为 JSON string */
- (NSString *)JSONString;
/** 将JSON string 转为数组 */
+ (NSArray *)arrayWithJSONString:(NSString *)JSONString;

@end
