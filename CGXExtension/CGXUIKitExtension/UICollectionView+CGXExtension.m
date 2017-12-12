//
//  UICollectionView+CGXExtension.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "UICollectionView+CGXExtension.h"

@implementation UICollectionView (CGXExtension)

- (void)registerDefaultCell {
    [self registerCellWithCellClass:[UICollectionViewCell class]];
}

- (void)registerCellWithCellClass:(Class)cellClass {
    [self registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)registerNibCellWithCellClass:(Class)clazz {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(clazz) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(clazz)];
}

- (void)registerHeaderFooterWithClass:(Class)clazz isHeader:(BOOL)isHeader {
    [self registerClass:clazz forSupplementaryViewOfKind:isHeader?UICollectionElementKindSectionHeader:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(clazz)];
}

- (void)registerNibHeaderFooterWithClass:(Class)clazz isHeader:(BOOL)isHeader {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(clazz) bundle:nil] forSupplementaryViewOfKind:isHeader?UICollectionElementKindSectionHeader:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(clazz)];
}

- (UICollectionViewCell *)dequeueReusableCellWithDefaultIdentifierForIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithCellClass:[UICollectionViewCell class] forIndexPath:indexPath];
}

- (UICollectionViewCell *)dequeueReusableCellWithCellClass:(Class)clazz forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithReuseIdentifier:NSStringFromClass(clazz) forIndexPath:indexPath];
}

- (UICollectionViewCell *)dequeueReusableSupplementaryViewClass:(Class)clazz isHeader:(BOOL)isHeader forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableSupplementaryViewOfKind:isHeader?UICollectionElementKindSectionHeader:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(clazz) forIndexPath:indexPath];
}

@end
