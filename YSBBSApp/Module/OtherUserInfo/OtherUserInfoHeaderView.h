//
//  OtherUserInfoHeaderView.h
//  YSBBSApp
//
//  Created by wudan on 2019/2/14.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OtherUserInfoModel;

@protocol OtherUserInfoHeaderViewDelegate <NSObject>

- (void)followActionWithModel:(OtherUserInfoModel *)model;

@end

@interface OtherUserInfoHeaderView : UIView

@property (nonatomic, weak) id <OtherUserInfoHeaderViewDelegate> delegate;

- (void)setupWithModel:(OtherUserInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
