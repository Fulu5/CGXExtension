//
//  UIScrollView+CGXExtension.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "UIScrollView+CGXExtension.h"
#import "MJRefresh.h"
#import <objc/runtime.h>

#pragma mark - CGXLoadStatusView.h

@interface CGXLoadStatusView: UIView

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) CGXLoadStatus loadStatus;//当前状态

//下拉刷新的block 如果不设置则表示不需要下拉刷新
@property (nonatomic, copy) dispatch_block_t pullLoadingBlock;
//上提加载的block 如果不设置则表示不需要上拉加载 且如果没有设置pullLoadingBlock时无效
@property (nonatomic, copy) dispatch_block_t footerLoadingBlock;

@property (nonatomic, strong) NSString *failedStatusTitle;
@property (nonatomic, strong) NSString *failedStatusImageName;
@property (nonatomic, strong) NSString *emptyStatusTitle;
@property (nonatomic, strong) NSString *emptyStatusImageName;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLable;

//仅 CGXLoadStatusEmpty 和 CGXLoadStatusFailed 有效
- (void)setTitle:(NSString *)title imageName:(NSString *)imageName forStatus:(CGXLoadStatus)status;

//不再显示上拉加载数据
- (void)noticeFooterNoMoreData;

@end

#pragma mark - CGXLoadStatusView.m

#define kCGXLoadStatusDefaultTitleColor [UIColor colorWithRed:100/255. green:100/255. blue:100/255. alpha:1]

static NSString *kCGXLoadStatusDefaultFailedTitle = @"加载失败，点击重试";
static NSString *kCGXLoadStatusDefaultEmptyTitle = @"暂无内容";

@implementation CGXLoadStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.hidden = YES;
    //保证上下左右边距不变
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.hidesWhenStopped = YES;
    
    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100)];
    _titleLable.textColor = kCGXLoadStatusDefaultTitleColor;
    _titleLable.textAlignment = NSTextAlignmentCenter;
    _titleLable.backgroundColor = [UIColor clearColor];
    _titleLable.font = [UIFont systemFontOfSize:14];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _imageView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_indicator];
    [self addSubview:_titleLable];
    [self addSubview:_imageView];
    
    _indicator.hidden = YES;
    _titleLable.hidden = YES;
    _imageView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloading)];
    [self addGestureRecognizer:tap];
}

- (void)setPullLoadingBlock:(dispatch_block_t)pullLoadingBlock {
    _pullLoadingBlock = pullLoadingBlock;
    if (pullLoadingBlock) {
        __weak typeof(self) weakSelf = self;
        self.scrollView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            [weakSelf.scrollView.mj_footer resetNoMoreData];
            pullLoadingBlock();
        }];
        ((MJRefreshStateHeader *)self.scrollView.mj_header).lastUpdatedTimeLabel.hidden = YES;
    }
}

- (void)setFooterLoadingBlock:(dispatch_block_t)footerLoadingBlock {
    _footerLoadingBlock = footerLoadingBlock;
    if (footerLoadingBlock) {
        self.scrollView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:footerLoadingBlock];
    }
}

- (void)setLoadStatus:(CGXLoadStatus)loadStatus {
    
    if ((_loadStatus == loadStatus) && (loadStatus == CGXLoadStatusLoading)) {
        return;
    }
    
    _loadStatus = loadStatus;
    
    switch (loadStatus) {
        case CGXLoadStatusLoading:
        {
            if (self.pullLoadingBlock) {
                [self.scrollView.mj_footer resetNoMoreData];
                self.pullLoadingBlock();
            } else {
                self.loadStatus = CGXLoadStatusEmpty;
            }
        }
            break;
        case CGXLoadStatusSuccess:
        case CGXLoadStatusFailed:
        case CGXLoadStatusEmpty:
        {
            [self.scrollView.mj_header endRefreshing];
            if (self.scrollView.mj_footer.state != MJRefreshStateNoMoreData) {
                [self.scrollView.mj_footer endRefreshing];
            }
        }
            break;
    }
    
    [self layoutImageViewAndTitleLable];
    
    if ([self.scrollView respondsToSelector:@selector(reloadData)]) {
        [(id)self.scrollView reloadData];
    }
}

- (void)layoutImageViewAndTitleLable {
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    center.y -= self.scrollView.contentInset.top;
    
    //先禁止滚动 等成功以后才允许滚动
    self.scrollView.scrollEnabled = NO;
    
    switch (self.loadStatus) {
        case CGXLoadStatusLoading:
        {
            self.indicator.center = center;
            
            self.imageView.hidden = YES;
            self.titleLable.hidden = YES;
            self.indicator.hidden = NO;
            
            [self.indicator startAnimating];
        }
            break;
        case CGXLoadStatusSuccess:
        {
            [self.indicator stopAnimating];
            
            self.imageView.hidden = YES;
            self.titleLable.hidden = YES;
            self.indicator.hidden = YES;
            
            self.scrollView.scrollEnabled = YES;
        }
            break;
        case CGXLoadStatusFailed:
        case CGXLoadStatusEmpty:
        {
            [self.indicator stopAnimating];
            self.indicator.hidden = YES;
            
            NSString *title = nil;
            NSString *imageName = nil;
            
            switch (self.loadStatus) {
                case CGXLoadStatusFailed:
                {
                    imageName = self.failedStatusImageName;
                    title = imageName.length?self.failedStatusTitle:(self.failedStatusTitle.length?self.failedStatusTitle:kCGXLoadStatusDefaultFailedTitle);
                }
                    break;
                case CGXLoadStatusEmpty:
                {
                    imageName = self.emptyStatusImageName;
                    title = imageName.length?self.emptyStatusTitle:(self.emptyStatusTitle.length?self.emptyStatusTitle:kCGXLoadStatusDefaultEmptyTitle);
                }
                    break;
                default:
                    break;
            }
            
            if (imageName.length) {
                UIImage *image = [UIImage imageNamed:imageName];
                self.imageView.image = image;
                self.imageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
            }
            
            if (title.length) {
                self.titleLable.text = title;
            }
            
            if (title.length && imageName.length) {
                //标题和图片都在
                self.imageView.center = CGPointMake(center.x, center.y - self.titleLable.bounds.size.height / 2);
                self.titleLable.center = CGPointMake(center.x, self.imageView.center.y + self.imageView.bounds.size.height / 2 + self.titleLable.bounds.size.height / 2);
                
                self.imageView.hidden = NO;
                self.titleLable.hidden = NO;
            } else if (imageName.length) {
                //只有图片
                self.imageView.center = center;
                
                self.imageView.hidden = NO;
                self.titleLable.hidden = YES;
            } else {
                //只有标题
                self.titleLable.center = center;
                
                self.imageView.hidden = YES;
                self.titleLable.hidden = NO;
            }
        }
            break;
    }
    
    if (self.loadStatus == CGXLoadStatusSuccess) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
        [self.scrollView bringSubviewToFront:self];
    }
}

- (void)setTitle:(NSString *)title imageName:(NSString *)imageName forStatus:(CGXLoadStatus)status {
    switch (status) {
        case CGXLoadStatusFailed:
        {
            self.failedStatusTitle = title;
            self.failedStatusImageName = imageName;
        }
            break;
        case CGXLoadStatusEmpty:
        {
            self.emptyStatusTitle = title;
            self.emptyStatusImageName = imageName;
        }
            break;
        default:
            break;
    }
}

- (void)noticeFooterNoMoreData {
    [self.scrollView.mj_footer endRefreshingWithNoMoreData];
}

- (void)reloading {
    if ((self.loadStatus == CGXLoadStatusEmpty) || (self.loadStatus == CGXLoadStatusFailed)) {
        self.loadStatus = CGXLoadStatusLoading;
    }
}

@end

#pragma mark - UIScrollView.m

@implementation UIScrollView (CGXExtension)

static const void *CGXExtensionLoadStatusViewKey = &CGXExtensionLoadStatusViewKey;

- (void)setLoadStatusView:(CGXLoadStatusView *)loadStatusView {
    objc_setAssociatedObject(self, &CGXExtensionLoadStatusViewKey, loadStatusView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGXLoadStatusView *)loadStatusView {
    return objc_getAssociatedObject(self, &CGXExtensionLoadStatusViewKey);
}

- (void)triggerLoading {
    self.loadStatusView.loadStatus = CGXLoadStatusLoading;
}

- (void)setStatusSuccess {
    self.loadStatusView.loadStatus = CGXLoadStatusSuccess;
}

- (void)setStatusFail {
    self.loadStatusView.loadStatus = CGXLoadStatusFailed;
}

- (void)setStatusEmpty {
    self.loadStatusView.loadStatus = CGXLoadStatusEmpty;
}

- (void)noticeFooterNoMoreData {
    [self.loadStatusView noticeFooterNoMoreData];
}

- (void)addLoadStatusViewWithPullLoadingBlock:(dispatch_block_t)pullLoadingBlock footerLoadingBlock:(dispatch_block_t)footerLoadingBlock {
    if (self.loadStatusView || !pullLoadingBlock) {
        return;
    }
    
    CGXLoadStatusView *loadStatusView = [[CGXLoadStatusView alloc] initWithFrame:self.bounds];
    loadStatusView.backgroundColor = self.backgroundColor;
    loadStatusView.scrollView = self;
    loadStatusView.pullLoadingBlock = pullLoadingBlock;
    loadStatusView.footerLoadingBlock = footerLoadingBlock;
    self.loadStatusView = loadStatusView;
    [self addSubview:loadStatusView];
}

- (void)setTitle:(NSString *)title imageName:(NSString *)imageName forStatus:(CGXLoadStatus)status {
    [self.loadStatusView setTitle:title imageName:imageName forStatus:status];
}

@end
