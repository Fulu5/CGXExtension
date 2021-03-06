//
//  NSNumber+CGXExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (CGXExtension)

- (NSDate *)dateFromSeconds;

- (NSString *)RMBString;
+ (NSString *)RMBStringWithFloat:(float)price;

- (NSString *)priceString;
+ (NSString *)priceStringWithFloat:(float)price;

@end
