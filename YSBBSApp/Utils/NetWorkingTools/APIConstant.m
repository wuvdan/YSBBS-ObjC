//
//  APIConstant.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/25.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "APIConstant.h"

NSString * const G_TencentBuglyKey        = @"351398dc-a3de-4cff-ae4a-03187950fa89";

NSString * const G_Http_URL               = @"http://118.31.12.178";

NSString * const registerAPI              = @"user/register";

NSString * const registerGetCodeAPI       = @"user/sendRegEmailMsg";

NSString * const forgetPassoworGetCodeAPI = @"user/sendForgetPwdEmailMsg";

NSString * const forgetPassoworAPI        = @"user/forgetPwd";

NSString * const logInAPI                 = @"user/login";

NSString * const signOutAPI               = @"user/logout";

NSString * const getUserInfoAPI           = @"user/getInfo";

NSString * const singleFileUploadAPI      = @"file/upload";

NSString * const multifFleUploadAPI       = @"file/uploads";

NSString * const modifyUserInfoAPI        = @"user/modifyInfo";

NSString * const myPostListAPI            = @"topic/myList";

NSString * const postListAPI              = @"topic/list";

NSString * const postDetailAPI            = @"topic/get";

NSString * const addPostAPI               = @"topic/add";

NSString * const deletePostAPI            = @"topic/del";

NSString * const likePostAPI              = @"topicLike/add";

NSString * const cancelLikePostAPI        = @"topicLike/del";

NSString * const commentListAPI           = @"topicComment/list";

NSString * const addCommentAPI            = @"topicComment/add";

NSString * const deleteCommentAPI         = @"topicComment/del";

NSString * const likeCommentAPI           = @"topicCommentLike/add";

NSString * const cancelLikeCommentAPI     = @"topicCommentLike/del";

NSString * const getMessageListAPI        = @"message/list";

NSString * const getMessageDetailAPI      = @"message/get";

NSString * const getOtherUserInfoAPI      = @"user/userInfo";

NSString * const followUserListAPI        = @"userFollow/list";

NSString * const followUserAPI            = @"userFollow/add";

NSString * const unfollowUserAPI          = @"userFollow/del";

NSString * const collectionListAPI        = @"topicCollection/list";

NSString * const collectPostAPI           = @"topicCollection/add";

NSString * const unCollectPostAPI         = @"topicCollection/del";

NSString * const getRemoteNotification    = @"/websocket";

NSString * const modifyPassword           = @"user/modifyPwd";

NSString * const HomeListTable            = @"HomeListTable";

NSString * const CommentListTable         = @"CommentListTable";

NSString * const UserInfoTable            = @"UserInfoTable";
