//
//  OtherUserInfoModel.h
//  YSBBSApp
//
//  Created by wudan on 2019/2/14.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserPostModel.h"
NS_ASSUME_NONNULL_BEGIN

//@interface OtherUserInfoTopicList :NSObject
//@property (nonatomic , assign) NSInteger              id;
//@property (nonatomic , assign) NSInteger              likeNum;
//@property (nonatomic , assign) NSInteger              isLike;
//@property (nonatomic , assign) NSInteger              commentNum;
//@property (nonatomic , copy) NSString              * img;
//@property (nonatomic , copy) NSString              * title;
//@property (nonatomic , assign) NSInteger              userId;
//@property (nonatomic , copy) NSString              * createTime;
//@property (nonatomic , assign) NSInteger              isMy;
//@property (nonatomic , copy) NSString              * nickname;
//@property (nonatomic , copy) NSString              * headPic;
//@property (nonatomic , copy) NSString              * content;
//
//@end

@interface OtherUserInfoModel : NSObject
@property (nonatomic , copy) NSArray<UserPostModel *>              * topicList;
@property (nonatomic , assign) NSInteger              fansNum;
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , copy) NSString              * headPic;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , assign) NSInteger              topicNum;
@property (nonatomic , assign) NSInteger              getLikeNum;
@property (nonatomic , assign) bool              isFollow;

@end

NS_ASSUME_NONNULL_END
