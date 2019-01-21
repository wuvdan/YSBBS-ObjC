//
//  CommentTableViewCell.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/28.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "CommentTableViewCell.h"

@interface CommentTableViewCell ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *likeButton;


@end

@implementation CommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
        [self setupSubviewsConstraints];
        
    }
    return self;
}


- (void)setModel:(CommentModel *)model {
    _model = model;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",G_Http_URL,model.headPic]] placeholderImage:kImageName(@"Default")];
    self.nickNameLabel.text = model.nickname;
    self.titleLabel.text = model.content;
    self.timeLabel.text = model.createTime;
    
    [self.likeButton setTitle:[NSString stringWithFormat:@"%ld",(long)model.likeNum] forState:UIControlStateNormal];
    
    if (model.isLike) {
        self.likeButton.tintColor = kMainDarkGreen;
    } else {
        self.likeButton.tintColor = kMainGrey;
    }
}

#pragma mark - SetupSubviewsUI
- (void)setupSubviews{
    
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.layer.cornerRadius = kRealWidthValue(30/2);
    self.headerImageView.layer.masksToBounds = true;
    [self.contentView addSubview:self.headerImageView];
    
    self.nickNameLabel = [[UILabel alloc] initWithText:@"" textColor:kMainGrey textFont:13 textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nickNameLabel];
    
    self.titleLabel = [[UILabel alloc] initWithText:@"" textColor:kMainBlack textFont:15 textAlignment:NSTextAlignmentLeft];
    self.titleLabel.numberOfLines = 0;
    self.timeLabel = [[UILabel alloc] initWithText:@"" textColor:kMainGrey textFont:12 textAlignment:NSTextAlignmentLeft];
    [self.timeLabel sizeToFit];
    
    self.likeButton = [[UIButton alloc] initWithText:@"" textColor:kMainGrey textFont:12 imageName:@"item-btn-thumb-black" layoutStyle:WDDropDownButtonStyle_RightImage speace:kRealWidthValue(0) backgroundColor:UIColor.clearColor];
    [self.likeButton addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.likeButton.tintColor = kMainGrey;
    
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.likeButton];
}

- (void)likeButtonAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if ([self.likeButton.tintColor isEqual:kMainDarkGreen]) {
        self.likeButton.tintColor = kMainGrey;
        self.model.likeNum --;
        [self.likeButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.model.likeNum] forState:UIControlStateNormal];
    } else {
        self.likeButton.tintColor = kMainDarkGreen;
        self.model.likeNum ++;
        [self.likeButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.model.likeNum] forState:UIControlStateNormal];
    }
    
    if ([self.delegate respondsToSelector:@selector(likeCommentWithModel:)]) {
        [self.delegate likeCommentWithModel:self.model];
    }
}

#pragma mark - SetupSubviewsConstraints
- (void)setupSubviewsConstraints{
    
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(kRealWidthValue(30));
        make.top.mas_equalTo(self.contentView).inset(kRealHeightValue(10));
        make.leading.mas_equalTo(self.contentView).inset(kRealWidthValue(15));
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.headerImageView.mas_trailing).mas_offset(kRealWidthValue(10));
        make.trailing.mas_equalTo(self.contentView).inset(kRealWidthValue(15));
        make.centerY.mas_equalTo(self.headerImageView.mas_centerY);
    }];

    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.headerImageView);
        make.width.mas_equalTo(kSCREEN_WIDTH/6);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).inset(kRealWidthValue(15));
        make.trailing.mas_equalTo(self.likeButton.mas_leading);
        make.top.mas_equalTo(self.headerImageView.mas_bottom).mas_offset(kRealHeightValue(10));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(kRealHeightValue(10));
        make.leading.mas_equalTo(self.contentView).inset(kRealWidthValue(15));
        make.bottom.mas_equalTo(self.contentView).inset(kRealHeightValue(10));
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
