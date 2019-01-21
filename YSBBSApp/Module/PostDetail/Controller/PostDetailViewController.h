//
//  PostDetailViewController.h
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/28.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class UserPostModel;

@interface PostDetailViewController : BaseViewController

@property (nonatomic, strong) UserPostModel *model;

@property (nonatomic, assign) NSInteger topicId;
@property (nonatomic, copy) void (^deletePost)(void);

@end

NS_ASSUME_NONNULL_END
