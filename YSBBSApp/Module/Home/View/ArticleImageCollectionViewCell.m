//
//  ArticleImageCollectionViewCell.m
//  YSBBSApp
//
//  Created by wudan on 2018/11/14.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "ArticleImageCollectionViewCell.h"


@interface ArticleImageCollectionViewCell ()

@end

@implementation ArticleImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImgUrlString:(NSString *)imgUrlString {
    _imgUrlString = imgUrlString;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",G_Http_URL,imgUrlString]] placeholderImage:[UIImage imageNamed:@"Default"]];
}


@end
