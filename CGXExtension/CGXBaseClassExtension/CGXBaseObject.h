//
//  CGXBaseObject.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGXBaseObject : NSObject

//属性名称和接口返回值名称的对应关系  @{@"属性名称" : @"返回值名称"}
//如果对象属性包含数组  则对应关系为 @{@"属性名称" : @{@"返回值名称" : [xxx class]}}
- (NSDictionary *)propertyMap;

@end
