//
//  PostCommentToolView.h
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/28.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDTextView.h"
NS_ASSUME_NONNULL_BEGIN

@interface PostCommentToolView : UIView

@property (nonatomic, strong) WDTextView  *textView;
@property (nonatomic, strong) UIButton *likeNumButton;
@property (nonatomic, strong) UIButton *publicButton;

@end

NS_ASSUME_NONNULL_END
