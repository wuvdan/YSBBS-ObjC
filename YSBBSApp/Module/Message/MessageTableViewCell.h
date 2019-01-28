//
//  MessageTableViewCell.h
//  YSBBSApp
//
//  Created by wudan on 2019/1/25.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MessageMode;

@interface MessageTableViewCell : UITableViewCell

@property (nonatomic, strong) MessageMode *model; //!< 消息model

@end

NS_ASSUME_NONNULL_END
