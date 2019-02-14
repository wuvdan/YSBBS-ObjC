//
//  BBSNetworkTool.h
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/24.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBSNetworkTool : NSObject

+ (instancetype)shareInstance;
/**
 * 注册请求
 *
 @param aAccount 账号
 @param aPassowrd 密码
 @param aSuccessBlock 成功回调
 @param aFailBlock 失败回调
 */
- (void)registerRequsetWithAccount:(NSString *)aAccount emailString:(NSString *)email emailCode:(NSString *)anEmailCode passowrd:(NSString *)aPassowrd successBlock:(void(^)(id obj))aSuccessBlock failBlock:(void(^)(id obj))aFailBlock;

/**
 * 注册发送验证码
 *
 @param anEmail 邮箱地址
 @param aSuccessBlock 成功回调
 @param aFailBlock 失败回调
 */
- (void)registerRequsetEmailString:(NSString *)anEmail successBlock:(void(^)(id obj))aSuccessBlock failBlock:(void(^)(id obj))aFailBlock;

/**
 * 忘记密码发送验证码
 *
 @param anEmail 邮箱
 @param aSuccessBlock 成功回调
 @param aFailBlock 失败回调
 */
- (void)forgetPasswordRequsetEmailString:(NSString *)anEmail successBlock:(void(^)(id obj))aSuccessBlock failBlock:(void(^)(id obj))aFailBlock;

/**
 * 忘记密码
 *
 @param email 邮箱
 @param anEmailCode 验证码
 @param aPassowrd 新密码
 @param aSuccessBlock 成功回调
 @param aFailBlock 失败回调
 */
- (void)forgetPasswordRequsetWithEmailString:(NSString *)email emailCode:(NSString *)anEmailCode passowrd:(NSString *)aPassowrd successBlock:(void(^)(id obj))aSuccessBlock failBlock:(void(^)(id obj))aFailBlock;

/**
 * 登录请求
 *
 @param aAccount 账号
 @param aPassowrd 密码
 @param aSuccessBlock 成功回调
 @param aFailBlock 失败回调
 */
- (void)loginRequsetWithAccount:(NSString *)aAccount passowrd:(NSString *)aPassowrd successBlock:(void(^)(id obj))aSuccessBlock failBlock:(void(^)(id obj))aFailBlock;

/**
 * 获取个人信息
 *
 @param aSuccessBlock 成功回调
 */
- (void)userInfoRequestWithSuccessBlock:(void(^)(id obj))aSuccessBlock ;

/**
 *  退出账号
 */
- (void)signOutrRequset;

/**
 * 头像上传
 *
 @param headerImage 图片
 @param aSuccessBlock 成功回调
 */
- (void)uploadHeaderImageView:(UIImage *)headerImage successBlock:(void(^)(id obj))aSuccessBlock;

/**
 * 发帖图片上传
 *
 @param aImageArray 图片数组
 @param aSuccessBlock 成功回调
 */
- (void)postImageUpLoadWithImageArray:(NSArray<UIImage *> *)aImageArray successBlock:(void(^)(id obj))aSuccessBlock;

/**
 * 修改个人信息
 *
 @param headerImage 头像
 @param aNickName 昵称
 @param aIsSingleLogin 是否单点登录
 @param aSuccessBlock 成功回调
 */
- (void)modifyUserInfoWithHeaderImage:(NSString *)headerImage nickName:(NSString *)aNickName isSingleLogin:(NSString *)aIsSingleLogin successBlock:(void(^)(id obj))aSuccessBlock;

/**
 * 修改登录密码
 *
 @param aOldPassword 原密码
 @param password 新密码
 */
-  (void)modifyPasswordWithOldPassword:(NSString *)aOldPassword aNewPassword:(NSString *)password successBlock:(void(^)(id obj))aSuccessBlock failBlock:(void(^)(id obj))aFailBlock;

/**
 * 发帖
 *
 @param aTitle 标题--必传
 @param content 内容--必传
 @param imageString 图片 逗号隔开，可不传
 @param aSuccessBlock 成功回调
 */
- (void)addPostWithTitle:(NSString *)aTitle contentText:(NSString *)content imageSting:(NSString *)imageString successBlock:(void(^)(id obj))aSuccessBlock;

/**
 * 删帖
 *
 @param topicId 帖子Id
 @param aSuccessBlock 成功回调
 */
- (void)deletePostWithTopicId:(NSInteger)topicId successBlock:(void(^)(id obj))aSuccessBlock;

/**
 * 获取用户发帖
 *
 @param aPageSize 一页多少
 @param pageNo 页码
 @param aSuccessBlock 成功回调
 */
- (void)getUserPostPageSize:(NSString *)aPageSize pageNo:(NSInteger)pageNo successBlock:(void(^)(id obj))aSuccessBlock;

/**
 * 点赞帖子
 *
 @param topicId 帖子Id
 @param aSuccessBlock 成功回调
 */
- (void)likePostWithTopicId:(NSInteger)topicId successBlock:(void(^)(id obj))aSuccessBlock;
/**
 * 取消点赞帖子
 *
 @param topicId 帖子Id
 @param aSuccessBlock 成功回调
 */
- (void)cancelLikePostWithTopicId:(NSInteger)topicId successBlock:(void(^)(id obj))aSuccessBlock;

/**
 * 获取所有帖子
 *
 @param aPageSize 一页多少
 @param pageNo 页码
 @param aSuccessBlock 成功回调
 */
- (void)getPostListPageSize:(NSString *)aPageSize pageNo:(NSInteger)pageNo successBlock:(void(^)(id obj))aSuccessBlock failBlock:(void (^)(void))aFailBlock;

/**
 * 帖子详情
 *
 @param topicId 帖子Id
 @param aSuccessBlock 成功回调
 */
- (void)postDetailWithTopicId:(NSInteger)topicId successBlock:(void(^)(id obj))aSuccessBlock;

/**
 * 获取帖子评论列表
 *
 @param topicId 帖子Id
 @param aPageSize 一页多少
 @param pageNo 页码
 @param aSuccessBlock 成功回调
 */
- (void)commentListWithTopicId:(NSInteger)topicId pageSize:(NSString *)aPageSize pageNo:(NSInteger)pageNo successBlock:(void(^)(id obj))aSuccessBlock;


/**
 * 对帖子评论
 *
 @param contentText 评论文字
 @param aTopicId 帖子id
 @param aSuccessBlock 成功回调
 */
- (void)commentPostWithContent:(NSString *)contentText topicId:(NSInteger)aTopicId successBlock:(void(^)(id obj))aSuccessBlock;

/**
 * 删除评论
 *
 @param commentId 评论Id
 @param aSuccessBlock 成功回调
 */
- (void)deleteCommentWithCommentId:(NSInteger)commentId successBlock:(void(^)(id obj))aSuccessBlock;

/**
 * 点赞评论
 *
 @param commentId 评论Id
 @param aSuccessBlock 成功回调
 */
- (void)likeCommentWithCommentId:(NSInteger)commentId successBlock:(void(^)(id obj))aSuccessBlock;
/**
 * 取消点赞评论
 *
 @param commentId 评论Id
 @param aSuccessBlock 成功回调
 */
- (void)cancelLikeCommentWithCommentId:(NSInteger)commentId successBlock:(void(^)(id obj))aSuccessBlock;


/**
 * 获取消息列表
 * 
 @param pageNo 当前页面
 @param aSuccessBlock 成功回调
 */
- (void)getMessageWithPageNo:(NSInteger)pageNo successBlock:(void(^)(id obj))aSuccessBlock;


/**
 * 获取消息详情
 *
 @param Id 消息id
 @param aSuccessBlock 成功回调
 */
- (void)getMessageWithId:(NSInteger)Id successBlock:(void (^)(id obj))aSuccessBlock;

/**
 * 获取其他用户信息
 * 
 @param userId 用户Id
 @param aSuccessBlock 成功回调
 */
- (void)getOtherUserInfoWithUserId:(NSInteger)userId successBlock:(void(^)(id obj))aSuccessBlock;

/**
 * 收藏用户列表
 *
 @param aPageSize 一页多少
 @param pageNo 页码
 @param aSuccessBlock 成功回调
 */
- (void)getCollectionUserListPostPageSize:(NSString *)aPageSize pageNo:(NSInteger)pageNo successBlock:(void(^)(id obj))aSuccessBlock;



/**
 * 关注用户
 *
 @param userId 用户Id
 @param aSuccessBlock 成功回调
 */
- (void)followUserWithUserId:(NSInteger)userId successBlock:(void(^)(id obj))aSuccessBlock;

/**
 * 取消关注用户

 @param userId 用户Id
 @param aSuccessBlock 成功回调
 */
- (void)unfollowUserWithUserId:(NSInteger)userId successBlock:(void(^)(id obj))aSuccessBlock;


/**
 * 收藏帖子列表
 *
 @param aPageSize 一页多少
 @param pageNo 页码
 @param aSuccessBlock 成功回调
 */
- (void)getCollectionListPostPageSize:(NSString *)aPageSize pageNo:(NSInteger)pageNo successBlock:(void(^)(id obj))aSuccessBlock;

/**
 * 收藏帖子

 @param Id 帖子iID
 @param aSuccessBlock 成功回调
 */
- (void)collectPostWithId:(NSInteger)Id successBlock:(void(^)(id obj))aSuccessBlock;

/**
 * 取消收藏帖子
 
 @param Id 帖子iID
 @param aSuccessBlock 成功回调
 */
- (void)unCollectPostWithId:(NSInteger)Id successBlock:(void(^)(id obj))aSuccessBlock;
@end

NS_ASSUME_NONNULL_END
