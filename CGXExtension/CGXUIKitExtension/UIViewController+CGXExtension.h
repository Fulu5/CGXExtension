//
//  UIViewController+CGXExtension.h
//  CGXAttempt
//
//  Created by 曹曹 on 2017/12/11.
//  Copyright © 2017年 曹曹. All rights reserved.
//

#import <UIKit/UIKit.h>

//https://github.com/kukumaluCN/JXTAlertManager

NS_ASSUME_NONNULL_BEGIN

#pragma mark - CGXAlertController.h

@class CGXAlertController;
/**
 CGXAlertController: alertAction配置链
 
 @param title 标题
 @return      CGXAlertController对象
 */
typedef CGXAlertController * _Nonnull (^CGXAlertActionTitle)(NSString *title);

/**
 CGXAlertController: alert按钮执行回调
 
 @param buttonIndex 按钮index(根据添加action的顺序)
 @param action      UIAlertAction对象
 @param alertSelf   本类对象
 */
typedef void (^CGXAlertActionBlock)(NSInteger buttonIndex, UIAlertAction *action, CGXAlertController *alertSelf);


/**
 CGXAlertController 简介：
 
 1.针对系统UIAlertController封装，支持iOS8及以上
 
 2.关于iOS9之后的`preferredAction`属性用法:
 `alertController.preferredAction = alertController.actions[0];`
 效果为将已存在的某个action字体加粗，原cancel样式的加粗字体成为deafult样式，cancel样式的action仍然排列在最下
 总体意义不大，且仅限于`UIAlertControllerStyleAlert`，actionSheet无效，功能略微鸡肋，不再单独封装
 
 3.关于`addTextFieldWithConfigurationHandler:`方法:
 该方法同样仅限于`UIAlertControllerStyleAlert`使用，使用场景较为局限，推荐直接调用，不再针对封装
 
 4.关于自定义按钮字体或者颜色，可以利用kvc间接访问这些私有属性，但是不推荐
 `[alertAction setValue:[UIColor grayColor] forKey:@"titleTextColor"]`
 */
NS_CLASS_AVAILABLE_IOS(8_0) @interface CGXAlertController : UIAlertController


/**
 CGXAlertController: 禁用alert弹出动画，默认执行系统的默认弹出动画
 */
- (void)alertAnimateDisabled;

/**
 CGXAlertController: alert弹出后，可配置的回调
 */
@property (nullable, nonatomic, copy) void (^alertDidShown)(void);

/**
 CGXAlertController: alert关闭后，可配置的回调
 */
@property (nullable, nonatomic, copy) void (^alertDidDismiss)(void);

/**
 CGXAlertController: 设置toast模式展示时间：如果alert未添加任何按钮，将会以toast样式展示，这里设置展示时间，默认1s
 */
@property (nonatomic, assign) NSTimeInterval toastStyleDuration; //deafult CGX_alertShowDurationDefault = 1s


/**
 CGXAlertController: 链式构造alert视图按钮，添加一个alertAction按钮，默认样式，参数为标题
 
 @return CGXAlertController对象
 */
- (CGXAlertActionTitle)addActionDefaultTitle;

/**
 CGXAlertController: 链式构造alert视图按钮，添加一个alertAction按钮，取消样式，参数为标题(warning:一个alert该样式只能添加一次!!!)
 
 @return CGXAlertController对象
 */
- (CGXAlertActionTitle)addActionCancelTitle;

/**
 CGXAlertController: 链式构造alert视图按钮，添加一个alertAction按钮，警告样式，参数为标题
 
 @return CGXAlertController对象
 */
- (CGXAlertActionTitle)addActionDestructiveTitle;

@end

#pragma mark - UIViewController + CGXExtension.h

/**
 CGXAlertController: alert构造块
 
 @param alertMaker CGXAlertController配置对象
 */
typedef void(^CGXAlertButtonsConfig)(CGXAlertController *alertMaker);

typedef void (^AlertActionBlock)(NSInteger buttonIndex, UIAlertAction *action);

@interface UIViewController (CGXExtension)

- (void)pushViewControllerHidesBottomBar:(UIViewController *)viewController;

/**
 弹出 UIAlertController

 @param style alert 样式还是 actiuonSheet 样式
 @param title 标题
 @param message 内容
 @param buttonsConfig 配置按钮
 @param actionBlock 按钮点击回调
 */
- (void)showAlertWithStyle:(UIAlertControllerStyle)style
                     title:(nullable NSString *)title
                   message:(nullable NSString *)message
             buttonsConfig:(CGXAlertButtonsConfig)buttonsConfig
              actionsBlock:(nullable CGXAlertActionBlock)actionBlock NS_AVAILABLE_IOS(8_0);

@end

NS_ASSUME_NONNULL_END
