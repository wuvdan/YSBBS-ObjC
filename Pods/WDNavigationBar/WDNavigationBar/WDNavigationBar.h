//
//  WDNavigationBar.h
//  AppProjiect
//
//  Created by wudan on 2018/8/5.
//  Copyright © 2018年 wudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

#define IS_iPhoneX ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)
#define KStatusBarHeight (IS_iPhoneX ? 24.f:0.f)
#define KStatusBarMargin (IS_iPhoneX ? 22.f:0.f)
#define Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Screen_Width       [[UIScreen mainScreen] bounds].size.width

@interface WDNavigationBar : UIView
// 主视图
@property (nonatomic, strong) UIView    *mainView;
// 左边第一个按钮
@property (nonatomic, strong) UIButton  *leftButton;
// 左边第二个按钮
@property (nonatomic, strong) UIButton  *leftTwoButton;
// 右边第一个按钮
@property (nonatomic, strong) UIButton  *rightButton;
// 右边第二个按钮
@property (nonatomic, strong) UIButton  *rightTwoButton;
// 标题按钮
@property (nonatomic, strong) UIButton  *centerButton;
// 是否显示底部线
@property (nonatomic, assign) BOOL      showBottomLabel;

@property (nonatomic, copy) void (^ leftButtonBlock)(void);
@property (nonatomic, copy) void (^ leftTwoButtonBlock)(void);
@property (nonatomic, copy) void (^ cenTerButtonBlock)(void);
@property (nonatomic, copy) void (^ rightButtonBlock)(void);
@property (nonatomic, copy) void (^ rightTwoButtonBlock)(void);

@end
