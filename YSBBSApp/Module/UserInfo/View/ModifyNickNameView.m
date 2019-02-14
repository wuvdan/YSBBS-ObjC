//
//  ModifyNickNameView.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/27.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "ModifyNickNameView.h"

@interface ModifyNickNameView  ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *headerLine;
@property (nonatomic, strong) UITextField *textFiled;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIView *buttonLine;
@property (nonatomic, strong) UIView *buttonSpeaceLine;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation ModifyNickNameView

- (instancetype)init{

    self = [super init];
    if(self){
        [self setupSubviews];
        [self setupSubviewsConstraints];
        
        [self addObserver];
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
   
    [self.textFiled resignFirstResponder];
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIView"]) {
        return NO;
    }
    return YES;
}

- (void)showView {
    [super showView];
    [self.textFiled becomeFirstResponder];
}

// 添加通知监听见键盘弹出/退出
- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -  键盘监听事件
- (void)keyboardAction:(NSNotification*)sender{
    NSDictionary *useInfo = [sender userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    if ([sender.name isEqualToString:UIKeyboardWillShowNotification]) {
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self).inset(kRealWidthValue(30));
            make.bottom.mas_equalTo(self).inset([value CGRectValue].size.height);
            make.height.mas_equalTo(self.containerView.mas_width).multipliedBy(0.7);
        }];
    } else {
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self).inset(kRealWidthValue(30));
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(self.containerView.mas_width).multipliedBy(0.7);
        }];
    }
}

#pragma mark - SetupSubviewsUI
- (void)setupSubviews{
        
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = UIColor.whiteColor;
    self.containerView.layer.cornerRadius = kRealWidthValue(10);
    [self addSubview:self.containerView];
    
    self.titleLabel = [[UILabel alloc] initWithText:@"修改昵称"
                                          textColor:kMainBlack
                                           textFont:18
                                      textAlignment:NSTextAlignmentCenter];
    [self.containerView addSubview:self.titleLabel];
    
    self.headerLine = [[UIView alloc] init];
    self.headerLine.backgroundColor = kMainGrey;
    [self.containerView addSubview:self.headerLine];
    
    self.buttonLine = [[UIView alloc] init];
    self.buttonLine.backgroundColor = kMainGrey;
    [self.containerView addSubview:self.buttonLine];
    
    self.buttonSpeaceLine = [[UIView alloc] init];
    self.buttonSpeaceLine.backgroundColor = kMainGrey;
    [self.containerView addSubview:self.buttonSpeaceLine];
    
    self.cancelButton = [[UIButton alloc] initWithText:@"取消"
                                             textColor:UIColor.redColor
                                              textFont:16
                                       backgroundColor:UIColor.clearColor];
    [self.cancelButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.cancelButton];
    
    self.sureButton = [[UIButton alloc] initWithText:@"确定"
                                           textColor:kMainBlack
                                            textFont:16
                                     backgroundColor:UIColor.clearColor];
    [self.sureButton addTarget:self action:@selector(modifyNickName:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.sureButton];
    
    self.textFiled = [[UITextField alloc] init];
    self.textFiled.placeholder = @"请输入你要修改的昵称~";
    self.textFiled.font = kFont(15);
    self.textFiled.borderStyle = UITextBorderStyleRoundedRect;
    self.textFiled.backgroundColor = kMainWhite;
    [self.containerView addSubview:self.textFiled];
}

#pragma mark - SetupSubviewsConstraints
- (void)setupSubviewsConstraints{
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(kRealWidthValue(30));
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(self.containerView.mas_width).multipliedBy(0.7);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.containerView);
        make.top.mas_equalTo(self.containerView).inset(kRealHeightValue(10));
    }];
    
    [self.headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.containerView);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(kRealHeightValue(10));
        make.height.mas_equalTo(0.5);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.mas_equalTo(self.containerView);
        make.width.mas_equalTo(self.containerView.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(self.cancelButton.mas_width).multipliedBy(0.3);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.mas_equalTo(self.containerView);
        make.width.mas_equalTo(self.containerView.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(self.cancelButton.mas_width).multipliedBy(0.3);
    }];
    
    [self.buttonLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.containerView);
        make.bottom.mas_equalTo(self.cancelButton.mas_top);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.containerView).inset(kRealWidthValue(15));
        make.centerY.mas_equalTo(self.containerView);
        make.height.mas_equalTo(kRealHeightValue(45));
    }];
    
    [self.buttonSpeaceLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView);
        make.bottom.top.mas_equalTo(self.cancelButton);
        make.width.mas_equalTo(0.5);
    }];
}

- (void)modifyNickName:(id)sender {
    if (self.textFiled.text.length == 0) {
        [MFHUDManager showError:@"请输入昵称"];
        return;
    }

    if (self.changeNickNameHandler) {
        self.changeNickNameHandler(self.textFiled.text);
    }
}

@end
