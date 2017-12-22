//
//  NSDateFormatter+CGXExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (CGXExtension)

/** yyyy-MM-dd */
+ (NSDateFormatter *)defaultDateFormatter;
/** yyyy-MM-dd HH:mm:ss */
+ (NSDateFormatter *)defaultDatetimeFormatter;
/** yyyy-MM-dd HH:mm */
+ (NSDateFormatter *)defaultDatetimeWithoutSecondsFormatter;

+ (NSDateFormatter *)dateFormatterForGMT;
+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)dateFormat;

@end
