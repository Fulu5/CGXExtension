//
//  CGXFilterView.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "CGXFilterView.h"
#import "UIImage+CGXExtension.h"
#import "UIButton+CGXExtension.h"
#import "UITableView+CGXExtension.h"

@interface CGXFilterViewData : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray<NSString *> *rowTitles;

@property (nonatomic, assign) BOOL hasSpecialRow;
@property (nonatomic, strong) NSString *specialRowTitle;

@end

@implementation CGXFilterViewData

@end

static const CGFloat    kCGXFilterViewAnimationDuration = 0.15f;
static const CGFloat    kCGXFilterViewDefaultRowHeight  = 50.f;
static const NSInteger  kCGXFilterViewDefaultFontSize   = 14;

#define kCGXFilterViewDefaultNormalTitleColor           [UIColor lightGrayColor]
#define kCGXFilterViewDefaultSelectedTitleColor         [UIColor orangeColor]

@interface CGXFilterView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) __kindof UIView *superView;
@property (nonatomic, weak) id<CGXFilterViewDelegate> delegate;

@property (nonatomic, strong) UIControl *backgroundView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<UIButton *> *headerButtons;
@property (nonatomic, strong) NSMutableArray<CGXFilterViewData *> *sectionsData;

@property (nonatomic, assign) NSInteger currentSelectedSection;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *,NSNumber *> *selectedRowsMap;// section : selected row index (special row == -1)

@property (nonatomic, assign) NSInteger sectionCount;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat titleFontSize;
@property (nonatomic, strong) UIColor *normalTitleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;

@end

@implementation CGXFilterView

#pragma mark - Filter View Methods

+ (instancetype)filterViewWithSuperView:(__kindof UIView *)superView delegate:(id<CGXFilterViewDelegate>)delegate {
    if (!superView || !delegate) {
        return nil;
    }
    
    CGXFilterView *filterView = [[CGXFilterView alloc] initWithFrame:CGRectMake(0, 0, superView.bounds.size.width, kCGXFilterViewDefaultRowHeight)];
    filterView.superView = superView;
    filterView.delegate = delegate;
    filterView.backgroundColor = [UIColor whiteColor];
    [filterView reload];
    [superView addSubview:filterView];
    [superView bringSubviewToFront:filterView];
    return filterView;
}

- (void)reload {
    if ([self.delegate respondsToSelector:@selector(numberOfSectionsInFilterView:)]) {
        self.sectionCount = [self.delegate numberOfSectionsInFilterView:self];
    } else {
        self.sectionCount = 1;
    }
    
    if (self.sectionCount < 1) {
        NSLog(@"%@ error : section count < 1 .",self.class);
        return;
    }
    
    //初始化数据
    [self dataInit];
    
    //重新调整自己的高度
    self.frame = CGRectMake(0, 0, self.superView.frame.size.width, self.rowHeight);
    
    //删除之前的按钮
    if (self.headerButtons) {
        for (UIButton *btn in self.headerButtons) {
            [btn removeFromSuperview];
        }
        [self.headerButtons removeAllObjects];
    } else {
        self.headerButtons = [NSMutableArray array];
    }
    
    //创建按钮
    CGFloat widthSum = 0;//记录当前按钮总宽度
    UIImage *originImage = [UIImage imageNamed:@"img_filterview_downarrow"];
    UIImage *normalImage = [originImage tintWithColor:self.normalTitleColor];
    UIImage *selectedImage = [originImage tintWithColor:self.selectedTitleColor];
    
    for (NSInteger section = 0; section < self.sectionCount; section++) {
        //每个按钮的宽度比例
        CGFloat widthPer = 0;
        
        if ([self.delegate respondsToSelector:@selector(filterView:headerWidthPercentageInSection:)]) {
            widthPer = [self.delegate filterView:self headerWidthPercentageInSection:section];
        }
        
        if ((widthPer <= 0) || (widthPer > 1)) {
            widthPer = 1. / self.sectionCount;
        }
        
        //创建按钮
        CGFloat buttonWidth = self.frame.size.width * widthPer;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(widthSum, 0, buttonWidth, self.frame.size.height)];
        widthSum += buttonWidth;
        button.tag = section;
        button.titleLabel.font = [UIFont systemFontOfSize:self.titleFontSize];
        [button setTitle:self.sectionsData[section].title forState:UIControlStateNormal];
        [button setTitleColor:self.normalTitleColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectedTitleColor forState:UIControlStateSelected];
        [button setImage:normalImage forState:UIControlStateNormal];
        [button setImage:selectedImage forState:UIControlStateSelected];
        [button addTarget:self action:@selector(headerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.adjustsImageWhenHighlighted = NO;
        [button setImageAlignment:UIButtonImageAlignmentRight];
        [self addSubview:button];
        [self.headerButtons addObject:button];
    }
    
    //创建背景遮罩
    if (!self.backgroundView) {
        self.backgroundView = [[UIControl alloc] initWithFrame:self.superView.bounds];
        self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self.backgroundView addTarget:self action:@selector(backgroundViewTouchAction) forControlEvents:UIControlEventTouchUpInside];
        self.backgroundView.hidden = YES;
        [self.superView insertSubview:self.backgroundView belowSubview:self];
    } else {
        self.backgroundView.frame = self.superView.bounds;
    }
    
    //创建选项 tableview
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 0) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.hidden = YES;
        [self.tableView registerDefaultCell];
        [self.superView insertSubview:self.tableView aboveSubview:self];
    } else {
        self.tableView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 0);
    }
    
    [self reset];
}

- (void)reset {
    self.selectedRowsMap = [NSMutableDictionary dictionary];
    
    [self backgroundViewTouchAction];
    
    [self.headerButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitle:self.sectionsData[idx].title forState:UIControlStateNormal];
        obj.selected = NO;
    }];
}

- (NSInteger)currentSelectedRowInSection:(NSInteger)section {
    NSNumber *rowIndex = [self.selectedRowsMap objectForKey:@(section)];
    if (rowIndex) {
        return [rowIndex integerValue];
    }
    return NSNotFound;
}

#pragma mark - Private

- (void)dataInit {
    if ([self.delegate respondsToSelector:@selector(heightForRowInFilterView:)]) {
        self.rowHeight = [self.delegate heightForRowInFilterView:self];
    } else {
        self.rowHeight = kCGXFilterViewDefaultRowHeight;
    }
    
    if ([self.delegate respondsToSelector:@selector(fontForTitleInFilterView:)]) {
        self.titleFontSize = [self.delegate fontForTitleInFilterView:self];
    } else {
        self.titleFontSize = kCGXFilterViewDefaultFontSize;
    }
    
    if ([self.delegate respondsToSelector:@selector(colorForNormalTitleInFilterView:)]) {
        self.normalTitleColor = [self.delegate colorForNormalTitleInFilterView:self];
    } else {
        self.normalTitleColor = kCGXFilterViewDefaultNormalTitleColor;
    }
    
    if ([self.delegate respondsToSelector:@selector(colorForSelectedTitleInFilterView:)]) {
        self.selectedTitleColor = [self.delegate colorForSelectedTitleInFilterView:self];
    } else {
        self.selectedTitleColor = kCGXFilterViewDefaultSelectedTitleColor;
    }
    
    self.sectionsData = [NSMutableArray arrayWithCapacity:self.sectionCount];
    
    for (NSInteger section = 0; section < self.sectionCount; section++) {
        CGXFilterViewData *data = [CGXFilterViewData new];
        data.title = [self.delegate filterView:self titleForHeaderInSection:section];
        
        NSInteger rowCount = [self.delegate filterView:self numberOfRowsInSection:section];
        if (rowCount > 0) {
            data.rowTitles = [NSMutableArray arrayWithCapacity:rowCount];
            for (NSInteger rowIndex = 0; rowIndex < rowCount; rowIndex++) {
                [data.rowTitles addObject:([self.delegate filterView:self titleForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:section]]?:@"")];
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(filterView:titleForSpecialRowInSection:)]) {
            NSString *specialRowTitle = [self.delegate filterView:self titleForSpecialRowInSection:section];
            if (specialRowTitle.length) {
                data.hasSpecialRow = YES;
                data.specialRowTitle = specialRowTitle;
            }
        }
        
        [self.sectionsData addObject:data];
    }
}

- (void)backgroundViewTouchAction {
    [self setTableViewHidden:YES];
    [self setBackgroundViewHidden:YES];
    
    [self.headerButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self setButton:obj arrowUp:NO];
    }];
}

- (void)headerButtonAction:(UIButton *)button {
    if (button.selected && !self.backgroundView.hidden) {
        [self backgroundViewTouchAction];
        return;
    }
    
    [self.headerButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
        [self setButton:obj arrowUp:NO];
    }];
    
    button.selected = YES;
    [self setButton:button arrowUp:YES];
    
    self.currentSelectedSection = button.tag;
    
    [self setTableViewHidden:NO];
    [self setBackgroundViewHidden:NO];
    
    [self.tableView reloadData];
}

- (void)setButton:(UIButton *)button arrowUp:(BOOL)arrowUp {
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    if (arrowUp) {
        transform = CGAffineTransformMakeRotation(M_PI);
    }
    
    [UIView animateWithDuration:kCGXFilterViewAnimationDuration animations:^{
        button.imageView.transform = transform;
    }];
}

- (void)setTableViewHidden:(BOOL)hidden {
    CGRect frame = self.tableView.frame;
    
    if (hidden) {
        frame.size.height = 0;
    } else {
        self.tableView.hidden = hidden;
        
        NSInteger rowCount = self.sectionsData[self.currentSelectedSection].rowTitles.count + (self.sectionsData[self.currentSelectedSection].hasSpecialRow?1:0);
        CGFloat height = rowCount * self.rowHeight;
        CGFloat maxHeight = self.superView.bounds.size.height - self.tableView.frame.origin.y - self.rowHeight;
        if (height > maxHeight) {
            height = maxHeight;
            self.tableView.scrollEnabled = YES;
            [self.tableView performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:0];
        } else {
            self.tableView.scrollEnabled = NO;
        }
        frame.size.height = height;
    }
    
    [UIView animateWithDuration:kCGXFilterViewAnimationDuration
                     animations:^{
                         self.tableView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         self.tableView.hidden = hidden;
                     }];
}

- (void)setBackgroundViewHidden:(BOOL)hidden {
    if (self.backgroundView.hidden == hidden) {
        return;
    }
    
    if (!hidden) {
        self.backgroundView.hidden = hidden;
    }
    
    [UIView animateWithDuration:kCGXFilterViewAnimationDuration
                     animations:^{
                         self.backgroundView.alpha = hidden?0:1;
                     }
                     completion:^(BOOL finished) {
                         self.backgroundView.hidden = hidden;
                     }];
}

#pragma mark - Table View Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self backgroundViewTouchAction];
    
    CGXFilterViewData *data = self.sectionsData[self.currentSelectedSection];
    
    //设置标题
    NSString *buttonTitle = nil;
    if (data.hasSpecialRow) {
        if (indexPath.row == 0) {
            buttonTitle = data.title;
        } else {
            buttonTitle = data.rowTitles[indexPath.row - 1];
        }
    } else {
        buttonTitle = data.rowTitles[indexPath.row];
    }
    [self.headerButtons[self.currentSelectedSection] setTitle:buttonTitle forState:UIControlStateNormal];
    
    //记录选择的 row index
    [self.selectedRowsMap setObject:@(data.hasSpecialRow?(indexPath.row-1):indexPath.row) forKey:@(self.currentSelectedSection)];
    
    if ([self.delegate respondsToSelector:@selector(filterView:didSelectRowAtIndexPath:isSpecialRow:)]) {
        if (data.hasSpecialRow) {
            if (indexPath.row == 0) {
                [self.delegate filterView:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:self.currentSelectedSection] isSpecialRow:YES];
            } else {
                [self.delegate filterView:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:self.currentSelectedSection] isSpecialRow:NO];
            }
        } else {
            [self.delegate filterView:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:self.currentSelectedSection] isSpecialRow:NO];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithDefaultIdentifierForIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:self.titleFontSize];
    
    CGXFilterViewData *data = self.sectionsData[self.currentSelectedSection];
    NSNumber *selectedRowIndex = [self.selectedRowsMap objectForKey:@(self.currentSelectedSection)];
    
    NSString *title = nil;
    UIColor *color = nil;
    
    if (data.hasSpecialRow) {
        if (indexPath.row == 0) {
            title = data.specialRowTitle;
        } else {
            title = data.rowTitles[indexPath.row - 1];
        }
        
        if (selectedRowIndex && (selectedRowIndex.integerValue == (indexPath.row - 1))) {
            color = self.selectedTitleColor;
        } else {
            color = self.normalTitleColor;
        }
    } else {
        title = data.rowTitles[indexPath.row];
        
        if (selectedRowIndex && (selectedRowIndex.integerValue == indexPath.row)) {
            color = self.selectedTitleColor;
        } else {
            color = self.normalTitleColor;
        }
    }
    
    cell.textLabel.text = title;
    cell.textLabel.textColor = color;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowsCount = self.sectionsData[self.currentSelectedSection].rowTitles.count;
    if (self.sectionsData[self.currentSelectedSection].hasSpecialRow) {
        rowsCount++;
    }
    return rowsCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.rowHeight;
}

@end
