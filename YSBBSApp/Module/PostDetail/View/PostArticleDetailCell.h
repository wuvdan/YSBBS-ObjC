//
//  PostArticleDetailCell.h
//  YSBBSApp
//
//  Created by wudan on 2018/11/15.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PostDetailModel;
@class UserPostModel;

@interface PostArticleDetailCell : UITableViewCell

@property (nonatomic, strong) PostDetailModel *model;
@property (nonatomic, strong) UserPostModel *userPostModel;

@end

NS_ASSUME_NONNULL_END
