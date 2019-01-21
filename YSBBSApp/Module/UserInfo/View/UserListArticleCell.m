//
//  UserListArticleCell.m
//  YSBBSApp
//
//  Created by wudan on 2018/11/15.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "UserListArticleCell.h"
#import "UserPostModel.h"
@interface UserListArticleCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation UserListArticleCell

- (void)setModel:(UserPostModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    
    self.timeLabel.text = [[UtilsManager shareInstance] setupCreateTime:model.createTime];
    
    [self.likeButton setTitle:[NSString stringWithFormat:@"%ld",(long)model.likeNum] forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString stringWithFormat:@"%ld",(long)model.commentNum] forState:UIControlStateNormal];
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
