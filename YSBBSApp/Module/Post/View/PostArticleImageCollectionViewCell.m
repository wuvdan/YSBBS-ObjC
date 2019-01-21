//
//  PostArticleImageCollectionViewCell.m
//  YSBBSApp
//
//  Created by wudan on 2019/1/17.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import "PostArticleImageCollectionViewCell.h"
#import "XG_AssetModel.h"
#import "XG_AssetPickerManager.h"
#import "UIView+XGAdd.h"

@implementation PostArticleImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(XG_AssetModel *)model{
    _model = model;
    if (_model.isPlaceholder) {
        self.imgView.image = [[UIImage imageNamed:@"add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.imgView.tintColor = kMainGrey;
        self.playBtn.hidden = YES;
        self.deleteBtn.hidden = YES;
    }else{
        self.deleteBtn.hidden = NO;
        [[XG_AssetPickerManager manager] getPhotoWithAsset:_model.asset photoWidth:self.frame.size.width completion:^(UIImage *photo, NSDictionary *info) {
            self.imgView.image = photo;
        }];
        if (_model.asset.mediaType == PHAssetMediaTypeVideo) {
            self.playBtn.hidden = NO;
        }else{
            self.playBtn.hidden = YES;
        }
    }
}

@end
