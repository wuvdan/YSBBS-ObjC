//
//  UserInfoModel.h
//  YSBBSApp
//
//  Created by wudan on 2018/11/16.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoModel : NSObject <NSCoding>

@property (nonatomic , copy  ) NSString  * email;
@property (nonatomic , assign) BOOL isSingleLogin;
@property (nonatomic , copy  ) NSString  * headPic;
@property (nonatomic , copy  ) NSString  * loginName;
@property (nonatomic , copy  ) NSString  * nickname;
@property (nonatomic , assign) NSInteger topicNum;

@end

NS_ASSUME_NONNULL_END
