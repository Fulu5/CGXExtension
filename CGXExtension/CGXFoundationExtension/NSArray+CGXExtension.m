//
//  NSArray+CGXExtension.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "NSArray+CGXExtension.h"
#import "NSString+CGXExtension.h"

@implementation NSArray (CGXExtension)

- (NSData *)JSONData {
    return [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
}

- (NSString *)JSONString {
    return [[NSString alloc] initWithData:[self JSONData] encoding:NSUTF8StringEncoding];
}

+ (NSArray *)arrayWithJSONString:(NSString *)JSONString {
    return [JSONString objectFromJSONString];
}

@end
