//
//  PostArticleImageCollectionViewCell.h
//  YSBBSApp
//
//  Created by wudan on 2019/1/17.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class XG_AssetModel;

@interface PostArticleImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic, strong) XG_AssetModel *model;
@end

NS_ASSUME_NONNULL_END
