//
//  CGXNetworkUploadObject.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/19.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "CGXNetworkUploadObject.h"

@implementation CGXNetworkUploadObject

- (NSString *)fileName {
    if (!_fileName) {
        _fileName = @"";
    }
    return _fileName;
}

- (NSString *)fileType {
    if (!_fileType) {
        _fileType = @"image/jpeg";
    }
    return _fileType;
}

- (float)imageQuality {
    if ((_imageQuality <= 0) || (_imageQuality > 1)) {
        _imageQuality = 0.1;
    }
    return _imageQuality;
}

@end
