//
//  CGXBaseViewController.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGXBaseViewController : UIViewController

@property (nonatomic, assign) BOOL showBackItem;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)popViewController;

@end

