//
//  CommentModel.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/28.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel


- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeBool:self.isLike forKey:@"isLike"];
    [encoder encodeInteger:self.isMy forKey:@"isMy"];
    [encoder encodeInteger:self.id forKey:@"id"];
    [encoder encodeInteger:self.likeNum forKey:@"likeNum"];
    [encoder encodeObject:self.nickname forKey:@"nickname"];
    [encoder encodeObject:self.headPic forKey:@"headPic"];
    [encoder encodeObject:self.createTime forKey:@"createTime"];
    [encoder encodeObject:self.content forKey:@"content"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.isLike = [decoder decodeBoolForKey:@"isLike"];
        self.id = [decoder decodeIntegerForKey:@"id"];
        self.isMy = [decoder decodeIntegerForKey:@"isMy"];
        self.likeNum = [decoder decodeIntegerForKey:@"likeNum"];
        self.nickname = [decoder decodeObjectForKey:@"nickname"];
        self.headPic = [decoder decodeObjectForKey:@"headPic"];
        self.createTime = [decoder decodeObjectForKey:@"createTime"];
        self.content = [decoder decodeObjectForKey:@"content"];
    }
    return self;
}


@end
