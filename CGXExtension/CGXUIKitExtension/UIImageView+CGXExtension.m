//
//  UIImageView+CGXExtension.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "UIImageView+CGXExtension.h"
#import "UIImageView+WebCache.h"
#import "NSString+CGXExtension.h"
#import "UIImage+CGXExtension.h"

@implementation UIImageView (CGXExtension)

- (void)setImageWithName:(NSString *)name {
    self.image = [UIImage imageNamed:name];
}

- (void)setImageWithURL:(NSString *)url {
    [self sd_setImageWithURL:url.URL];
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(NSString *)placeholderImage {
    [self sd_setImageWithURL:url.URL placeholderImage:placeholderImage.image];
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(NSString *)placeholderImage completion:(void (^)(UIImage *, NSError *, NSURL *))completion {
    [self sd_setImageWithURL:url.URL
            placeholderImage:placeholderImage.image
                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                       if (completion) {
                           completion(image, error, imageURL);
                       }
                   }];
}

- (void)startAnimatingWithGifImageName:(NSString *)gifImageName {
    [self startAnimatingWithGifImageName:gifImageName repeatCount:0];
}

- (void)startAnimatingWithGifImageName:(NSString *)gifImageName repeatCount:(NSUInteger)repeatCount {
    [self startAnimatingWithGifImagePath:[[NSBundle mainBundle] pathForResource:gifImageName ofType:@".gif"] repeatCount:repeatCount];
}

- (void)startAnimatingWithGifImagePath:(NSString *)gifImagePath {
    [self startAnimatingWithGifImagePath:gifImagePath repeatCount:0];
}

- (void)startAnimatingWithGifImagePath:(NSString *)gifImagePath repeatCount:(NSUInteger)repeatCount {
    UIGifImageObject *object = [UIGifImageObject gifImageObjectWithImagePath:gifImagePath];
    [self startAnimatingWithImages:object.images duration:object.duration repeatCount:repeatCount];
}

- (void)startAnimatingWithImages:(NSArray<UIImage *> *)images duration:(CGFloat)duration {
    [self startAnimatingWithImages:images duration:duration repeatCount:0];
}

- (void)startAnimatingWithImages:(NSArray<UIImage *> *)images duration:(CGFloat)duration repeatCount:(NSUInteger)repeatCount {
    if (!images.count) {
        return;
    }
    self.animationImages = images;
    self.animationDuration = duration;
    self.animationRepeatCount = repeatCount;
    [self startAnimating];
}

@end
