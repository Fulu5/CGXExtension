//
//  UIImageView+CGXExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CGXExtension)

- (void)setImageWithName:(NSString *)name;

- (void)setImageWithURL:(NSString *)url;
- (void)setImageWithURL:(NSString *)url placeholderImage:(NSString *)placeholderImage;
- (void)setImageWithURL:(NSString *)url placeholderImage:(NSString *)placeholderImage completion:(void (^)(UIImage *image, NSError *error, NSURL *imageURL))completion;

- (void)startAnimatingWithGifImageName:(NSString *)gifImageName;
- (void)startAnimatingWithGifImageName:(NSString *)gifImageName repeatCount:(NSUInteger)repeatCount;

- (void)startAnimatingWithGifImagePath:(NSString *)gifImagePath;
- (void)startAnimatingWithGifImagePath:(NSString *)gifImagePath repeatCount:(NSUInteger)repeatCount;

- (void)startAnimatingWithImages:(NSArray<UIImage *> *)images duration:(CGFloat)duration;
- (void)startAnimatingWithImages:(NSArray<UIImage *> *)images duration:(CGFloat)duration repeatCount:(NSUInteger)repeatCount;

@end

