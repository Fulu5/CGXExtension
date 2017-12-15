//
//  CGXCommonFunction.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "CGXCommonFunction.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define CGXCommonFunctionUserDefaultsKey(key, account) (account?[NSString stringWithFormat:@"%@_%@",key,account]:key)

@implementation CGXCommonFunction

#pragma mark - User Defaults

+ (void)setUserDefaultsVlaue:(id)value forKey:(NSString *)key {
    [self setUserDefaultsVlaue:value forKey:key account:nil];
}

+ (void)setUserDefaultsVlaue:(id)value forKey:(NSString *)key account:(NSString *)account {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (value == nil) {
        [ud removeObjectForKey:CGXCommonFunctionUserDefaultsKey(key, account)];
    } else {
        [ud setObject:value forKey:CGXCommonFunctionUserDefaultsKey(key, account)];
    }
    [ud synchronize];
}

+ (id)userDefauletsValueForKey:(NSString *)key {
    return [self userDefauletsValueForKey:key account:nil];
}

+ (id)userDefauletsValueForKey:(NSString *)key account:(NSString *)account {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:CGXCommonFunctionUserDefaultsKey(key, account)];
}

+ (void)setOpened:(NSString *)key {
    [self setOpened:key forAccount:nil];
}

+ (void)setOpened:(NSString *)key forAccount:(NSString *)account {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:CGXCommonFunctionUserDefaultsKey(key, account)];
    [ud synchronize];
}

+ (BOOL)isFirstOpen:(NSString *)key {
    return [self isFirstOpen:key forAccount:nil];
}

+ (BOOL)isFirstOpen:(NSString *)key forAccount:(NSString *)account {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return ![ud boolForKey:CGXCommonFunctionUserDefaultsKey(key, account)];
}

#pragma mark - Calculate Time Cost

+ (void)calculate:(dispatch_block_t)doSth done:(void (^)(double))done {
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    if (doSth) {
        doSth();
    }
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    if (done) {
        done(end - start);
    }
}

#pragma mark - MIMEType & UTI

+ (NSString *)UTIForExtention:(NSString *)extention {
    if (!extention.length) {
        return nil;
    }
    return (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)(extention), NULL);
}

+ (NSString *)MIMETypeForExtention:(NSString *)extention {
    return [self MIMETypeForUTI:[self UTIForExtention:extention]];
}

+ (NSString *)extentionForUTI:(NSString *)UTI {
    if (!UTI.length) {
        return nil;
    }
    return (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassFilenameExtension);
}

+ (NSString *)extentionForMIMEType:(NSString *)MIMEType {
    return [self extentionForUTI:[self UTIForMIMEType:MIMEType]];
}

+ (NSString *)UTIForMIMEType:(NSString *)MIMEType {
    if (!MIMEType.length) {
        return nil;
    }
    return (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)MIMEType, NULL);
}

+ (NSString *)MIMETypeForUTI:(NSString *)UTI {
    if (!UTI.length) {
        return nil;
    }
    return (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
}

@end
