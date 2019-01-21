//
//  RegisterViewController.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/24.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

/** < Account in put view > */
@property (nonatomic, strong) WDInputView *accountView;
/** < Emial in put view > */
@property (nonatomic, strong) WDInputView *emailView;
/** < Email Code in put view > */
@property (nonatomic, strong) WDInputView *emailCodeView;
/** < Password in put view > */
@property (nonatomic, strong) WDInputView *passwordView;
/** < Password again in put view > */
@property (nonatomic, strong) WDInputView *againPasswordView;
/** < login button > */
@property (nonatomic, strong) UIButton    *sureButton;
/** < view wait network show > */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation RegisterViewController

#pragma mark  LifeCyle 
- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark  DidReceiveMemoryWarning 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark  SetupNavigationBar 
- (void)setupNavigationBar{
    [super setupNavigationBar];
    [self.wdNavigationBar.centerButton setTitle:@"Register" forState:UIControlStateNormal];
    self.wdNavigationBar.centerButton.titleLabel.font = [[UtilsManager shareInstance] createSytemFontSize:16 fontName:@""];
    self.wdNavigationBar.showBottomLabel = false;
}

#pragma mark  SetupSubviewsUI 
- (void)setupSubviews{
    self.view.backgroundColor = kMainBlack;

    self.accountView = [[UtilsManager shareInstance] createInputViewWithPlaceholder:@"请输入账号"
                                                                          maxLength:16
                                                                       leftIconName:@"account"
                                                                 keyboardAppearance:UIKeyboardAppearanceAlert
                                                                       keyboardType:UIKeyboardTypeEmailAddress];
    [self.view addSubview:self.accountView];
    
    self.emailView = [[UtilsManager shareInstance] createInputViewWithPlaceholder:@"请输入常用邮箱"
                                                                        maxLength:36
                                                                     leftIconName:@"account"
                                                               keyboardAppearance:UIKeyboardAppearanceAlert
                                                                     keyboardType:UIKeyboardTypeEmailAddress];
    [self.view addSubview:self.emailView];
    
    self.emailCodeView = [[UtilsManager shareInstance] createInputViewWithPlaceholder:@"请输入验证码"
                                                                            maxLength:6
                                                                         leftIconName:@"password"
                                                                   keyboardAppearance:UIKeyboardAppearanceAlert
                                                                         keyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:self.emailCodeView];

    self.passwordView = [[UtilsManager shareInstance] createInputViewWithPlaceholder:@"请输入密码"
                                                                           maxLength:16
                                                                        leftIconName:@"password"
                                                                  keyboardAppearance:UIKeyboardAppearanceAlert
                                                                        keyboardType:UIKeyboardTypeDefault];
    self.passwordView.textField.secureTextEntry = true;
    [self.view addSubview:self.passwordView];

    self.againPasswordView = [[UtilsManager shareInstance] createInputViewWithPlaceholder:@"请再次输入密码"
                                                                                maxLength:16
                                                                             leftIconName:@"password"
                                                                       keyboardAppearance:UIKeyboardAppearanceAlert
                                                                             keyboardType:UIKeyboardTypeDefault];
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
    
    [self.emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(45));
        make.bottom.mas_equalTo(self.view.mas_centerY).mas_offset(kRealHeightValue(-25));
        make.height.mas_equalTo(kRealHeightValue(45));
    }];
    
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(50));
        make.top.mas_equalTo(self.view.mas_centerY).mas_offset(kRealHeightValue(30));
        make.height.mas_equalTo(kRealHeightValue(45));
    }];
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.sureButton);
    }];
    
    
    [self.emailCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_trailing).inset(kRealWidthValue(45));
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.height.mas_equalTo(kRealHeightValue(45));
    }];

    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_trailing).inset(kRealWidthValue(45));
        make.top.mas_equalTo(self.emailCodeView.mas_bottom).mas_offset(kRealHeightValue(25));
        make.height.mas_equalTo(kRealHeightValue(45));
    }];

    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_trailing).inset(kRealWidthValue(45));
        make.bottom.mas_equalTo(self.emailView.mas_top).mas_offset(kRealHeightValue(-25));
        make.height.mas_equalTo(kRealHeightValue(45));
    }];
    
    [self.againPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_trailing).inset(kRealWidthValue(45));
        make.top.mas_equalTo(self.passwordView.mas_bottom).mas_offset(kRealHeightValue(25));
        make.height.mas_equalTo(kRealHeightValue(45));
    }];
}

#pragma mark  发送验证码成功，修改视图样式 
- (void)registerViewConstants {
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.emailCodeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(45));
            make.centerY.mas_equalTo(self.view.mas_centerY);
            make.height.mas_equalTo(kRealHeightValue(45));
        }];

        [self.passwordView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(45));
            make.top.mas_equalTo(self.emailCodeView.mas_bottom).mas_offset(kRealHeightValue(25));
            make.height.mas_equalTo(kRealHeightValue(45));
        }];

        [self.emailView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(45));
            make.bottom.mas_equalTo(self.emailCodeView.mas_top).mas_offset(kRealHeightValue(-25));
            make.height.mas_equalTo(kRealHeightValue(45));
        }];

        [self.accountView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(45));
            make.bottom.mas_equalTo(self.emailView.mas_top).mas_offset(kRealHeightValue(-25));
            make.height.mas_equalTo(kRealHeightValue(45));
        }];

        [self.againPasswordView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(45));
            make.top.mas_equalTo(self.passwordView.mas_bottom).mas_offset(kRealHeightValue(25));
            make.height.mas_equalTo(kRealHeightValue(45));
        }];

        [self.sureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(50));
            make.top.mas_equalTo(self.againPasswordView.mas_bottom).mas_offset(kRealHeightValue(30));
            make.height.mas_equalTo(kRealHeightValue(45));
        }];

        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.sureButton);
        }];
        
        [self.emailCodeView.superview layoutIfNeeded];
        [self.passwordView.superview layoutIfNeeded];
        [self.emailView.superview layoutIfNeeded];
        [self.accountView.superview layoutIfNeeded];
        [self.againPasswordView.superview layoutIfNeeded];
        [self.sureButton.superview layoutIfNeeded];
        [self.indicatorView.superview layoutIfNeeded];
    }];
}

#pragma mark  点击事件 
- (void)buttonAction:(UIButton *)button {
    [self.view endEditing:true];
    
    if (button.titleLabel.text.length == 5) {
        [self checkEmial];
    } else {
        [self checkInput];
    }
}

#pragma mark  检测邮箱输入 
- (void)checkEmial {
    [[UtilsManager shareInstance] registerCheckEmial:self.emailView.textField.text showSuccess:^{
        [self.sureButton setTitle:@"" forState:UIControlStateNormal];
        [self.indicatorView startAnimating];
        [self registerSenderEamilCode];
    }];
}

#pragma mark  检测输入格式 
- (void)checkInput {
    [[UtilsManager  shareInstance] registerLimtWithAcount:self.accountView.textField.text
                                              emailString:self.emailView.textField.text
                                                emailCode:self.emailCodeView.textField.text
                                                 password:self.passwordView.textField.text
                                            againPassword:self.againPasswordView.textField.text
                                              showSuccess:^{
                                                  [self.sureButton setTitle:@"" forState:UIControlStateNormal];
                                                  [self.indicatorView startAnimating];
                                                  [self registerFromSever];
                                              }];
}

#pragma mark  网络请求 
/** < 注册 > */
- (void)registerFromSever {
    [[BBSNetworkTool shareInstance] registerRequsetWithAccount:self.accountView.textField.text
                                                   emailString:self.emailView.textField.text
                                                     emailCode:self.emailCodeView.textField.text
                                                      passowrd:self.passwordView.textField.text
                                                  successBlock:^(id  _Nonnull obj) {
                                                       [[LZRemindBar configurationWithStyle:RemindBarStyleInfo showPosition:RemindBarPositionStatusBar contentText:@"注册成功"] showBarAfterTimeInterval:1.2];
                                                      
                                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                            [self.navigationController popViewControllerAnimated:true];
                                                        });
                                                   } failBlock:^(id  _Nonnull obj) {
                                                       [self.sureButton setTitle:@"注 册" forState:UIControlStateNormal];
                                                       [self.indicatorView stopAnimating];
                                                   }];
}

/** < 发送验证码 > */
- (void)registerSenderEamilCode {
    
    [[BBSNetworkTool shareInstance] registerRequsetEmailString:self.emailView.textField.text successBlock:^(id  _Nonnull obj) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleWarn showPosition:RemindBarPositionStatusBar contentText:@"验证码已发送至邮箱，请注意查收！"] showBarAfterTimeInterval:1.2];
        [self.sureButton setTitle:@"注 册" forState:UIControlStateNormal];
        [self.indicatorView stopAnimating];
        [self registerViewConstants];
    } failBlock:^(id  _Nonnull obj) {
        if ([obj[@"msg"] isEqualToString:@"请勿重复发送"]) {
            [self.sureButton setTitle:@"注 册" forState:UIControlStateNormal];
            [self.indicatorView stopAnimating];
            [self registerViewConstants];
        } else {
            [self.sureButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.indicatorView stopAnimating];
        }
    }];
}

@end
