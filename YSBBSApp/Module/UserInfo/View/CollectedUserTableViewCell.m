//
//  CollectedUserTableViewCell.m
//  YSBBSApp
//
//  Created by wudan on 2019/2/14.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import "CollectedUserTableViewCell.h"

@implementation CollectedUserModel

@end



@interface CollectedUserTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

@end

@implementation CollectedUserTableViewCell

- (void)setModel:(CollectedUserModel *)model {
    _model = model;
    self.nickLabel.text = model.nickname;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",G_Http_URL, model.headPic]] placeholderImage:[UIImage imageNamed:@"Default"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headerImageView.layer.cornerRadius = 30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
