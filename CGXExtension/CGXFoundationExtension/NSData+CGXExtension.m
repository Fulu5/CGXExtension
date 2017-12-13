//
//  NSData+CGXExtension.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "NSData+CGXExtension.h"

@implementation NSData (CGXExtension)

+ (instancetype)dataFromResource:(NSString *)name ofType:(NSString *)ext {
    return [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:ext]];
}

- (id)objectFromJSONData {
    return [NSJSONSerialization JSONObjectWithData:self options:0 error:nil];
}

+ (id)objectFromJSONDataForResource:(NSString *)name ofType:(NSString *)ext {
    return [NSData dataFromResource:name ofType:ext].objectFromJSONData;
}

- (NSString *)hexString {
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    
    if (!dataBuffer) {
        return nil;
    }
    
    NSUInteger dataLength  = [self length];
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i) {
        [hexString appendFormat:@"%02x", (unsigned int)dataBuffer[i]];
    }
    
    return hexString;
}

@end
