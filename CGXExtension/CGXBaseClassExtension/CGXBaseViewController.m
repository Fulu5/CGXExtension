//
//  CGXBaseViewController.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "CGXBaseViewController.h"
#import "NSString+CGXExtension.h"

@interface CGXBaseViewController ()

@end

@implementation CGXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tableViewConfig];
    [self collectionViewConfig];
    
    if (self.showBackItem || (self.navigationController.viewControllers.firstObject != self)) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:@"icon_common_back".image style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
}

#pragma mark - Config

- (void)tableViewConfig {
    if (!self.tableView) {
        if ([self.view isKindOfClass:[UITableView class]]) {
            self.tableView = (UITableView *)self.view;
        } else {
            for (UIView *view in self.view.subviews) {
                if ([view isKindOfClass:[UITableView class]]) {
                    self.tableView = (UITableView *)view;
                    break;
                }
            }
        }
        self.tableView.delegate = (id<UITableViewDelegate>)self;
        self.tableView.dataSource = (id<UITableViewDataSource>)self;
    }
}

- (void)collectionViewConfig {
    if (!self.collectionView) {
        if ([self.view isKindOfClass:[UICollectionView class]]) {
            self.collectionView = (UICollectionView *)self.view;
        } else {
            for (UIView *view in self.view.subviews) {
                if ([view isKindOfClass:[UICollectionView class]]) {
                    self.collectionView = (UICollectionView *)view;
                    break;
                }
            }
        }
        self.collectionView.delegate = (id<UICollectionViewDelegate>)self;
        self.collectionView.dataSource = (id<UICollectionViewDataSource>)self;
    }
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
