//
//  UserInfoHeaderView.h
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/27.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoHeaderView : UIView

#define HeaderHeight kSCREEN_WIDTH/2

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIButton *postNumButton;

@property (nonatomic, copy) void (^imagePickerBlock)(void);

@end
