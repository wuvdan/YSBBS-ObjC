//
//  MessageInfoTableViewCell.m
//  YSBBSApp
//
//  Created by wudan on 2019/1/25.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import "MessageInfoTableViewCell.h"
#import "MessageInfo.h"

@interface MessageInfoTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;   //!< 标题
@property (nonatomic, strong) UILabel *infoLabel;    //!< 内容

@end

@implementation MessageInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setModel:(MessageInfo *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    self.infoLabel.text = model.content;
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x = kRealWidthValue(15);
    frame.size.width -= frame.origin.x + kRealWidthValue(15);
    [super setFrame:frame];
}

- (void)setupUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.font = [UIFont systemFontOfSize:13];
    self.infoLabel.textColor = [UIColor darkGrayColor];
    self.infoLabel.numberOfLines = 0;
    
    [self.contentView addSubview:self.infoLabel];
}

- (void)setupLayout {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).inset(15 * kScreenWidthRate);
        make.trailing.leading.mas_equalTo(self.contentView).inset(15 * kScreenWidthRate);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(20 * kScreenWidthRate);
        make.leading.trailing.mas_equalTo(self.contentView).inset(15 * kScreenWidthRate);
        make.bottom.mas_equalTo(self.contentView).inset(8 * kScreenWidthRate);
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
