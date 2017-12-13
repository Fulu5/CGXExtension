//
//  NSNumber+CGXExtension.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "NSNumber+CGXExtension.h"
#import "NSString+CGXExtension.h"

@implementation NSNumber (CGXExtension)

- (NSDate *)dateFromSeconds {
    return [NSDate dateWithTimeIntervalSince1970:self.doubleValue];
}

- (NSString *)RMBString {
    return self.stringValue.RMBString;
}

+ (NSString *)RMBStringWithFloat:(float)price {
    return @(price).RMBString;
}

- (NSString *)priceString {
    return self.stringValue.priceString;
}

+ (NSString *)priceStringWithFloat:(float)price {
    return @(price).priceString;
}

@end
