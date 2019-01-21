//
//  PostCommentToolView.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/28.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "PostCommentToolView.h"

@implementation PostCommentToolView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = kMainBlack;
        [self setupSubViews];
        [self setupSubViewsConstants];
    }
    return self;
}

- (void)setupSubViews {
    self.textView = [[WDTextView alloc] init];
    self.textView.placeholder = @"输入您的评论...";
    self.textView.placeholderFont = kFont(15);
    self.textView.placeholderColor = kMainGrey;
    self.textView.backgroundColor = kMainWhite;
    self.textView.layer.cornerRadius = kRealWidthValue(10);
    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.isAutoHeightEnable = true;
    [self addSubview:self.textView];
    
    self.likeNumButton = [[UIButton alloc] initWithText:@"" textColor:kMainGrey textFont:12 imageName:@"item-btn-thumb-black" layoutStyle:WDDropDownButtonStyle_RightImage speace:kRealWidthValue(0) backgroundColor:UIColor.clearColor];
    self.likeNumButton.tintColor = kMainWhite;
    [self addSubview:self.likeNumButton];
    
    self.publicButton = [[UIButton alloc] initWithText:@"" textColor:kMainGrey textFont:12 imageName:@"send" layoutStyle:WDDropDownButtonStyle_RightImage speace:kRealWidthValue(0) backgroundColor:UIColor.clearColor];
    self.publicButton.tintColor = kMainWhite;
    [self addSubview:self.publicButton];
}

- (void)setupSubViewsConstants {
    
    [self.likeNumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.leading.mas_equalTo(self);
        make.width.mas_equalTo(kSCREEN_WIDTH/6);
    }];
    
    [self.publicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.trailing.mas_equalTo(self);
        make.width.mas_equalTo(kSCREEN_WIDTH/6);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self).inset(kRealHeightValue(10));
        make.trailing.mas_equalTo(self.publicButton.mas_leading).mas_offset(kRealHeightValue(-5));
        make.leading.mas_equalTo(self.likeNumButton.mas_trailing).mas_offset(kRealHeightValue(5));
    }];
}

@end
