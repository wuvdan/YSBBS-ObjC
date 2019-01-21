//
//  UserInfoModel.m
//  YSBBSApp
//
//  Created by wudan on 2018/11/16.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeBool:self.isSingleLogin forKey:@"isSingleLogin"];
    [encoder encodeObject:self.headPic forKey:@"headPic"];
    [encoder encodeObject:self.loginName forKey:@"loginName"];
    [encoder encodeObject:self.nickname forKey:@"nickname"];
    [encoder encodeInteger:self.topicNum forKey:@"topicNum"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.isSingleLogin = [decoder decodeBoolForKey:@"isSingleLogin"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.headPic = [decoder decodeObjectForKey:@"headPic"];
        self.loginName = [decoder decodeObjectForKey:@"loginName"];
        self.nickname = [decoder decodeObjectForKey:@"nickname"];
        self.topicNum = [decoder decodeIntegerForKey:@"topicNum"];
    }
    return self;
}

@end
