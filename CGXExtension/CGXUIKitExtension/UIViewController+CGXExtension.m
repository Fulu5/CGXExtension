//
//  UIViewController+CGXExtension.m
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import "UIViewController+CGXExtension.h"

//toast默认展示时间, 可通过设置 alertMaker.toastStyleDuration来自定义
static NSTimeInterval const CGXAlertShowDurationDefault = 1.0f;

#pragma mark - AlertActionModel.h

@interface CGXAlertActionModel : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) UIAlertActionStyle style;

@end

#pragma mark - AlertActionModel.m

@implementation CGXAlertActionModel

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"";
        self.style = UIAlertActionStyleDefault;
    }
    return self;
}

@end

#pragma mark - CGXAlertController.h
/**
 AlertActions配置
 
 @param actionBlock CGXAlertActionBlock
 */
typedef void (^CGXAlertActionsConfig)(CGXAlertActionBlock actionBlock);


@interface CGXAlertController ()

//CGXAlertActionModel数组
@property (nonatomic, strong) NSMutableArray<CGXAlertActionModel *> *alertActionArray;
//是否操作动画
@property (nonatomic, assign) BOOL setAlertAnimated;
//action配置
- (CGXAlertActionsConfig)alertActionsConfig;

@end

#pragma mark - CGXAlertController.m

@implementation CGXAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.alertDidDismiss) {
        self.alertDidDismiss();
    }
}

#pragma mark - Private

//action-title数组
- (NSMutableArray<CGXAlertActionModel *> *)alertActionArray {
    if (_alertActionArray == nil) {
        _alertActionArray = [NSMutableArray array];
    }
    return _alertActionArray;
}

//action配置
- (CGXAlertActionsConfig)alertActionsConfig {
    
    return ^(CGXAlertActionBlock actionBlock) {
        if (self.alertActionArray.count > 0) {
            //创建action
            __weak typeof(self)weakSelf = self;
            [self.alertActionArray enumerateObjectsUsingBlock:^(CGXAlertActionModel *actionModel, NSUInteger idx, BOOL * _Nonnull stop) {
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:actionModel.title style:actionModel.style handler:^(UIAlertAction * _Nonnull action) {
                    __strong typeof(weakSelf)strongSelf = weakSelf;
                    if (actionBlock) {
                        actionBlock(idx, action, strongSelf);
                    }
                }];
                //可利用这个改变字体颜色，但是不推荐！！！
                //[alertAction setValue:[UIColor grayColor] forKey:@"titleTextColor"];
                //action作为self元素，其block实现如果引用本类指针，会造成循环引用
                [self addAction:alertAction];
            }];
        } else {
            NSTimeInterval duration = self.toastStyleDuration > 0 ? self.toastStyleDuration : CGXAlertShowDurationDefault;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:!(self.setAlertAnimated) completion:NULL];
            });
        }
    };
}

#pragma mark - Public

- (instancetype)initAlertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle {
    
    if (!(title.length > 0) && (message.length > 0) && (preferredStyle == UIAlertControllerStyleAlert)) {
        title = @"";
    }
    self = [[self class] alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (!self) return nil;
    
    self.setAlertAnimated = NO;
    self.toastStyleDuration = CGXAlertShowDurationDefault;
    
    return self;
}

- (void)alertAnimateDisabled {
    self.setAlertAnimated = YES;
}

- (CGXAlertActionTitle)addActionDefaultTitle {
    //该block返回值不是本类属性，只是局部变量，不会造成循环引用
    return ^(NSString *title) {
        CGXAlertActionModel *actionModel = [[CGXAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDefault;
        [self.alertActionArray addObject:actionModel];
        return self;
    };
}

- (CGXAlertActionTitle)addActionCancelTitle {
    return ^(NSString *title) {
        CGXAlertActionModel *actionModel = [[CGXAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleCancel;
        [self.alertActionArray addObject:actionModel];
        return self;
    };
}

- (CGXAlertActionTitle)addActionDestructiveTitle {
    return ^(NSString *title) {
        CGXAlertActionModel *actionModel = [[CGXAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDestructive;
        [self.alertActionArray addObject:actionModel];
        return self;
    };
}

@end

#pragma mark - UIViewController + CGXExtension.m

@implementation UIViewController (CGXExtension)

- (void)pushViewControllerHidesBottomBar:(UIViewController *)viewController {
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showAlertWithStyle:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message buttonsConfig:(CGXAlertButtonsConfig)buttonsConfig actionsBlock:(CGXAlertActionBlock)actionBlock {
    
    if (buttonsConfig) {
        CGXAlertController *alertMaker = [[CGXAlertController alloc] initAlertControllerWithTitle:title message:message preferredStyle:style];
        //防止nil
        if (!alertMaker) {
            return ;
        }
        //加工链
        buttonsConfig(alertMaker);
        //配置响应
        alertMaker.alertActionsConfig(actionBlock);
        
        if (alertMaker.alertDidShown) {
            [self presentViewController:alertMaker animated:!(alertMaker.setAlertAnimated) completion:^{
                alertMaker.alertDidShown();
            }];
        } else {
            [self presentViewController:alertMaker animated:!(alertMaker.setAlertAnimated) completion:nil];
        }
    }
}

@end
