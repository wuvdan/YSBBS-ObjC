//
//  MessageTableViewCell.m
//  YSBBSApp
//
//  Created by wudan on 2019/1/25.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "MessageMode.h"

@interface MessageTableViewCell ()
@property (nonatomic, strong) UILabel *messagerType; //!< 消息类型
@property (nonatomic, strong) UIView  *dotView;      //!< 是否已读的标识
@property (nonatomic, strong) UILabel *titleLabel;   //!< 标题
@property (nonatomic, strong) UILabel *timeLabel;    //!< 时间

@property (nonatomic, strong) UIView *spaceLine; //!< 分割线
@property (nonatomic, strong) UILabel *checkInfoLabel; //!< 查看详情
@property (nonatomic, strong) UIImageView *leftImageView;
@end

@implementation MessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setModel:(MessageMode *)model {
    _model = model;
    
    if (model.messageType == 0) {
        self.messagerType.text = @"系统消息";
    } else {
        self.messagerType.text = @"个人消息";
    }
    
    self.titleLabel.text = model.messageTitle;
    self.timeLabel.text = model.createTime;
    
    if (model.isRead) {
        self.dotView.backgroundColor = UIColor.lightGrayColor;
    } else {
        self.dotView.backgroundColor = kMainLightGreen;
    }
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x = kRealWidthValue(15);
    frame.size.width -= frame.origin.x + kRealWidthValue(15);
    [super setFrame:frame];
}

- (void)setupUI {
    self.dotView = [[UIView alloc] init];
    self.dotView.backgroundColor = kMainLightGreen;
    [self.contentView addSubview:self.dotView];
    
    self.dotView.layer.cornerRadius = kRealWidthValue(15)/2;
    self.dotView.layer.masksToBounds = true;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.timeLabel];
    
    self.messagerType = [[UILabel alloc] init];
    self.messagerType.textColor = UIColor.blackColor;
    self.messagerType.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.messagerType];
    
    self.spaceLine = [[UIView alloc] init];
    self.spaceLine.backgroundColor = UIColor.lightGrayColor;
    [self.contentView addSubview:self.spaceLine];

    self.checkInfoLabel = [[UILabel alloc] init];
    self.checkInfoLabel.font = [UIFont systemFontOfSize:13];
    self.checkInfoLabel.textColor = [UIColor lightGrayColor];
    self.checkInfoLabel.text = @"查看详情";
    [self.contentView addSubview:self.checkInfoLabel];
    
    self.leftImageView = [[UIImageView alloc] init];
    self.leftImageView.image = [[UIImage imageNamed:@"right"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.leftImageView.tintColor = UIColor.lightGrayColor;
    self.leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.leftImageView];
}

- (void)setupLayout {
    
    [self.dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(self.contentView).inset(15 * kScreenWidthRate);
        make.height.width.mas_equalTo(15 * kScreenWidthRate);
    }];
    
    [self.messagerType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.dotView);
        make.leading.mas_equalTo(self.dotView.mas_trailing).mas_offset(15 * kScreenWidthRate);
        make.trailing.mas_equalTo(self.contentView).inset(15 * kScreenWidthRate);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messagerType.mas_bottom).mas_offset(15 * kScreenWidthRate);
        make.leading.mas_equalTo(self.dotView);
        make.trailing.mas_equalTo(self.contentView).inset(15 * kScreenWidthRate);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(15 * kScreenWidthRate);
        make.leading.trailing.mas_equalTo(self.contentView).inset(15 * kScreenWidthRate);
    }];
    
    [self.spaceLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(15 * kScreenWidthRate);
        make.leading.trailing.mas_equalTo(self.contentView).inset(15 * kScreenWidthRate);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.checkInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spaceLine.mas_bottom).mas_offset(8 * kScreenWidthRate);
        make.leading.mas_equalTo(self.contentView).inset(15 * kScreenWidthRate);
        make.bottom.mas_equalTo(self.contentView).inset(8 * kScreenWidthRate);
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.checkInfoLabel);
        make.trailing.mas_equalTo(self.contentView).inset(15 * kScreenWidthRate);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
