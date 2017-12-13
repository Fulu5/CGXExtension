//
//  NSString+CGXExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (CGXExtension)

#pragma mark - 验证比较

+ (BOOL)isEmpty:(NSString *)string;

- (BOOL)isEmail;
- (BOOL)isPhone;
/** 是否为快递单号 */
- (BOOL)isExpressNum;
/** 是否为条形码 */
- (BOOL)isBarcode;
- (BOOL)isChinese;

#pragma mark - 加密处理

- (NSString *)URLDecode;
- (NSString *)URLEncode;

- (NSString *)base64String;
- (NSString *)base64StringToOriginString;

- (NSString *)md5;
- (NSString *)hmacsha1WithSecretKey:(NSString *)secretKey;

#pragma mark - 计算尺寸

- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font;

#pragma mark - 值转化

/** ￥0、￥0.01 */
- (NSString *)RMBString;
+ (NSString *)RMBStringWithFloat:(float)price;

/** 0 or 两位小数 */
- (NSString *)priceString;
+ (NSString *)priceStringWithFloat:(float)price;

/** 0 or 三位小数 */
- (NSString *)stringToThirdDecimalPlace;

/** 自定义价格文本字体大小 */
- (NSAttributedString *)attributedWithRMBStringFontSize:(NSUInteger)RMBStringFontSize
                                    priceStringFontSize:(NSUInteger)priceStringFontSize;

/** 自定义￥和 price 字体大小、字体颜色 */
- (NSAttributedString *)attributedWithRMBStringFontSize:(NSUInteger)RMBStringFontSize
                                         RMBStringColor:(UIColor *)RMBStringColor
                                    priceStringFontSize:(NSUInteger)priceStringFontSize
                                       priceStringColor:(UIColor *)priceStringColor;

- (NSURL *)URL;
- (NSURLRequest *)URLRequest;

- (NSNumber *)numberValue;
- (NSString *)stringValue;

- (UIImage *)QRCodeImage;

/** 将 JSON data 转为 Foundation object*/
- (id)objectFromJSONString;

/** 获取固定长度随机字符串 */
+ (NSString *)randomStringWithLength:(int)length;

/** 提取HTML标签名 */
- (NSString *)filterHTMLLabels;

- (NSString *)firstLetter;

@end
