//
//  UICollectionView+CGXExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (CGXExtension)

- (void)registerDefaultCell;

- (void)registerCellWithCellClass:(Class)clazz;
- (void)registerNibCellWithCellClass:(Class)clazz;

- (void)registerHeaderFooterWithClass:(Class)clazz isHeader:(BOOL)isHeader;
- (void)registerNibHeaderFooterWithClass:(Class)clazz isHeader:(BOOL)isHeader;

- (UICollectionViewCell *)dequeueReusableCellWithDefaultIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (UICollectionViewCell *)dequeueReusableCellWithCellClass:(Class)clazz forIndexPath:(NSIndexPath *)indexPath;
- (UICollectionViewCell *)dequeueReusableSupplementaryViewClass:(Class)clazz isHeader:(BOOL)isHeader forIndexPath:(NSIndexPath *)indexPath;

@end
