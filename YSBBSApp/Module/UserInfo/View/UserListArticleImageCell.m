//
//  UserListArticleImageCell.m
//  YSBBSApp
//
//  Created by wudan on 2018/11/15.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "UserListArticleImageCell.h"
#import "UserPostModel.h"

@interface UserListArticleImageCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIImageView *contentimageView;

@end

@implementation UserListArticleImageCell

- (void)setModel:(UserPostModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    
    self.timeLabel.text = [[UtilsManager shareInstance] setupCreateTime:model.createTime];
    
    [self.likeButton setTitle:[NSString stringWithFormat:@"%ld",(long)model.likeNum] forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString stringWithFormat:@"%ld",(long)model.commentNum] forState:UIControlStateNormal];
    
    NSArray *imgs = [self.model.img componentsSeparatedByString:@","];
    
    [self.contentimageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",G_Http_URL,imgs.firstObject]] placeholderImage:[UIImage imageNamed:@"Default"]];
    
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
