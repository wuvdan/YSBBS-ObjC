//
//  PostArticleTextFieldCell.h
//  YSBBSApp
//
//  Created by wudan on 2018/11/14.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PostArticleTextFieldCell;

@protocol PostArticleTextFieldCellDelegate <NSObject>

- (void)textChangeInPostArticleTextFieldCell:(PostArticleTextFieldCell *)cell text:(NSString *)text;

@end

@interface PostArticleTextFieldCell : UITableViewCell

@property (nonatomic, weak) id <PostArticleTextFieldCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
