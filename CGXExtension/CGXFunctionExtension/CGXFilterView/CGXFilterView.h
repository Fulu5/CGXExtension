//
//  CGXFilterView.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//条件筛选
@class CGXFilterView;

@protocol CGXFilterViewDelegate <NSObject>

@required

- (NSInteger)filterView:(CGXFilterView *)filterView numberOfRowsInSection:(NSInteger)section;
- (NSString *)filterView:(CGXFilterView *)filterView titleForHeaderInSection:(NSInteger)section;
- (NSString *)filterView:(CGXFilterView *)filterView titleForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

/** Select row event (If isSpecialRow is ture , the indexPath.row == -1) */
- (NSInteger)filterView:(CGXFilterView *)filterView didSelectRowAtIndexPath:(NSIndexPath *)indexPath isSpecialRow:(BOOL)isSpecialRow;
/** 默认为空不显示，设置标题后显示 */
- (NSString *)filterView:(CGXFilterView *)filterView titleForSpecialRowInSection:(NSInteger)section;
/** 默认 1 / (sections count). 注意 0 < percentage <= 1 */
- (CGFloat)filterView:(CGXFilterView *)filterView headerWidthPercentageInSection:(NSInteger)section;
/** 默认 1*/
- (NSInteger)numberOfSectionsInFilterView:(CGXFilterView *)filterView;
/** 默认 50*/
- (CGFloat)heightForRowInFilterView:(CGXFilterView *)filterView;
/** 默认 14 */
- (NSInteger)fontForTitleInFilterView:(CGXFilterView *)filterView;
/** 默认灰色 */
- (UIColor *)colorForNormalTitleInFilterView:(CGXFilterView *)filterView;
/** 默认橘黄色 */
- (UIColor *)colorForSelectedTitleInFilterView:(CGXFilterView *)filterView;

@end

@interface CGXFilterView : UIView

+ (nullable instancetype)filterViewWithSuperView:(__kindof UIView *)superView delegate:(id<CGXFilterViewDelegate>)delgate;
/** Current selected row in section (special row == -1) (NSNotFound when no selection) */
- (NSInteger)currentSelectedRowInSection:(NSInteger)section;

NS_ASSUME_NONNULL_END

@end
