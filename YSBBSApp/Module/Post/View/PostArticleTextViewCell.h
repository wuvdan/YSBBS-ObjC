//
//  PostArticleTextViewCell.h
//  YSBBSApp
//
//  Created by wudan on 2018/11/14.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PostArticleTextViewCell;

@protocol TextViewCellDelegate <NSObject>

- (void)textViewCell:(PostArticleTextViewCell *)cell didChangeText:(NSString *)text;

@end

@interface PostArticleTextViewCell : UITableViewCell

@property (weak, nonatomic) id<TextViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
