//
//  NSDictionary+CGXExtension.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "NSDictionary+CGXExtension.h"
#import "NSString+CGXExtension.h"

@implementation NSDictionary (CGXExtension)

- (NSData *)JSONData {
    return [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
}

- (NSString *)JSONString {
    return [[NSString alloc] initWithData:[self JSONData] encoding:NSUTF8StringEncoding];
}

- (NSString *)JSONPrettyStringEncoded {
    NSString *logString;
    @try {
        
        logString=[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        
    } @catch (NSException *exception) {
        
        NSString *reason = [NSString stringWithFormat:@"reason:%@",exception.reason];
        logString = [NSString stringWithFormat:@"转换失败:\n%@,\n转换终止,输出如下:\n%@",reason,self.description];
        
    } @finally {
        
    }
    return logString;
}

+ (NSDictionary *)dictionaryWithJSONString:(NSString *)JSONString {
    return [JSONString objectFromJSONString];
}

- (NSString *)sortedKeyValueString {
    if (!self.count) {
        return nil;
    }
    
    NSArray *arrKeys = [self.allKeys copy];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    
    arrKeys = [arrKeys sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSString *sortedString = @"";
    
    for (NSString *aKey in arrKeys) {
        sortedString = [sortedString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",aKey,[self objectForKey:aKey]]];
    }
    
    return [sortedString substringToIndex:(sortedString.length - 1)];
}

@end
