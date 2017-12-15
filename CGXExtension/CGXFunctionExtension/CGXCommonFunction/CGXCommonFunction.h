//
//  CGXCommonFunction.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGXCommonFunction : NSObject

#pragma mark - User Defaults

+ (void)setUserDefaultsVlaue:(id)value forKey:(NSString *)key;
+ (void)setUserDefaultsVlaue:(id)value forKey:(NSString *)key account:(NSString *)account;

+ (id)userDefauletsValueForKey:(NSString *)key;
+ (id)userDefauletsValueForKey:(NSString *)key account:(NSString *)account;

+ (void)setOpened:(NSString *)key;
+ (void)setOpened:(NSString *)key forAccount:(NSString *)account;

+ (BOOL)isFirstOpen:(NSString *)key;
+ (BOOL)isFirstOpen:(NSString *)key forAccount:(NSString *)account;

#pragma mark - Calculate Time Cost

+ (void)calculate:(dispatch_block_t)doSth done:(void (^)(double timeCost))done;

#pragma mark - MIMEType & UTI

+ (NSString *)UTIForExtention:(NSString *)extention;
+ (NSString *)MIMETypeForExtention:(NSString *)extention;

+ (NSString *)extentionForUTI:(NSString *)UTI;
+ (NSString *)extentionForMIMEType:(NSString *)MIMEType;

+ (NSString *)UTIForMIMEType:(NSString *)MIMEType;
+ (NSString *)MIMETypeForUTI:(NSString *)UTI;

@end
