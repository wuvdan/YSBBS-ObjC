//
//  PostModel.h
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/27.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PostCellStyle) {
    PostCellStyleOnlyText,
    PostCellStyleHasPic,
};

@interface UserPostModel :NSObject <NSCoding>
@property (nonatomic , assign) NSInteger      userId;
@property (nonatomic , assign) bool      isLike;
@property (nonatomic , assign) NSInteger isMy;
@property (nonatomic , assign) NSInteger id;
@property (nonatomic , assign) NSInteger commentNum;
@property (nonatomic , assign) NSInteger likeNum;

@property (nonatomic , copy  ) NSString  * nickname;
@property (nonatomic , copy  ) NSString  * headPic;
@property (nonatomic , copy  ) NSString  * img;
@property (nonatomic , copy  ) NSString  * title;
@property (nonatomic , copy  ) NSString  * createTime;
@property (nonatomic , copy) NSString * content;


- (PostCellStyle)getStyle;

@end


