//
//  UITableView+CGXExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (CGXExtension)

- (void)hideGroupHeaderView;
- (void)hideFooterView;

- (void)registerDefaultCell;

- (void)registerNibCellWithCellClass:(Class)cellClass;
- (void)registerCellWithCellClass:(Class)cellClass;

- (void)registerNibHeaderFooterWithClass:(Class)aClass;
- (void)registerHeaderFooterWithClass:(Class)aClass;

- (UITableViewCell *)dequeueReusableCellWithDefaultIdentifier;
- (UITableViewCell *)dequeueReusableCellWithDefaultIdentifierForIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)dequeueReusableCellWithCellClass:(Class)cellClass;
- (UITableViewCell *)dequeueReusableCellWithCellClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath;

@end
