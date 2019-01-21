//
//  PostArticleToolView.m
//  YSBBSApp
//
//  Created by wudan on 2018/11/14.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "PostArticleToolView.h"

@interface PostArticleToolView ()

@property (nonatomic, strong) UIView *topView;

@end

@implementation PostArticleToolView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        
        self.topView = [[UIView alloc] init];
        self.topView.backgroundColor = UIColor.lightGrayColor;
        [self addSubview:self.topView];
        
        self.chooseImageButton = [[UIButton alloc] initWithText:@" 添加图片 "
                                                      textColor:kMainDarkGreen
                                                       textFont:11
                                                backgroundColor:UIColor.whiteColor];
        self.chooseImageButton.layer.cornerRadius = 5;
        self.chooseImageButton.layer.borderColor = kMainDarkGreen.CGColor;
        self.chooseImageButton.layer.borderWidth = 1;
        [self addSubview:self.chooseImageButton];
        
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.chooseImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self).inset(kRealHeightValue(10));
            make.leading.mas_equalTo(self).inset(kRealWidthValue(15));
            make.width.mas_equalTo(self.chooseImageButton.mas_height).multipliedBy(1.7);
        }];
    }
    return self;
}
@end
