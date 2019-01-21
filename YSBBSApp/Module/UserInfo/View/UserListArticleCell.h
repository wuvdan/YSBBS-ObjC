//
//  UserListArticleCell.h
//  YSBBSApp
//
//  Created by wudan on 2018/11/15.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UserPostModel;

@interface UserListArticleCell : UITableViewCell

@property (nonatomic, strong) UserPostModel *model;

@end

NS_ASSUME_NONNULL_END
