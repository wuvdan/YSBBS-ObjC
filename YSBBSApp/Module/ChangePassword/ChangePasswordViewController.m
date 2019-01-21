//
//  ChangePasswordViewController.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/28.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

/** < Account in put view > */
@property (nonatomic, strong) WDInputView *oldPasswordView;
/** < Password in put view > */
@property (nonatomic, strong) WDInputView *passwordView;
/** < Password again in put view > */
@property (nonatomic, strong) WDInputView *againPasswordView;
/** < login button > */
@property (nonatomic, strong) UIButton    *sureButton;
/** < view wait network show > */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation ChangePasswordViewController

#pragma mark  LifeCyle 
- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark  SetupNavigationBar 
- (void)setupNavigationBar{
    [super setupNavigationBar];
    [self.wdNavigationBar.centerButton setTitle:@"ModifyPassowrd" forState:UIControlStateNormal];
    self.wdNavigationBar.centerButton.titleLabel.font = [[UtilsManager shareInstance] createSytemFontSize:16 fontName:@""];
    self.wdNavigationBar.showBottomLabel = false;
}

#pragma mark  SetupSubviewsUI 
- (void)setupSubviews{
    self.view.backgroundColor = kMainBlack;
    
    self.oldPasswordView = [[UtilsManager shareInstance] createInputViewWithPlaceholder:@"请输入旧密码"
                                                                              maxLength:16
                                                                           leftIconName:@"account"
                                                                     keyboardAppearance:UIKeyboardAppearanceAlert
                                                                           keyboardType:UIKeyboardTypeEmailAddress];
    [self.view addSubview:self.oldPasswordView];
    
    self.passwordView = [[UtilsManager shareInstance] createInputViewWithPlaceholder:@"请输入密码"
                                                                           maxLength:16
                                                                        leftIconName:@"password"
                                                                  keyboardAppearance:UIKeyboardAppearanceAlert
                                                                        keyboardType:UIKeyboardTypeEmailAddress];
    self.passwordView.textField.secureTextEntry = true;
    [self.view addSubview:self.passwordView];
    
    self.againPasswordView = [[UtilsManager shareInstance] createInputViewWithPlaceholder:@"请再次输入密码"
                                                                                maxLength:16
                                                                             leftIconName:@"password"
                                                                       keyboardAppearance:UIKeyboardAppearanceAlert
                                                                             keyboardType:UIKeyboardTypeEmailAddress];
    self.againPasswordView.textField.secureTextEntry = true;
    [self.view addSubview:self.againPasswordView];
    
    self.sureButton = [[UIButton alloc] initWithText:@"确 定"
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
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(45));
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.height.mas_equalTo(kRealHeightValue(45));
    }];
    
    [self.oldPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(45));
        make.bottom.mas_equalTo(self.passwordView.mas_top).mas_offset(kRealHeightValue(-25));
        make.height.mas_equalTo(kRealHeightValue(45));
    }];
    
    [self.againPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(45));
        make.top.mas_equalTo(self.passwordView.mas_bottom).mas_offset(kRealHeightValue(25));
        make.height.mas_equalTo(kRealHeightValue(45));
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(kRealWidthValue(50));
        make.top.mas_equalTo(self.againPasswordView.mas_bottom).mas_offset(kRealHeightValue(30));
        make.height.mas_equalTo(kRealHeightValue(45));
    }];
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.sureButton);
    }];
}

#pragma mark  按钮点击事件 
- (void)buttonAction:(UIButton *)button {
    [[UtilsManager shareInstance] modifyPassowordLimtWitholdPassword:self.oldPasswordView.textField.text
                                                            password:self.passwordView.textField.text
                                                       againPassword:self.againPasswordView.textField.text
                                                         showSuccess:^{
                                                             [button setTitle:@"" forState:UIControlStateNormal];
                                                             [self.indicatorView startAnimating];
                                                             [self registerFromSever];
                                                         }];
}

#pragma mark  网络请求 
- (void)registerFromSever {
    [[BBSNetworkTool shareInstance] modifyPasswordWithOldPassword:self.oldPasswordView.textField.text aNewPassword:self.passwordView.textField.text successBlock:^(id  _Nonnull obj) {
        [self.sureButton setTitle:@"确 定" forState:UIControlStateNormal];
        [self.indicatorView stopAnimating];
    } failBlock:^(id  _Nonnull obj) {
        [self.sureButton setTitle:@"确 定" forState:UIControlStateNormal];
        [self.indicatorView stopAnimating];
    }];
}

@end
