//
//  ArticleTableViewCell.h
//  YSBBSApp
//
//  Created by wudan on 2018/11/14.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UserPostModel;
@class ArticleTableViewCell;

@protocol ArticleTableViewCellDelegate <NSObject>

- (void)likePostWithModel:(UserPostModel *)model inCell:(ArticleTableViewCell *)cell;
- (void)commentPostWithModel:(UserPostModel *)model;

@end

@interface ArticleTableViewCell : UITableViewCell

@property (nonatomic, strong) UserPostModel *model;

@property (nonatomic, weak) id <ArticleTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
