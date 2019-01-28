//
//  MessageMode.h
//  YSBBSApp
//
//  Created by wudan on 2019/1/25.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageMode : NSObject

@property (nonatomic, assign) NSInteger messageId; //!< messageId
@property (nonatomic, assign) BOOL isRead; //!< 是否已读
@property (nonatomic, copy) NSString *createTime; //!< 创建时间
@property (nonatomic, copy) NSString *messageTitle; //!< 标题
@property (nonatomic, assign) NSInteger messageType; //!< 消息类型0系统1个人

@end

NS_ASSUME_NONNULL_END
