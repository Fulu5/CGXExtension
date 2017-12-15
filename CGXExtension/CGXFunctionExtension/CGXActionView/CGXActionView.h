//
//  CGXActionView.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGXActionView : UIView

+ (void)showView:(UIView *)view
    barTintColor:(UIColor *)barTintColor
      titleColor:(UIColor *)titleColor
           title:(NSString *)title
    comfirmTitle:(NSString *)comfirmTitle
     cancelTitle:(NSString *)cancelTitle
      completion:(void(^)(BOOL done))completion;

+ (void)showDatePickerWithMaxDate:(NSDate *)maxDate
                          minDate:(NSDate *)minDate
                     selectedDate:(NSDate *)selectedDate
                   datePickerMode:(UIDatePickerMode)datePickerMode
                   minuteInterval:(NSInteger)minuteInterval
                     barTintColor:(UIColor *)barTintColor
                       titleColor:(UIColor *)titleColor
                  backgroundColor:(UIColor *)backgroundColor
                            title:(NSString *)title
                     comfirmTitle:(NSString *)comfirmTitle
                      cancelTitle:(NSString *)cancelTitle
                       completion:(void(^)(BOOL done, NSDate *date))completion;

@end
