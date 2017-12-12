//
//  NSDateFormatter+CGXExtension.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "NSDateFormatter+CGXExtension.h"

@implementation NSDateFormatter (CGXExtension)

+ (NSDateFormatter *)defaultDateFormatter {
    return [self dateFormatterWithFormat:@"yyyy-MM-dd"];
}

+ (NSDateFormatter *)defaultDatetimeFormatter {
    return [self dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDateFormatter *)defaultDatetimeWithoutSecondsFormatter {
    return [self dateFormatterWithFormat:@"yyyy-MM-dd HH:mm"];
}

+ (NSDateFormatter *)dateFormatterForGMT {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss 'GMT'"];
    return dateFormatter;
}

+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}

@end
