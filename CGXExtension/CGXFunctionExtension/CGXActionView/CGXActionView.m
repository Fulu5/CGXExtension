//
//  CGXActionView.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "CGXActionView.h"

@interface CGXActionView () <UIGestureRecognizerDelegate> {
    UIView *_wrapperView;
}

@property (nonatomic, weak) UIView *showedView;
@property (nonatomic, copy) void (^completion)(BOOL done);

@end

@implementation CGXActionView

+ (void)showView:(UIView *)view barTintColor:(UIColor *)barTintColor titleColor:(UIColor *)titleColor title:(NSString *)title comfirmTitle:(NSString *)comfirmTitle cancelTitle:(NSString *)cancelTitle completion:(void (^)(BOOL))completion {
    CGXActionView *actionView = [CGXActionView new];
    actionView.completion = completion;
    
    view.frame = CGRectMake(view.frame.origin.x, actionView.bounds.size.height, view.frame.size.width, view.frame.size.height);
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    toolbar.translucent = NO;
    toolbar.barTintColor = barTintColor;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 0, 150, 21.0f)];
    [titleLabel setFont:[UIFont systemFontOfSize:17]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:titleColor];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 10;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:cancelTitle?:@"取消" style:UIBarButtonItemStylePlain target:actionView action:@selector(cancel)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:comfirmTitle?:@"完成" style:UIBarButtonItemStyleDone target:actionView action:@selector(done)];
    leftItem.tintColor = titleColor;
    rightItem.tintColor = titleColor;
    UIBarButtonItem *flex1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:actionView action:nil];
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    UIBarButtonItem *flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:actionView action:nil];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedDescending) {
        toolbar.items = @[fixedSpace, leftItem, flex1, titleItem, flex2, rightItem, fixedSpace];
    } else {
        toolbar.items = @[leftItem, flex1, titleItem, flex2, rightItem];
    }
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIView *window = [[UIApplication sharedApplication].delegate window];
    NSArray *winSubviews = window.subviews;
    UIView *windowSubview = winSubviews.lastObject;
    
    for (NSInteger i = (winSubviews.count-1); i > 0; i--) {
        //如果windowSubview的bounds和屏幕不一致 则说明可能是其他控件
        if (CGRectEqualToRect(window.bounds, windowSubview.bounds)) {
            break;
        } else {
            windowSubview = winSubviews[i-1];
        }
    }
    
    view.frame = CGRectMake(view.frame.origin.x, toolbar.bounds.size.height, view.frame.size.width, view.frame.size.height);
    actionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
    actionView->_wrapperView.frame = CGRectMake(actionView->_wrapperView.frame.origin.x, actionView->_wrapperView.frame.origin.y, actionView->_wrapperView.frame.size.width, view.bounds.size.height + toolbar.bounds.size.height);
    actionView->_wrapperView.frame = CGRectMake(actionView->_wrapperView.frame.origin.x, actionView.bounds.size.height, actionView->_wrapperView.frame.size.width, actionView->_wrapperView.frame.size.height);
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    [actionView->_wrapperView addSubview:toolbar];
    [actionView->_wrapperView addSubview:view];
    [actionView addSubview:actionView->_wrapperView];
    [windowSubview addSubview:actionView];
    
    [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        actionView->_wrapperView.frame = CGRectMake(actionView->_wrapperView.frame.origin.x, actionView.bounds.size.height - actionView->_wrapperView.bounds.size.height, actionView->_wrapperView.frame.size.width, actionView->_wrapperView.frame.size.height);
        actionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }                completion:nil];
}

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
                       completion:(void (^)(BOOL, NSDate *))completion {
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 240)];
    datePicker.date = selectedDate;
    datePicker.maximumDate = maxDate;
    datePicker.minimumDate = minDate;
    datePicker.datePickerMode = datePickerMode;
    datePicker.minuteInterval = minuteInterval;
    datePicker.backgroundColor = backgroundColor?:[UIColor whiteColor];
    
    [self showView:datePicker
      barTintColor:barTintColor
        titleColor:titleColor
             title:title
      comfirmTitle:comfirmTitle
       cancelTitle:cancelTitle
        completion:^(BOOL done) {
            if (completion) {
                completion(done,datePicker.date);
            }
        }];
}

#pragma mark -

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
        [self addGestureRecognizer:gesture];
        gesture.delegate = self;
        _wrapperView = [UIView new];
        _wrapperView.frame = self.bounds;
        _wrapperView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)done {
    if (self.completion) {
        self.completion(YES);
    }
    [self dismiss];
}

- (void)cancel {
    if (self.completion) {
        self.completion(NO);
    }
    [self dismiss];
}

- (void)dismiss {
    [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _wrapperView.frame = CGRectMake(_wrapperView.frame.origin.x, self.bounds.size.height, _wrapperView.frame.size.width, _wrapperView.frame.size.height);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
    }                completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:_wrapperView]) {
        return NO;
    }
    return YES;
}

@end
