//
//  UserInfoHeaderView.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/27.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "UserInfoHeaderView.h"

@interface UserInfoHeaderView  ()

@end

@implementation UserInfoHeaderView

- (instancetype)init{

    self = [super init];
    if(self){
        [self setupSubviews];
        [self setupSubviewsConstraints];
    }
    return self;
}

#pragma mark - SetupSubviewsUI
- (void)setupSubviews{
    self.backgroundColor = kMainBlack;
    self.headerImageView = [[UIImageView alloc] init];
    [self addSubview:self.headerImageView];
    self.headerImageView.layer.cornerRadius = kSCREEN_WIDTH/8;
    self.headerImageView.layer.masksToBounds = true;
    self.headerImageView.layer.borderWidth = 1;
    self.headerImageView.layer.borderColor = kMainWhite.CGColor;
    self.headerImageView.userInteractionEnabled = true;
    [self.headerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePicker)]];
    
    self.postNumButton = [[UIButton alloc] init];
    self.postNumButton.tintColor = kMainWhite;
    [self addSubview:self.postNumButton];
}

- (void)imagePicker {
    if (self.imagePickerBlock) {
        self.imagePickerBlock();
    }
}

#pragma mark - SetupSubviewsConstraints
- (void)setupSubviewsConstraints{
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).mas_offset(-kRealHeightValue(10));
        make.width.height.mas_equalTo(kSCREEN_WIDTH/4);
    }];
    
    [self.postNumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.headerImageView.mas_bottom).mas_offset(kRealHeightValue(10));
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH/2);
}

@end
