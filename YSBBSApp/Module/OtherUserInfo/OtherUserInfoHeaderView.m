//
//  OtherUserInfoHeaderView.m
//  YSBBSApp
//
//  Created by wudan on 2019/2/14.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import "OtherUserInfoHeaderView.h"
#import "OtherUserInfoModel.h"

@interface OtherUserInfoHeaderView ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *topicNumLabel;
@property (nonatomic, strong) UILabel *fansNumLabel;
@property (nonatomic, strong) UILabel *getLikeNumLabel;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) OtherUserInfoModel *model;
@end

@implementation OtherUserInfoHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
        [self setupUIConstants];
    }
    return self;
}

- (void)setupWithModel:(OtherUserInfoModel *)model {
    self.model = model;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", G_Http_URL, model.headPic]] placeholderImage:kImageName(@"Default")];
    self.nickNameLabel.text = model.nickname;
    
    NSMutableAttributedString *lickAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n获赞", model.getLikeNum]];
    [lickAtt addAttribute:NSForegroundColorAttributeName value:UIColor.whiteColor range:NSMakeRange(0, [[NSString stringWithFormat:@"%ld", model.getLikeNum] length])];
    [lickAtt addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, [[NSString stringWithFormat:@"%ld", model.getLikeNum] length])];
    self.getLikeNumLabel.attributedText = lickAtt;
    
    NSMutableAttributedString *topicNumAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n发帖", model.topicNum]];
    [topicNumAtt addAttribute:NSForegroundColorAttributeName value:UIColor.whiteColor range:NSMakeRange(0, [[NSString stringWithFormat:@"%ld", model.topicNum] length])];
    [topicNumAtt addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, [[NSString stringWithFormat:@"%ld", model.topicNum] length])];
    self.topicNumLabel.attributedText = topicNumAtt;
    
    NSMutableAttributedString *fansNumAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n粉丝", model.fansNum]];
    [fansNumAtt addAttribute:NSForegroundColorAttributeName value:UIColor.whiteColor range:NSMakeRange(0, [[NSString stringWithFormat:@"%ld", model.fansNum] length])];
    [fansNumAtt addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, [[NSString stringWithFormat:@"%ld", model.fansNum] length])];
    self.fansNumLabel.attributedText = fansNumAtt;
    
    self.followButton.selected = model.isFollow;
}

- (void)setupUI {
    self.backgroundColor = kMainBlack;
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.clipsToBounds          = false;
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.layer.cornerRadius  = 100/2 * kScreenWidthRate;
    self.headerImageView.layer.masksToBounds = true;
    self.headerImageView.layer.borderWidth   = 1;
    self.headerImageView.layer.borderColor   = kMainWhite.CGColor;
    [self addSubview:self.headerImageView];
    
    self.nickNameLabel = [[UILabel alloc] init];
    self.nickNameLabel.textAlignment = NSTextAlignmentCenter;
    self.nickNameLabel.font = [UIFont systemFontOfSize:15];
    self.nickNameLabel.textColor = UIColor.whiteColor;
    [self addSubview:self.nickNameLabel];
    
    self.topicNumLabel = [[UILabel alloc] init];
    self.topicNumLabel.numberOfLines = 2;
    self.topicNumLabel.textAlignment = NSTextAlignmentCenter;
    self.topicNumLabel.font = [UIFont systemFontOfSize:15];
    self.topicNumLabel.textColor = UIColor.lightGrayColor;
    [self addSubview:self.topicNumLabel];
    
    self.fansNumLabel = [[UILabel alloc] init];
    self.fansNumLabel.numberOfLines = 2;
    self.fansNumLabel.textAlignment = NSTextAlignmentCenter;
    self.fansNumLabel.font = [UIFont systemFontOfSize:15];
    self.fansNumLabel.textColor = UIColor.lightGrayColor;
    [self addSubview:self.fansNumLabel];
    
    self.getLikeNumLabel = [[UILabel alloc] init];
    self.getLikeNumLabel.numberOfLines = 2;
    self.getLikeNumLabel.textAlignment = NSTextAlignmentCenter;
    self.getLikeNumLabel.font = [UIFont systemFontOfSize:15];
    self.getLikeNumLabel.textColor = UIColor.lightGrayColor;
    [self addSubview:self.getLikeNumLabel];
    
    self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.followButton setTitle:@"关 注" forState:UIControlStateNormal];
    [self.followButton setTitle:@"已关注" forState:UIControlStateSelected];
    [self.followButton setTitleColor:kMainLightGreen forState:UIControlStateNormal];
    self.followButton.layer.borderColor = kMainLightGreen.CGColor;
    self.followButton.layer.borderWidth = 0.5;
    self.followButton.layer.cornerRadius = 5 * kScreenWidthRate;
    self.followButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.followButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.followButton];
}

- (void)followButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(followActionWithModel:)]) {
        [self.delegate followActionWithModel:self.model];
    }
}

- (void)setupUIConstants {
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_centerY).mas_offset(-10 * kScreenWidthRate);
        make.width.height.mas_equalTo(100 * kScreenWidthRate);
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_centerY).mas_offset(10 * kScreenWidthRate);
    }];
    
    [self.fansNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.nickNameLabel.mas_bottom).mas_offset(20 * kScreenWidthRate);
        make.width.mas_equalTo(kSCREEN_WIDTH/3);
    }];
    
    [self.topicNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self);
        make.centerY.mas_equalTo(self.fansNumLabel);
        make.width.mas_equalTo(kSCREEN_WIDTH/3);
    }];
    
    [self.getLikeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self);
        make.centerY.mas_equalTo(self.fansNumLabel);
        make.width.mas_equalTo(kSCREEN_WIDTH/3);
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.fansNumLabel.mas_bottom).mas_offset(15 * kScreenWidthRate);
        make.width.mas_equalTo(kSCREEN_WIDTH/3);
    }];
}


@end
