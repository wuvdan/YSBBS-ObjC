//
//  PostArticleController.h
//  YSBBSApp
//
//  Created by wudan on 2018/11/14.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostArticleController : BaseViewController

@property (nonatomic, copy) void (^publicResultHandler)(BOOL isSuccess);

@end

NS_ASSUME_NONNULL_END
