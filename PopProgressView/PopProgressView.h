//
//  PopProgressView.h
//  PopProgressView
//
//  Created by eport on 2019/5/22.
//  Copyright © 2019 eport. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/**
 定义点击block

 @param UIButton 按钮
 */
typedef void(^PopProgressBlock)(UIButton *);

/**
 定义进度完成block
 */
typedef void(^PopProgressFinishBlock)(void);


/**
 定义按钮类型

 - PopButtonTypeCancel: 打开按钮
 - PopButtonTypeConfirm: 更新按钮
 */
typedef NS_ENUM(NSUInteger, PopButtonType) {
    PopButtonTypeCancel = 0,
    PopButtonTypeConfirm,
};

@interface PopProgressView : UIView


/**
 初始化类

 @param title 标题
 @param subTitle 正文
 @param cancelButton 取消按钮
 @param confirmButton 确认按钮
 @return PopProgressView
 */
- (instancetype)initWithTitle:(NSString *)title withSubTitle:(NSString *)subTitle withCancelButton:(NSString *)cancelButton withConfirmButton:(NSString *)confirmButton;


/**
 显示弹出框
 */
- (void)showView;


/**
 获取按钮类型
 */
- (PopButtonType)getButtonType;

/**
 设置进度
 */
@property (nonatomic, assign, setter=setProgress:)CGFloat progress;


/**
 按钮点击Block
 @param UIButton 按钮
 */
@property (nonatomic, copy)PopProgressBlock popBlock;

/**
 进度完成 当进度=1 时 会调用
 */
@property (nonatomic, copy)PopProgressFinishBlock popFinishBlock;

@end

NS_ASSUME_NONNULL_END
