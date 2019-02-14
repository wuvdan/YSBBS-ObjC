//
//  BBSNetworkTool.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/24.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "BBSNetworkTool.h"
#import "WDNetWorkingTool.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "UserInfoModel.h"
#import "LZRemindBar.h"

@implementation BBSNetworkTool

static BBSNetworkTool *_instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

+ (instancetype)shareInstance {
    return  [[self alloc] init];
}

#pragma mark  注册 
- (void)registerRequsetWithAccount:(NSString *)aAccount emailString:(NSString *)email emailCode:(NSString *)anEmailCode passowrd:(NSString *)aPassowrd successBlock:(void(^)(id obj))aSuccessBlock failBlock:(void(^)(id obj))aFailBlock {
    
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,registerAPI]
                                             isShowIndicator:false
                                                parameterDic:@{@"loginName":aAccount,
                                                               @"loginPwd":aPassowrd,
                                                               @"email":email,
                                                               @"code":anEmailCode}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             aFailBlock(obj);
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  注册发送邮箱验证码 
- (void)registerRequsetEmailString:(NSString *)anEmail successBlock:(void(^)(id obj))aSuccessBlock failBlock:(void(^)(id obj))aFailBlock {
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,registerGetCodeAPI]
                                             isShowIndicator:false
                                                parameterDic:@{@"email":anEmail}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             aFailBlock(obj);
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  忘记密码发送邮箱验证码 
- (void)forgetPasswordRequsetEmailString:(NSString *)anEmail successBlock:(void(^)(id obj))aSuccessBlock failBlock:(void(^)(id obj))aFailBlock {
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,forgetPassoworGetCodeAPI]
                                             isShowIndicator:false
                                                parameterDic:@{@"email":anEmail}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             aFailBlock(obj);
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  忘记密码 
- (void)forgetPasswordRequsetWithEmailString:(NSString *)email emailCode:(NSString *)anEmailCode passowrd:(NSString *)aPassowrd successBlock:(void(^)(id obj))aSuccessBlock failBlock:(void(^)(id obj))aFailBlock {
    
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,forgetPassoworAPI]
                                             isShowIndicator:false
                                                parameterDic:@{@"newPwd":aPassowrd,
                                                               @"email":email,
                                                               @"code":anEmailCode}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             aFailBlock(obj);
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  登录 
- (void)loginRequsetWithAccount:(NSString *)aAccount passowrd:(NSString *)aPassowrd successBlock:(void(^)(id obj))aSuccessBlock failBlock:(void(^)(id obj))aFailBlock{
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                   requsetParameteLocation:RequsetParameterLocationHeader
                                                urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,logInAPI]
                                           isShowIndicator:false
                                              parameterDic:@{@"loginName":aAccount,
                                                             @"loginPwd":aPassowrd}
                                       requsetSuccessBlock:^(id  _Nonnull obj) {
                                           aSuccessBlock(obj);
                                           [self loginSuccessWithDataDic:obj account:aAccount];
                                       } requsetFailBlock:^(id  _Nonnull obj) {
                                           aFailBlock(obj);
                                           [self handlerFailDataDic:obj];
                                       }];
}

#pragma mark  退出账号 
- (void)signOutrRequset {
    [self clearAccountHistory];
    
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                   requsetParameteLocation:RequsetParameterLocationHeader
                                                urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,signOutAPI]
                                           isShowIndicator:false
                                              parameterDic:@{}
                                       requsetSuccessBlock:^(id  _Nonnull obj) {
                                           
                                       } requsetFailBlock:^(id  _Nonnull obj) {
                                           [self handlerFailDataDic:obj];
                                       }];
}

#pragma mark  获取用户数据 
- (void)userInfoRequestWithSuccessBlock:(void(^)(id obj))aSuccessBlock {
    
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,getUserInfoAPI]
                                             isShowIndicator:false
                                                parameterDic:@{}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                             NSDictionary *dataDic = obj[@"data"];
                                             
                                             UserInfoModel *model = [UserInfoModel mj_objectWithKeyValues:dataDic];
                                             
                                             [[DataBaseTools manager] insertDataWithTableName:UserInfoTable model:model successBlock:^{
                                                 
                                             } failBlock:^{
                                                 
                                             }];
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  头像上传 
- (void)uploadHeaderImageView:(UIImage *)headerImage successBlock:(void(^)(id obj))aSuccessBlock {
    
    [[WDNetWorkingTool  shareInstance] multPictureUploadWithWithUrl:[NSString stringWithFormat:@"%@/%@",G_Http_URL,multifFleUploadAPI]
                                                        imagesArray:@[headerImage]
                                                    isShowIndicator:true
                                                requsetSuccessBlock:^(id  _Nonnull obj) {
                                                        aSuccessBlock(obj);
                                                    } requsetFailBlock:^(id  _Nonnull obj) {
                                                        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"图片上传失败"] showBarAfterTimeInterval:1.2];
                                                    }];
    

//    [[WDNetWorkingTool shareInstance] singlePictureUploadWithUrl:[NSString stringWithFormat:@"%@/%@",G_Http_URL,singleFileUploadAPI]
//                                                           image:headerImage
//                                                 isShowIndicator:true
//                                             requsetSuccessBlock:^(id  _Nonnull obj) {
//                                                 aSuccessBlock(obj);
//                                             } requsetFailBlock:^(id  _Nonnull obj) {
//                                                 [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"图片上传失败"] showBarAfterTimeInterval:1.2];
//                                             }];
}

#pragma mark  发帖图片上传 
- (void)postImageUpLoadWithImageArray:(NSArray<UIImage *> *)aImageArray successBlock:(void(^)(id obj))aSuccessBlock {
 
    [[WDNetWorkingTool  shareInstance] multPictureUploadWithWithUrl:[NSString stringWithFormat:@"%@/%@",G_Http_URL,multifFleUploadAPI]
                                                        imagesArray:aImageArray
                                                    isShowIndicator:true requsetSuccessBlock:^(id  _Nonnull obj) {
                                                            aSuccessBlock(obj);
                                                        } requsetFailBlock:^(id  _Nonnull obj) {
                                                             [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"图片上传失败"] showBarAfterTimeInterval:1.2];
                                                        }];
}

#pragma mark  修改个人信息 
- (void)modifyUserInfoWithHeaderImage:(NSString *)headerImage nickName:(NSString *)aNickName isSingleLogin:(NSString *)aIsSingleLogin successBlock:(void(^)(id obj))aSuccessBlock {
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    if (headerImage.length > 0) {
        [postDic setObject:headerImage forKey:@"headPic"];
    }
    if (aNickName.length > 0) {
        [postDic setObject:aNickName forKey:@"nickname"];
    }
    
    if (aIsSingleLogin.length > 0) {
        [postDic setObject:[NSString stringWithFormat:@"%@",aIsSingleLogin] forKey:@"isSingleLogin"];
    }
    
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,modifyUserInfoAPI]
                                             isShowIndicator:false
                                                parameterDic:postDic
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                              [[LZRemindBar configurationWithStyle:RemindBarStyleInfo showPosition:RemindBarPositionStatusBar contentText:@"修改成功"] showBarAfterTimeInterval:1.2];
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  修改登录密码 
- (void)modifyPasswordWithOldPassword:(NSString *)aOldPassword aNewPassword:(NSString *)password successBlock:(void(^)(id obj))aSuccessBlock failBlock:(void(^)(id obj))aFailBlock {
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,modifyPassword]
                                             isShowIndicator:true
                                                parameterDic:@{@"oldPwd":aOldPassword,@"newPwd":password}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                             [[LZRemindBar configurationWithStyle:RemindBarStyleInfo showPosition:RemindBarPositionStatusBar contentText:@"修改成功,请重新登录"] showBarAfterTimeInterval:1.2];
                                             [self clearAccountHistory];
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                             aFailBlock(obj);
                                         }];
}

#pragma mark  发帖 
- (void)addPostWithTitle:(NSString *)aTitle contentText:(NSString *)content imageSting:(NSString *)imageString successBlock:(void(^)(id obj))aSuccessBlock {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    if (imageString.length > 0) {
        [postDic setObject:imageString forKey:@"img"];
    }
    [postDic setObject:aTitle forKey:@"title"];
    [postDic setObject:content forKey:@"content"];
    
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,addPostAPI]
                                             isShowIndicator:false
                                                parameterDic:postDic
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                             [[LZRemindBar configurationWithStyle:RemindBarStyleInfo showPosition:RemindBarPositionStatusBar contentText:@"发布成功"] showBarAfterTimeInterval:1.2];

                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  删帖 
- (void)deletePostWithTopicId:(NSInteger)topicId successBlock:(void(^)(id obj))aSuccessBlock {
    
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,deletePostAPI]
                                             isShowIndicator:false
                                                parameterDic:@{@"topicId":[NSString stringWithFormat:@"%ld",(long)topicId]}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                             [[LZRemindBar configurationWithStyle:RemindBarStyleInfo showPosition:RemindBarPositionStatusBar contentText:@"删除成功"] showBarAfterTimeInterval:1.2];
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  用户帖子 
- (void)getUserPostPageSize:(NSString *)aPageSize pageNo:(NSInteger)pageNo successBlock:(void(^)(id obj))aSuccessBlock {
    
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,myPostListAPI]
                                             isShowIndicator:pageNo == 1 ? true : false
                                                parameterDic:@{@"pageSize":aPageSize,
                                                               @"pageNo":[NSString stringWithFormat:@"%ld",(long)pageNo]}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
    
}

#pragma mark  帖子点赞 
- (void)likePostWithTopicId:(NSInteger)topicId successBlock:(void(^)(id obj))aSuccessBlock {
    
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,likePostAPI]
                                             isShowIndicator:false
                                                parameterDic:@{@"topicId":[NSString stringWithFormat:@"%ld",(long)topicId]}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  取消帖子点赞 
- (void)cancelLikePostWithTopicId:(NSInteger)topicId successBlock:(void(^)(id obj))aSuccessBlock {

    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,cancelLikePostAPI]
                                             isShowIndicator:false
                                                parameterDic:@{@"topicId":[NSString stringWithFormat:@"%ld",(long)topicId]}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  帖子列表 
- (void)getPostListPageSize:(NSString *)aPageSize pageNo:(NSInteger)pageNo successBlock:(void(^)(id obj))aSuccessBlock failBlock:(void (^)(void))aFailBlock {
    
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,postListAPI]
                                             isShowIndicator:false
                                                parameterDic:@{@"pageSize":aPageSize,
                                                               @"pageNo":[NSString stringWithFormat:@"%ld",(long)pageNo]}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             aFailBlock();
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  帖子详情 
- (void)postDetailWithTopicId:(NSInteger)topicId successBlock:(void (^)(id _Nonnull))aSuccessBlock {
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,postDetailAPI]
                                             isShowIndicator:false
                                                parameterDic:@{@"topicId":[NSString stringWithFormat:@"%ld",(long)topicId]}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  帖子评论列表 
- (void)commentListWithTopicId:(NSInteger)topicId pageSize:(NSString *)aPageSize pageNo:(NSInteger)pageNo successBlock:(void (^)(id _Nonnull))aSuccessBlock {
    
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,commentListAPI]
                                             isShowIndicator:false
                                                parameterDic:@{@"pageSize":aPageSize,
                                                               @"pageNo":[NSString stringWithFormat:@"%ld",(long)pageNo],
                                                               @"topicId":[NSString stringWithFormat:@"%ld",(long)topicId]
                                                               }
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  评论帖子 
- (void)commentPostWithContent:(NSString *)contentText topicId:(NSInteger)aTopicId successBlock:(void (^)(id _Nonnull))aSuccessBlock {
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,addCommentAPI]
                                             isShowIndicator:false
                                                parameterDic:@{@"topicId":[NSString stringWithFormat:@"%ld",(long)aTopicId],
                                                               @"content":contentText }
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  删除评论 
- (void)deleteCommentWithCommentId:(NSInteger)commentId successBlock:(void (^)(id _Nonnull))aSuccessBlock {
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,deleteCommentAPI]
                                             isShowIndicator:false
                                                parameterDic:@{@"topicCommentId":[NSString stringWithFormat:@"%ld",(long)commentId]}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  评论帖子点赞 
- (void)likeCommentWithCommentId:(NSInteger)commentId successBlock:(void (^)(id _Nonnull))aSuccessBlock {
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodPost
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,likeCommentAPI]
                                             isShowIndicator:false
                                                parameterDic:@{@"topicCommentId":[NSString stringWithFormat:@"%ld",(long)commentId]}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  评论帖子取消点赞 
- (void)cancelLikeCommentWithCommentId:(NSInteger)commentId successBlock:(void (^)(id _Nonnull))aSuccessBlock {
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,cancelLikeCommentAPI]
                                             isShowIndicator:false
                                                parameterDic:@{@"topicCommentId":[NSString stringWithFormat:@"%ld",(long)commentId]}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  消息列表
- (void)getMessageWithPageNo:(NSInteger)pageNo successBlock:(void (^)(id _Nonnull))aSuccessBlock {
    
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,getMessageListAPI]
                                             isShowIndicator:false
                                                parameterDic:@{@"pageNo"   : [NSString stringWithFormat:@"%ld", (long)pageNo],
                                                               @"pageSize" : @"10"}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                                    aSuccessBlock(obj);
                                                } requsetFailBlock:^(id  _Nonnull obj) {
                                                    [self handlerFailDataDic:obj];
                                                }];
    
}

#pragma mark  消息详情
- (void)getMessageWithId:(NSInteger)Id successBlock:(void (^)(id _Nonnull))aSuccessBlock {
    
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,getMessageDetailAPI]
                                             isShowIndicator:true
                                                parameterDic:@{@"messageId" : [NSString stringWithFormat:@"%ld", (long)Id]}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                              aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
    
}

#pragma mark  获取其他用户信息
- (void)getOtherUserInfoWithUserId:(NSInteger)userId successBlock:(void (^)(id _Nonnull))aSuccessBlock {
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,getOtherUserInfoAPI]
                                             isShowIndicator:true
                                                parameterDic:@{@"userId" : [NSString stringWithFormat:@"%ld", (long)userId]}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  关注用户列表
- (void)getCollectionUserListPostPageSize:(NSString *)aPageSize pageNo:(NSInteger)pageNo successBlock:(void (^)(id _Nonnull))aSuccessBlock {
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,followUserListAPI]
                                             isShowIndicator:pageNo == 1 ? true : false
                                                parameterDic:@{@"pageSize":aPageSize,
                                                               @"pageNo":[NSString stringWithFormat:@"%ld",(long)pageNo]}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  关注用户
- (void)followUserWithUserId:(NSInteger)userId successBlock:(void (^)(id _Nonnull))aSuccessBlock {
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodPost
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,followUserAPI]
                                             isShowIndicator:false
                                                parameterDic:@{@"followUserId" : [NSString stringWithFormat:@"%ld", (long)userId],}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  取消关注用户
- (void)unfollowUserWithUserId:(NSInteger)userId successBlock:(void (^)(id _Nonnull))aSuccessBlock {
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodPost
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,unfollowUserAPI]
                                             isShowIndicator:false
                                                parameterDic:@{@"followUserId" : [NSString stringWithFormat:@"%ld", (long)userId],}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  收藏帖子列表
- (void)getCollectionListPostPageSize:(NSString *)aPageSize pageNo:(NSInteger)pageNo successBlock:(void(^)(id obj))aSuccessBlock {
    
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,collectionListAPI]
                                             isShowIndicator:pageNo == 1 ? true : false
                                                parameterDic:@{@"pageSize":aPageSize,
                                                               @"pageNo":[NSString stringWithFormat:@"%ld",(long)pageNo]}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
    
}

#pragma mark  收藏帖子
- (void)collectPostWithId:(NSInteger)Id successBlock:(void (^)(id _Nonnull))aSuccessBlock {
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodPost
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,collectPostAPI]
                                             isShowIndicator:false
                                                parameterDic:@{@"topicId" : [NSString stringWithFormat:@"%ld", (long)Id],}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  收藏帖子
- (void)unCollectPostWithId:(NSInteger)Id successBlock:(void (^)(id _Nonnull))aSuccessBlock {
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodPost
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,unCollectPostAPI]
                                             isShowIndicator:false
                                                parameterDic:@{@"topicId" : [NSString stringWithFormat:@"%ld", (long)Id],}
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  获取用户列表
- (void)getPostListUserId:(NSInteger)userId pageSize:(NSString *)aPageSize pageNo:(NSInteger)pageNo successBlock:(void (^)(id _Nonnull))aSuccessBlock failBlock:(void (^)(void))aFailBlock {
    [[WDNetWorkingTool shareInstance] requestWithManthMethod:RequsetMethodGet
                                     requsetParameteLocation:RequsetParameterLocationHeader
                                                  urlAddress:[NSString stringWithFormat:@"%@/%@",G_Http_URL,postListAPI]
                                             isShowIndicator:pageNo == 1 ? true : false
                                                parameterDic:@{@"pageSize":aPageSize,
                                                               @"pageNo":[NSString stringWithFormat:@"%ld",(long)pageNo],
                                                               @"userId":[NSString stringWithFormat:@"%ld",(long)userId]
                                                               }
                                         requsetSuccessBlock:^(id  _Nonnull obj) {
                                             aSuccessBlock(obj);
                                         } requsetFailBlock:^(id  _Nonnull obj) {
                                             [self handlerFailDataDic:obj];
                                         }];
}

#pragma mark  处理请求错误数据 
- (void)handlerFailDataDic:(NSDictionary *)dataDic {
    
    if ([dataDic isKindOfClass:[NSDictionary class]]) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError
                                showPosition:RemindBarPositionStatusBar
                                 contentText:dataDic[@"msg"]]
         showBarAfterTimeInterval:1.2];
        
        if ([dataDic[@"code"] integerValue] == 1001) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self clearAccountHistory];
            });
        }
    }
}

#pragma mark  清除账号数据 
- (void)clearAccountHistory {
    [DefaultsConfig cleanAllUserDefault];
    
    [[DataBaseTools manager] dropTable:HomeListTable];
    [[DataBaseTools manager] dropTable:CommentListTable];
    [[DataBaseTools manager] dropTable:UserInfoTable];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
}

#pragma mark  登录成功数据处理 
- (void)loginSuccessWithDataDic:(NSDictionary *)dataDic account:(NSString *)aAccount{
    [[LZRemindBar configurationWithStyle:RemindBarStyleInfo
                            showPosition:RemindBarPositionStatusBar
                             contentText:@"登录成功"]
     showBarAfterTimeInterval:1.2];
    
    [DefaultsConfig setObject:dataDic[@"data"] forKey:G_Authorization];
    [DefaultsConfig setObject:@"1" forKey:G_IS_Login];

    [self userInfoRequestWithSuccessBlock:^(id  _Nonnull obj) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    }];
}

@end
