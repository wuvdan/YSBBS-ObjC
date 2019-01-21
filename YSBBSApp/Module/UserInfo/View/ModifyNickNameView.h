//
//  ModifyNickNameView.h
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/27.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "ShowView.h"

@interface ModifyNickNameView : ShowView

@property (nonatomic, copy) void (^changeNickNameHandler)(NSString *nickName);

@end
