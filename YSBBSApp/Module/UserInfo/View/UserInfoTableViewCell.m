//
//  UserInfoTableViewCell.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/27.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "UserInfoTableViewCell.h"

@interface UserInfoTableViewCell ()

@end

@implementation UserInfoTableViewCell

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

#pragma mark - SetupSubviewsUI
- (void)setupSubviews{
    self.titileLabel = [[UILabel alloc] initWithText:@""
                                           textColor:kMainBlack
                                            textFont:15
                                       textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titileLabel];
    
    self.subTitileLabel = [[UILabel alloc] initWithText:@""
                                              textColor:kMainGrey
                                               textFont:15
                                          textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.subTitileLabel];
}

#pragma mark - SetupSubviewsConstraints
- (void)setupSubviewsConstraints{
    [self.titileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).inset(kRealWidthValue(15));
        make.top.bottom.mas_equalTo(self.contentView).inset(kRealHeightValue(15));
        [self.titileLabel sizeToFit];
    }];
    
    [self.subTitileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView).inset(kRealWidthValue(15));
        make.centerY.mas_equalTo(self.titileLabel);
        [self.subTitileLabel sizeToFit];
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
