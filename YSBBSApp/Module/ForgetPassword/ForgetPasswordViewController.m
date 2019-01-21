//
//  ForgetPasswordViewController.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/24.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController ()
/** < Account in put view > */
@property (nonatomic, strong) WDInputView *accountView;
/** < Code in put view > */
@property (nonatomic, strong) WDInputView *codeView;
/** < Password in put view > */
@property (nonatomic, strong) WDInputView *passwordView;
/** < Password again in put view > */
@property (nonatomic, strong) WDInputView *againPasswordView;
/** < login button > */
@property (nonatomic, strong) UIButton    *sureButton;
/** < view wait network show > */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, assign) bool isChecked;

@end

@implementation ForgetPasswordViewController

#pragma mark  LifeCyle 
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isChecked = false;
}

#pragma mark  SetupNavigationBar 
- (void)setupNavigationBar{
    [super setupNavigationBar];
    [self.wdNavigationBar.centerButton setTitle:@"Forget Password" forState:UIControlStateNormal];
    self.wdNavigationBar.centerButton.titleLabel.font = [[UtilsManager shareInstance] createSytemFontSize:16 fontName:@""];
    self.wdNavigationBar.showBottomLabel = false;
}

#pragma mark  SetupSubviewsUI 
- (void)setupSubviews{
    self.view.backgroundColor = kMainBlack;
    
    self.accountView = [[UtilsManager shareInstance] createInputViewWithPlaceholder:@"请输入注册邮箱"
                                                                          maxLength:36
                                                                       leftIconName:@"account"
                                                                 keyboardAppearance:UIKeyboardAppearanceDark
                                                                       keyboardType:UIKeyboardTypeEmailAddress];
    [self.view addSubview:self.accountView];
    
    self.codeView = [[UtilsManager shareInstance] createInputViewWithPlaceholder:@"请输入验证码"
                                                                       maxLength:6
                                                                    leftIconName:@"password"
                                                              keyboardAppearance:UIKeyboardAppearanceAlert
                                                                    keyboardType:UIKeyboardTypePhonePad];
    [self.view addSubview:self.codeView];
    
    self.passwordView = [[UtilsManager shareInstance]createInputViewWithPlaceholder:@"请输入密码"
                                                                          maxLength:16
                                                                       leftIconName:@"password"
                                                                 keyboardAppearance:UIKeyboardAppearanceAlert
                                                                       keyboardType:UIKeyboardTypeEmailAddress];
    self.passwordView.textField.secureTextEntry = true;
    [self.view addSubview:self.passwordView];
    
    self.againPasswordView = [[UtilsManager shareInstance]createInputViewWithPlaceholder:@"请再次输入密码"
                                                                               maxLength:16
                                                                            leftIconName:@"password"
                                                                      keyboardAppearance:UIKeyboardAppearanceAlert
                                                                            keyboardType:UIKeyboardTypeEmailAddress];
    self.againPasswordView.textField.secureTextEntry = true;
    [self.view addSubview:self.againPasswordView];
    
    self.sureButton = [[UIButton alloc] initWithText:@"获取验证码"
                                           textColor:kMainWhite
                                            textFont:18
                                     backgroundColor:UIColor.clearColor];
    self.sureButton.layer.borderColor = kMainLightGreen.CGColor;
    self.sureButton.layer.borderWidth = 0.8;
    self.sureButton.layer.cornerRadius = kRealWidthValue(45/2);
    [self.sureButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sureButton];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] init];
    [self.indicatorView setHidesWhenStopped:true];
    [self.sureButton addSubview:self.indicatorView];
}

#pragma mark  SetupSubviewsConstraints 
- (void)setupSubviewsConstraints{
    
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(45));
        make.bottom.mas_equalTo(self.view.mas_centerY).mas_offset(kRealHeightValue(-60));
        make.height.mas_equalTo(kRealHeightValue(45));
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(50));
        make.top.mas_equalTo(self.accountView.mas_bottom).mas_offset(kRealHeightValue(45));
        make.height.mas_equalTo(kRealHeightValue(45));
    }];
    
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_trailing);
        make.top.mas_equalTo(self.accountView.mas_bottom).mas_offset(kRealHeightValue(25));
        make.height.mas_equalTo(kRealHeightValue(45));
    }];
    
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_trailing);
        make.top.mas_equalTo(self.codeView.mas_bottom).mas_offset(kRealHeightValue(25));
        make.height.mas_equalTo(kRealHeightValue(45));
    }];
    
    [self.againPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_trailing);
        make.top.mas_equalTo(self.passwordView.mas_bottom).mas_offset(kRealHeightValue(25));
        make.height.mas_equalTo(kRealHeightValue(45));
    }];
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.sureButton);
    }];
}

#pragma mark  发送验证码成功，修改视图样式
- (void)setOtherViewsConstraints {
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:1.2 animations:^{
        
        [self.codeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(45));
            make.top.mas_equalTo(self.accountView.mas_bottom).mas_offset(kRealHeightValue(25));
            make.height.mas_equalTo(kRealHeightValue(45));
        }];
        
        [self.passwordView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(45));
            make.top.mas_equalTo(self.codeView.mas_bottom).mas_offset(kRealHeightValue(25));
            make.height.mas_equalTo(kRealHeightValue(45));
        }];
        
        [self.againPasswordView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(45));
            make.top.mas_equalTo(self.passwordView.mas_bottom).mas_offset(kRealHeightValue(25));
            make.height.mas_equalTo(kRealHeightValue(45));
        }];
        
        [self.sureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.againPasswordView.mas_bottom).mas_offset(kRealHeightValue(45));
            make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(50));
            make.height.mas_equalTo(kRealHeightValue(45));
        }];
        
        [self.passwordView.superview layoutIfNeeded];
        [self.againPasswordView.superview layoutIfNeeded];
        [self.sureButton.superview layoutIfNeeded];
    }];
}

#pragma mark  按钮点击事件 
- (void)buttonAction:(UIButton *)button {
    [self.view endEditing:true];
    if (button.titleLabel.text.length == 5) {
        [self checkAccount];
    } else {
        [self sureModifyPassoword];
    }
}

#pragma mark  验证账号 
- (void)checkAccount {
    [[UtilsManager shareInstance] registerCheckEmial:self.accountView.textField.text showSuccess:^{
        [self.sureButton setTitle:@"" forState:UIControlStateNormal];
        [self.indicatorView startAnimating];
        [self sendCodeFromSever];
    }];
}

#pragma mark  验证输入 
- (void)sureModifyPassoword {
    [[UtilsManager shareInstance] forgetPasswordCheckWithEmial:self.accountView.textField.text
                                                     emailCode:self.codeView.textField.text
                                                      password:self.passwordView.textField.text
                                                 againPassword:self.againPasswordView.textField.text
                                                   showSuccess:^{
                                                       [self forgetPassowrdFromSever];
                                                   }];
}

#pragma mark  网络请求
// 发送验证码
- (void)sendCodeFromSever {
    [[BBSNetworkTool shareInstance] forgetPasswordRequsetEmailString:self.accountView.textField.text
                                                        successBlock:^(id  _Nonnull obj) {
                                                            [MFHUDManager showSuccess:@"验证已发送至邮箱，请注意查收!"];
                                                            [self.sureButton setTitle:@"确 定" forState:UIControlStateNormal];
                                                            [self.indicatorView stopAnimating];
                                                            [self setOtherViewsConstraints];
                                                            
                                                        } failBlock:^(id  _Nonnull obj) {
                                                            [self.indicatorView stopAnimating];
                                                            if ([obj[@"msg"] isEqualToString:@"请勿重复发送"]) {
                                                                [self.sureButton setTitle:@"确 定" forState:UIControlStateNormal];
                                                                [self setOtherViewsConstraints];
                                                            } else {
                                                                [self.sureButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                                                            }
                                                        }];
}

// 找回密码
- (void)forgetPassowrdFromSever {
    [[BBSNetworkTool shareInstance] forgetPasswordRequsetWithEmailString:self.accountView.textField.text
                                                               emailCode:self.codeView.textField.text
                                                                passowrd:self.passwordView.textField.text
                                                            successBlock:^(id  _Nonnull obj) {
                                                                [self.sureButton setTitle:@"确 定" forState:UIControlStateNormal];
                                                                [self.indicatorView stopAnimating];
                                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                    [MFHUDManager showSuccess:@"密码找回成功"];
                                                                    [self.navigationController popViewControllerAnimated:true];
                                                                });
                                                            } failBlock:^(id  _Nonnull obj) {
                                                                [self.sureButton setTitle:@"确 定" forState:UIControlStateNormal];
                                                                [self.indicatorView stopAnimating];
                                                            }];
}

@end
