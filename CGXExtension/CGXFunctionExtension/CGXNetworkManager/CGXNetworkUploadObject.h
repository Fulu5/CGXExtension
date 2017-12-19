//
//  CGXNetworkUploadObject.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/19.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGXNetworkUploadObject : NSObject

//required
@property (nonatomic, copy) NSString *paramName;
@property (nonatomic, strong) id file;

//optional
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *fileType;
@property (nonatomic, assign) float imageQuality;

@end
