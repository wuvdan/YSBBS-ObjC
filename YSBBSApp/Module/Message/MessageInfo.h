//
//  MessageInfo.h
//  YSBBSApp
//
//  Created by wudan on 2019/1/25.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageInfo : NSObject

@property (nonatomic, copy) NSString *createTime; //!< 创建时间
@property (nonatomic, copy) NSString *title; //!< 标题
@property (nonatomic, copy) NSString *content; //!<内容

@end

NS_ASSUME_NONNULL_END
