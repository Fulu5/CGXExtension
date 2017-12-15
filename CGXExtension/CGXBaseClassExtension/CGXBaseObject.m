//
//  CGXBaseObject.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "CGXBaseObject.h"

@implementation CGXBaseObject

- (NSDictionary *)propertyMap {
    //子类需要覆盖此方法
    //详情见 NSObject+CGXExtension.m - line 294
    return nil;
}

@end
