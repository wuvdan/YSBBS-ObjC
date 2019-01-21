//
//  LoginViewController.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/23.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"

@interface LoginViewController ()
/** < Login Text > */
@property (nonatomic, strong) UILabel     *headerTitle;
/** < Account in put view > */
@property (nonatomic, strong) WDInputView *accountView;
/** < Password in put view > */
@property (nonatomic, strong) WDInputView *passwordView;
/** < login button > */
@property (nonatomic, strong) UIButton    *loginButton;
/** < sign in button > */
@property (nonatomic, strong) UIButton    *registerButton;
/** < forget password button > */
@property (nonatomic, strong) UIButton    *forgetPwdButton;
/** < view wait network show > */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation LoginViewController

#pragma mark  LifeCyle 
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark  SetupSubviewsUI 
- (void)setupSubviews{
    
    self.wdNavigationBar.leftButton.hidden = true;
    
    self.view.backgroundColor = kMainBlack;
    
    self.headerTitle = [[UILabel alloc] initWithText:@"Sign In"
                                           textColor:kMainWhite
                                            textFont:25
                                       textAlignment:NSTextAlignmentCenter];
    self.headerTitle.font = [[UtilsManager shareInstance] createSytemFontSize:30 fontName:@""];
    [self.view addSubview:self.headerTitle];
    
    self.accountView = [[UtilsManager shareInstance] createInputViewWithPlaceholder:@"请输入账号"
                                                                          maxLength:16
                                                                       leftIconName:@"account"
                                                                 keyboardAppearance:UIKeyboardAppearanceAlert
                                                                       keyboardType:UIKeyboardTypeDefault];
    [self.view addSubview:self.accountView];
    
    self.passwordView = [[UtilsManager shareInstance] createInputViewWithPlaceholder:@"请输入密码"
                                                                           maxLength:16
                                                                        leftIconName:@"password"
                                                                  keyboardAppearance:UIKeyboardAppearanceAlert
                                                                        keyboardType:UIKeyboardTypeDefault];
    self.passwordView.textField.secureTextEntry = true;
    [self.view addSubview:self.passwordView];
    
    self.loginButton = [[UIButton alloc] initWithText:@"登 录"
                                            textColor:kMainWhite
                                             textFont:18
                                      backgroundColor:UIColor.clearColor];
    self.loginButton.layer.borderColor = kMainLightGreen.CGColor;
    self.loginButton.layer.borderWidth = 0.8;
    self.loginButton.layer.cornerRadius = kRealWidthValue(45/2);
    self.loginButton.tag = 9;
    [self.loginButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] init];
    [self.indicatorView setHidesWhenStopped:true];
    [self.loginButton addSubview:self.indicatorView];
    
    self.registerButton = [[UIButton alloc] initWithText:@"还没有账号？去注册吧！"
                                               textColor:kMainLightGreen
                                                textFont:14
                                         backgroundColor:UIColor.clearColor];
    self.registerButton.tag = 10;
    [self.registerButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
    
    self.forgetPwdButton = [[UIButton alloc] initWithText:@"忘记密码"
                                                textColor:kMainLightGreen
                                                 textFont:14
                                          backgroundColor:UIColor.clearColor];
    self.forgetPwdButton.tag = 11;
    [self.forgetPwdButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetPwdButton];
}

#pragma mark  SetupSubviewsConstraints 
- (void)setupSubviewsConstraints{
    [self.headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).inset(kTopHeight);
    }];
    
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(45));
        make.bottom.mas_equalTo(self.view.mas_centerY).mas_offset(kRealHeightValue(-25));
        make.height.mas_equalTo(kRealHeightValue(45));
    }];
    
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(45));
        make.top.mas_equalTo(self.view.mas_centerY).mas_offset(kRealHeightValue(25));
        make.height.mas_equalTo(kRealHeightValue(45));
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(50));
        make.top.mas_equalTo(self.passwordView.mas_bottom).mas_offset(kRealHeightValue(30));
        make.height.mas_equalTo(kRealHeightValue(45));
    }];
    
    [self.forgetPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).inset(kSafeAreaHeight+kRealHeightValue(15));
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.forgetPwdButton.mas_top).mas_offset(kRealHeightValue(-15));
    }];
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.loginButton);
    }];
}

#pragma mark  点击事件 
- (void)buttonAction:(UIButton *)button {
    switch (button.tag) {
        case 9:{
            [self loginNetRequest];
        }
            break;
        case 10:{
            RegisterViewController *vc = [[RegisterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case 11:{
            ForgetPasswordViewController *vc = [[ForgetPasswordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        default:
            break;
    }
}

#pragma mark  登录网络请求 
- (void)loginNetRequest {
    [[UtilsManager shareInstance] loginLimtWithAcount:self.accountView.textField.text password:self.passwordView.textField.text showSuccess:^{
        [self.loginButton setTitle:@"" forState:UIControlStateNormal];
        [self.indicatorView startAnimating];
        [[BBSNetworkTool shareInstance] loginRequsetWithAccount:self.accountView.textField.text
                                                       passowrd:self.passwordView.textField.text
                                                   successBlock:^(id  _Nonnull obj) {
                                                       [self handlerLoginData];
                                                   } failBlock:^(id  _Nonnull obj) {
                                                       [self handlerLoginData];
                                                   }];
    }];
}

#pragma mark  登录成功处理事件 
- (void)handlerLoginData{
    [self openDataBase];
    [self.loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    [self.indicatorView stopAnimating];
}

- (void)openDataBase {
    [[DataBaseTools manager] createTableWithName:HomeListTable];
    [[DataBaseTools manager] createTableWithName:CommentListTable];
    [[DataBaseTools manager] createTableWithName:UserInfoTable];
}
@end

