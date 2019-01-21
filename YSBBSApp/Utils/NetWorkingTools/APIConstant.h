//
//  APIConstant.h
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/25.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString * const G_TencentBuglyKey;

UIKIT_EXTERN NSString * const G_Http_URL; 

// 注册
UIKIT_EXTERN NSString * const registerAPI;

// 注册发送验证码
UIKIT_EXTERN NSString * const registerGetCodeAPI;

// 忘记密码发送验证码
UIKIT_EXTERN NSString * const forgetPassoworGetCodeAPI;

// 忘记密码
UIKIT_EXTERN NSString * const forgetPassoworAPI;

// 登录
UIKIT_EXTERN NSString * const logInAPI;

// 退出
UIKIT_EXTERN NSString * const signOutAPI;

// 获取个人信息
UIKIT_EXTERN NSString * const getUserInfoAPI;

// 单个文件上传
UIKIT_EXTERN NSString * const singleFileUploadAPI;

// 多个文件上传
UIKIT_EXTERN NSString * const multifFleUploadAPI;

// 修改个人信息
UIKIT_EXTERN NSString * const modifyUserInfoAPI;

// 我的帖子
UIKIT_EXTERN NSString * const myPostListAPI;

// 帖子列表
UIKIT_EXTERN NSString * const postListAPI;

// 帖子详情
UIKIT_EXTERN NSString * const postDetailAPI;

// 发帖
UIKIT_EXTERN NSString * const addPostAPI;

// 删帖
UIKIT_EXTERN NSString * const deletePostAPI;

// 赞贴
UIKIT_EXTERN NSString * const likePostAPI;

// 取消赞贴
UIKIT_EXTERN NSString * const cancelLikePostAPI;

// 评论列表
UIKIT_EXTERN NSString * const commentListAPI;

// 发表评论
UIKIT_EXTERN NSString * const addCommentAPI;

// 删除评论
UIKIT_EXTERN NSString * const deleteCommentAPI;

// 评论点赞
UIKIT_EXTERN NSString * const likeCommentAPI;

// 取消评论点赞
UIKIT_EXTERN NSString * const cancelLikeCommentAPI;

// 修改密码
UIKIT_EXTERN NSString * const modifyPassword;

// 首页列表表名
UIKIT_EXTERN NSString * const HomeListTable;

// 评论列表
UIKIT_EXTERN NSString * const CommentListTable;

// 个人信息
UIKIT_EXTERN NSString * const UserInfoTable;
