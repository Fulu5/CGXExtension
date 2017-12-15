//
//  UIImage+CGXExtension.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "UIImage+CGXExtension.h"
#import <objc/runtime.h>

static const char *UIImage_block = "UIImage_block";

#pragma mark -  UIGifImageObject.m

@implementation UIGifImageObject

+ (UIGifImageObject *)gifImageObjectWithData:(NSData *)data {
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CGFloat animationTime = 0.f;
    if (src) {
        //Return the number of images
        size_t l = CGImageSourceGetCount(src);
        frames = [NSMutableArray arrayWithCapacity:l];
        for (NSInteger i = 0; i < l; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFDelayTime];
            animationTime += [delayTime floatValue];
            if (img) {
                [frames addObject:[UIImage imageWithCGImage:img]];
                CGImageRelease(img);
            }
        }
        CFRelease(src);
    }
    if (frames.count) {
        UIGifImageObject *object = [UIGifImageObject new];
        object.images = frames;
        object.duration = animationTime;
        return object;
    }
    return nil;
}

+ (UIGifImageObject *)gifImageObjectWithImagePath:(NSString *)imagePath {
    return [self gifImageObjectWithData:[NSData dataWithContentsOfFile:imagePath]];
}

+ (UIGifImageObject *)gifImageObjectWithImageName:(NSString *)imageName {
    return [self gifImageObjectWithImagePath:[[NSBundle mainBundle] pathForResource:imageName ofType:@".gif"]];
}

@end

#pragma mark - UIImage + CGXExtension.h

@interface UIImage ()

@property (nonatomic, copy) void(^saveToPhotosAlbumCompletion)(NSError *error);

@end

#pragma mark - UIImage + CGXExtension.m

@implementation UIImage (CGXExtension)

- (CGFloat)radius {
    return ((self.size.width < self.size.height) ? self.size.width : self.size.height) / 2;
}

- (UIImage *)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, YES, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)tintWithColor:(UIColor *)color {
    UIImage *newImage = [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(newImage.size, NO, newImage.scale);
    [color set];
    [newImage drawInRect:CGRectMake(0, 0, newImage.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)roundedImageWithColor:(UIColor *)color size:(CGSize)size {
    return [[self imageWithColor:color size:size] roundedImage];
}

- (UIImage *)roundedImage {
    return [self roundedWithRadius:self.radius];
}

- (UIImage *)roundedWithRadius:(NSUInteger)radius {
    return [self roundedWithRadius:radius maskType:UIImageRoundedCornerMaskTypeAll];
}

- (UIImage *)roundedWithMaskType:(UIImageRoundedCornerMaskType)maskType {
    return [self roundedWithRadius:self.radius maskType:maskType];
}

- (UIImage *)roundedWithRadius:(NSUInteger)radius maskType:(UIImageRoundedCornerMaskType)maskType {
    CGRect imageRect = CGRectMake(0, 0, self.size.width * self.scale, self.size.height * self.scale);
    radius *= self.scale;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 4 * imageRect.size.width, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    CGXAddRoundedRectToPath(context, imageRect, radius, maskType);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, imageRect, self.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageMasked scale:self.scale orientation:UIImageOrientationUp];
    CGImageRelease(imageMasked);
    return newImage;
}

+ (UIImage *)roundedImageNamed:(NSString *)name {
    return [[self imageNamed:name] roundedImage];
}

+ (UIImage *)imageNamed:(NSString *)name radius:(NSUInteger)radius {
    return [[self imageNamed:name] roundedWithRadius:radius];
}

+ (UIImage *)roundedImageNamed:(NSString *)name maskType:(UIImageRoundedCornerMaskType)maskType {
    UIImage *image = [self imageNamed:name];
    return [image roundedWithRadius:image.radius maskType:maskType];
}

+ (UIImage *)imageNamed:(NSString *)name radius:(NSUInteger)radius maskType:(UIImageRoundedCornerMaskType)maskType {
    return [[self imageNamed:name] roundedWithRadius:radius maskType:maskType];
}

+ (UIImage *)roundedImageWithContentsOfFile:(NSString *)path {
    return [[self roundedImageWithContentsOfFile:path] roundedImage];
}

+ (UIImage *)imageWithContentsOfFile:(NSString *)path radius:(NSUInteger)radius {
    return [[self imageWithContentsOfFile:path] roundedWithRadius:radius];
}

+ (UIImage *)roundedImageWithContentsOfFile:(NSString *)path maskType:(UIImageRoundedCornerMaskType)maskType {
    UIImage *image = [self imageWithContentsOfFile:path];
    return [image roundedWithRadius:image.radius maskType:maskType];
}

+ (UIImage *)imageWithContentsOfFile:(NSString *)path radius:(NSUInteger)radius maskType:(UIImageRoundedCornerMaskType)maskType {
    return [[self imageWithContentsOfFile:path] roundedWithRadius:radius maskType:maskType];
}

#pragma mark - AddRoundedRectToPath

//UIKit坐标系统原点在左上角，y方向向下的（坐标系A），但在Quartz中坐标系原点在左下角，y方向向上的(坐标系B)。图片绘制也是颠倒的。
static void CGXAddRoundedRectToPath(CGContextRef context, CGRect rect, float radius, UIImageRoundedCornerMaskType maskType) {
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
    
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
    
    //如果左上角需要画圆角，画出一个弧线出来。
    if (maskType & UIImageRoundedCornerMaskTypeTopLeft) {
        CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI, M_PI / 2, 1);
    } else {
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
        CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y + rect.size.height);
    }
    
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height);
    
    //画右上角
    if (maskType & UIImageRoundedCornerMaskTypeTopRight) {
        CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
    } else {
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - radius);
    }
    
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
    
    //画右下角弧线
    if (maskType & UIImageRoundedCornerMaskTypeBottomRight) {
        CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI / 2, 1);
    } else {
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, rect.origin.y);
    }
    
    CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
    
    //画左下角弧线
    if (maskType & UIImageRoundedCornerMaskTypeBottomLeft) {
        CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI / 2, M_PI, 1);
    } else {
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + radius);
    }
    
    CGContextClosePath(context);
}

#pragma mark - SaveToPhotosAlbum

- (void)saveToPhotosAlbumWithCompletion:(void (^)(NSError *))completion {
    self.saveToPhotosAlbumCompletion = completion;
    UIImageWriteToSavedPhotosAlbum(self, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(id)contextInfo {
    if (self.saveToPhotosAlbumCompletion) {
        self.saveToPhotosAlbumCompletion(error);
    }
}

- (void (^)(NSError *))saveToPhotosAlbumCompletion {
    return objc_getAssociatedObject(self, UIImage_block);
}

- (void)setSaveToPhotosAlbumCompletion:(void (^)(NSError *))block {
    objc_setAssociatedObject(self, UIImage_block, block, OBJC_ASSOCIATION_COPY);
}

@end
