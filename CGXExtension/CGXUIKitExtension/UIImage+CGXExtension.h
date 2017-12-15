//
//  UIImage+CGXExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - UIGifImageObject.h

typedef NS_ENUM(NSInteger, UIImageRoundedCornerMaskType) {
    UIImageRoundedCornerMaskTypeTopLeft         = 1,
    UIImageRoundedCornerMaskTypeTopRight        = 1 << 1,
    UIImageRoundedCornerMaskTypeBottomRight     = 1 << 2,
    UIImageRoundedCornerMaskTypeBottomLeft      = 1 << 3,
    UIImageRoundedCornerMaskTypeAll             = UIImageRoundedCornerMaskTypeTopLeft | UIImageRoundedCornerMaskTypeTopRight | UIImageRoundedCornerMaskTypeBottomRight | UIImageRoundedCornerMaskTypeBottomLeft,
};

@interface UIGifImageObject : NSObject

@property (nonatomic, strong) NSArray<UIImage *> *images;
@property (nonatomic, assign) CGFloat duration;

+ (UIGifImageObject *)gifImageObjectWithData:(NSData *)data;
+ (UIGifImageObject *)gifImageObjectWithImagePath:(NSString *)imagePath;
+ (UIGifImageObject *)gifImageObjectWithImageName:(NSString *)imageName;

@end

#pragma mark - UIImage + CGXExtension.h

@interface UIImage (CGXExtension)

- (CGFloat)radius;

- (UIImage *)scaleToSize:(CGSize)size;

/** 设置 image 颜色*/
- (UIImage *)tintWithColor:(UIColor *)color;
/** 获取纯色图 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
/** 获取圆形纯色图*/
+ (UIImage *)roundedImageWithColor:(UIColor *)color size:(CGSize)size;

/** 切圆 */
- (UIImage *)roundedImage;
/** 设置图片裁剪固定弧度 */
- (UIImage *)roundedWithRadius:(NSUInteger)radius;
/** 给某个角切圆 */
- (UIImage *)roundedWithMaskType:(UIImageRoundedCornerMaskType)maskType;
/** 给某个角加弧度 */
- (UIImage *)roundedWithRadius:(NSUInteger)radius maskType:(UIImageRoundedCornerMaskType)maskType;

/** 获取图片并切圆 */
+ (UIImage *)roundedImageNamed:(NSString *)name;
/** 获取图片并裁剪固定弧度 */
+ (UIImage *)imageNamed:(NSString *)name radius:(NSUInteger)radius;
/** 获取图片并给某个角切圆 */
+ (UIImage *)roundedImageNamed:(NSString *)name maskType:(UIImageRoundedCornerMaskType)maskType;
/** 获取图片并给某个角裁剪固定弧度 */
+ (UIImage *)imageNamed:(NSString *)name radius:(NSUInteger)radius maskType:(UIImageRoundedCornerMaskType)maskType;

/** 获取图片并切圆 */
+ (UIImage *)roundedImageWithContentsOfFile:(NSString *)path;
/** 获取图片并裁剪固定弧度 */
+ (UIImage *)imageWithContentsOfFile:(NSString *)path radius:(NSUInteger)radius;
/** 获取图片并给某个角切圆 */
+ (UIImage *)roundedImageWithContentsOfFile:(NSString *)path maskType:(UIImageRoundedCornerMaskType)maskType;
/** 获取图片并给某个角裁剪固定弧度 */
+ (UIImage *)imageWithContentsOfFile:(NSString *)path radius:(NSUInteger)radius maskType:(UIImageRoundedCornerMaskType)maskType;

/** 保存图片到相册(必须拥有权限) */
- (void)saveToPhotosAlbumWithCompletion:(void (^)(NSError *error))completion;

@end
