//
//  CommentTableViewCell.h
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/28.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CommentTableViewCellLikeDelegate <NSObject>

- (void)likeCommentWithModel:(CommentModel *)model;

@end

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic, strong) CommentModel *model;

@property (nonatomic, weak) id <CommentTableViewCellLikeDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
