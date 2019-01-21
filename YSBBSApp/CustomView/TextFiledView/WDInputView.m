//
//  WDInputView.m
//  BBSApp
//
//  Created by 吴丹 on 2018/8/14.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "WDInputView.h"

@interface WDInputView  ()<UITextFieldDelegate>

/** 左侧图标 */
@property (nonatomic, strong) UIImageView * leftIcon;
/** 上浮的占位文本 */
@property (nonatomic, strong) UILabel * headerPlaceLabel;
/** 字数限制文本 */
@property (nonatomic, strong) UILabel * lengthLabel;
/** 底部分割线 */
@property (nonatomic, strong) UIView * bottomLine;
/** 错误提示信息 */
@property (nonatomic, strong) UILabel * errorLabel;

@end

@implementation WDInputView


- (instancetype)init{

    self = [super init];
    if(self){
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.textColor = kRGBA(85, 85, 85,1);
        self.textLengthLabelColor = kMainWhite;
        self.lineDefaultColor = kRGBA(220, 220, 220,1);
        self.lineSelectedColor = kRGBA(1, 183, 164,1);
        self.lineWarningColor = kRGBA(252, 57, 24,1);
        self.errorLableColor = kRGBA(252, 57, 24, 1);
    }
    return self;
}

#pragma mark -------------------- 在layoutSubviews方法中设置子控件的frame --------------------
- (void)layoutSubviews
{
    [super layoutSubviews];
    kWeakSelf(self);
    [self addSubview:self.leftIcon];
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidthValue(20), kRealHeightValue(30)));
        make.centerY.equalTo(weakself);
        make.left.equalTo(weakself).offset(kRealWidthValue(10));
    }];
    
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakself).mas_offset(kRealWidthValue(-40));
        make.centerY.equalTo(weakself);
        make.height.mas_equalTo(kRealHeightValue(30));
        make.left.equalTo(weakself.leftIcon.mas_right).offset(kRealWidthValue(8));
    }];
    
    [self addSubview:self.headerPlaceLabel];
    [self.headerPlaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {    
        make.left.equalTo(weakself.leftIcon.mas_left);
        make.bottom.equalTo(weakself.textField.mas_top);
    }];
    
    [self addSubview:self.lengthLabel];
    [self.lengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidthValue(40), kRealWidthValue(15)));
        make.left.equalTo(weakself.textField.mas_right);
        make.bottom.equalTo(weakself.textField.mas_bottom);
    }];
    
    [self addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakself);
        make.height.mas_equalTo(1);
        make.left.equalTo(weakself.leftIcon.mas_left);
        make.top.equalTo(weakself.textField.mas_bottom);
    }];
    
    [self addSubview:self.errorLabel];
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidthValue(100), kRealHeightValue(15)));
        make.left.equalTo(weakself.leftIcon.mas_left);
        make.top.equalTo(weakself.bottomLine.mas_bottom);
    }];
}

#pragma mark -------------------- 懒加载控件 --------------------
- (UITextField *) textField{
    if(!_textField){
        _textField = [UITextField new];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = self.textColor;
        _textField.font = [UIFont systemFontOfSize:kRealWidthValue(15)];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.placeholder = self.placeholder;
        _textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIImageView *) leftIcon{
    if(!_leftIcon){
        _leftIcon = [UIImageView new];
        _leftIcon.contentMode = UIViewContentModeScaleAspectFit;
        _leftIcon.backgroundColor = [UIColor clearColor];
        _leftIcon.image = [UIImage imageNamed:self.leftIconName];
    }
    return _leftIcon;
}

- (UILabel *) headerPlaceLabel{
    if(!_headerPlaceLabel){
        _headerPlaceLabel = [UILabel new];
        _headerPlaceLabel.backgroundColor = [UIColor clearColor];
        _headerPlaceLabel.textColor = self.remindTextColor;
        _headerPlaceLabel.textAlignment = NSTextAlignmentLeft;
        _headerPlaceLabel.font = [UIFont systemFontOfSize:kRealWidthValue(14)];
        _headerPlaceLabel.text = self.textField.placeholder;
        _headerPlaceLabel.alpha = 0.0;
    }
    return _headerPlaceLabel;
}

- (UILabel *) lengthLabel{
    if(!_lengthLabel){
        _lengthLabel = [UILabel new];
        _lengthLabel.backgroundColor = [UIColor clearColor];
        _lengthLabel.textColor = kRGBA(92, 94, 102, 1);
        _lengthLabel.textAlignment = NSTextAlignmentRight;
        _lengthLabel.font = [UIFont systemFontOfSize:kRealWidthValue(11)];
        _lengthLabel.text = [[NSString alloc]initWithFormat:@"0/%ld",(long)self.maxLength];
    }
    return _lengthLabel;
}

- (UIView *) bottomLine{
    if(!_bottomLine){
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = self.lineDefaultColor;
    }
    return _bottomLine;
}

- (UILabel *) errorLabel{
    if(!_errorLabel){
        _errorLabel = [UILabel new];
        _errorLabel.backgroundColor = [UIColor clearColor];
        _errorLabel.textColor = self.errorLableColor;
        _errorLabel.font = [UIFont systemFontOfSize:kRealWidthValue(12)];
        _errorLabel.textAlignment = NSTextAlignmentLeft;
        _errorLabel.text = self.errorStr;
        _errorLabel.alpha = 0.0;
    }
    return _errorLabel;
}

#pragma mark -------------------- UITextFieldDelegate --------------------
- (void)textFieldEditingChanged:(UITextField *)sender
{
    if (sender.text.length > self.maxLength) {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.errorLabel.alpha = 1.0;
            self.errorLabel.textColor = self.lineWarningColor;
            self.bottomLine.backgroundColor = self.lineWarningColor;
            self.lengthLabel.textColor = self.lineWarningColor;
            self.textField.textColor = self.lineWarningColor;
            //self.placeHolderLabel.textColor = self.lineWarningColor;
        } completion:nil];
    }else{
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.errorLabel.alpha = 0.0;
            self.bottomLine.backgroundColor = self.lineSelectedColor;
            self.lengthLabel.textColor = self.textLengthLabelColor;
            self.textField.textColor = self.textColor;
            //self.placeHolderLabel.textColor = self.placeHolderLabelColor;
        } completion:nil];
    }
    self.lengthLabel.text = [NSString stringWithFormat:@"%lu/%zd",sender.text.length,self.maxLength];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self setPlaceHolderLabelHidden:NO];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self setPlaceHolderLabelHidden:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    
    [self setPlaceHolderLabelHidden:YES];
    
    return YES;
}

#pragma mark -------------------- 占位符提示 --------------------
- (void)setPlaceHolderLabelHidden:(BOOL)isHidden
{
    if (isHidden) {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.headerPlaceLabel.alpha = 0.0f;
            self.textField.placeholder = self.placeholder;
            self.bottomLine.backgroundColor = self.lineDefaultColor;
        } completion:nil];
    }else{
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.headerPlaceLabel.alpha = 1.0f;
            self.headerPlaceLabel.text = self.placeholder;
            self.textField.placeholder = @"";
            self.bottomLine.backgroundColor = self.lineSelectedColor;
        } completion:nil];
    }
}


@end
