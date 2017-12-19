//
//  CGXNetworkResult.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/19.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "CGXNetworkResult.h"
#import "CGXExtensionDefine.h"
#import "NSObject+CGXExtension.h"

@interface CGXNetworkResult ()

//如果不等于0 则说明返回错误
@property (nonatomic, assign) NSInteger code;
//返回信息
@property (nonatomic, copy) NSString *message;
//返回错误
@property (nonatomic, strong) NSError *error;
/** 服务器返回的完整数据*/
@property (nonatomic, strong) NSDictionary *returnedDictionary;
//服务器返回的data数据
@property (nonatomic, strong) NSDictionary *data;

@end

@implementation CGXNetworkResult

+ (instancetype)resultWithDictionary:(NSDictionary *)dictionary {
    
    CGXNetworkResult *result = [CGXNetworkResult new];
    
    result.returnedDictionary = dictionary;
    
    if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
        
        result.code     = CGXExtensionErrorCodeServerError;
        result.message  = @"服务器返回数据格式错误";
        result.error    = [NSError errorWithDomain:kCGXExtensionErrorDomain code:result.code userInfo:@{NSLocalizedDescriptionKey : result.message}];
        
        return result;
    }
    
    NSNumber *code = [dictionary objectForKey:kNetworkReturnCodeKey];
    
    if (!code || ![code isKindOfClass:[NSNumber class]]) {
        
        result.code     = CGXExtensionErrorCodeServerError;
        result.message  = @"服务器未返回code字段";
        result.error    = [NSError errorWithDomain:kCGXExtensionErrorDomain code:result.code userInfo:@{NSLocalizedDescriptionKey : result.message}];
        
        return result;
    }
    
    result.code     = CGXExtensionErrorCodeSuccess;
    result.message  = [dictionary objectForKey:kNetworkReturnMessageKey] ?: @"成功";
    result.error    = nil;
    
    NSDictionary *data = [dictionary objectForKey:kNetworkReturnDataKey];
    
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        result.data = data;
    }
    
    return result;
}

#pragma mark - List

- (NSUInteger)size {
    return [self unsignedIntegerValueForKeyPath:kNetworkReturnSizeKey];
}

- (NSUInteger)count {
    return [self unsignedIntegerValueForKeyPath:kNetworkReturnCountKey];
}

- (NSUInteger)offset {
    return [self unsignedIntegerValueForKeyPath:kNetworkReturnOffsetKey];
}

- (NSArray *)list {
    NSArray *list = [self.data objectForKey:kNetworkReturnListKey];
    if (!list || ![list isKindOfClass:[NSArray class]] || !list.count) {
        return nil;
    }
    return list;
}

- (id)model:(Class)clazz {
    if (!self.data) {
        return nil;
    }
    return [clazz objectWithData:self.data];
}

- (id)model:(Class)clazz atKeyPath:(NSString *)keyPath {
    NSDictionary *model = [self.data objectForKey:keyPath];
    if (!model || ![model isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [clazz objectWithData:model];
}

- (NSArray *)arrayOfModel:(Class)clazz {
    if (!self.list) {
        return nil;
    }
    return [clazz objectArrayWithDictionaryArray:self.list];
}

- (NSArray *)arrayOfModel:(Class)clazz atKeyPath:(NSString *)keyPath {
    NSArray *list = [self.data objectForKey:keyPath];
    if (!list || ![list isKindOfClass:[NSArray class]]) {
        return nil;
    }
    return [clazz objectArrayWithDictionaryArray:list];
}

#pragma mark - Private

- (NSUInteger)unsignedIntegerValueForKeyPath:(NSString *)keyPath {
    NSNumber *number = [self.data objectForKey:keyPath];
    if (!number || ![number isKindOfClass:[NSNumber class]]) {
        return 0;
    }
    return number.unsignedIntegerValue;
}

@end
