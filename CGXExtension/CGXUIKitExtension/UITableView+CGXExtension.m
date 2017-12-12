//
//  UITableView+CGXExtension.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "UITableView+CGXExtension.h"

@implementation UITableView (CGXExtension)

-(void)hideGroupHeaderView {
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.1, 0.1)];
}

-(void)hideFooterView {
    self.tableFooterView = [UIView new];
}

- (void)registerDefaultCell {
    [self registerCellWithCellClass:[UITableViewCell class]];
}

- (void)registerNibCellWithCellClass:(Class)cellClass {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil] forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)registerCellWithCellClass:(Class)cellClass {
    [self registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)registerNibHeaderFooterWithClass:(Class)aClass {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(aClass) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass(aClass)];
}

- (void)registerHeaderFooterWithClass:(Class)aClass {
    [self registerClass:aClass forHeaderFooterViewReuseIdentifier:NSStringFromClass(aClass)];
}

- (UITableViewCell *)dequeueReusableCellWithDefaultIdentifier {
    return [self dequeueReusableCellWithCellClass:[UITableViewCell class]];
}

- (UITableViewCell *)dequeueReusableCellWithDefaultIdentifierForIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithCellClass:[UITableViewCell class] forIndexPath:indexPath];
}

- (UITableViewCell *)dequeueReusableCellWithCellClass:(Class)cellClass {
    return [self dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
}

- (UITableViewCell *)dequeueReusableCellWithCellClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
}

@end
