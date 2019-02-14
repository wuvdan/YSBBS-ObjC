//
//  PostModel.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/27.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "UserPostModel.h"

@implementation UserPostModel

- (PostCellStyle)getStyle {
    return self.img.length > 0 ? PostCellStyleHasPic :PostCellStyleOnlyText;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:self.userId forKey:@"userId"];
    [encoder encodeBool:self.isLike forKey:@"isLike"];
    [encoder encodeInteger:self.isMy forKey:@"isMy"];
    [encoder encodeInteger:self.id forKey:@"id"];
    [encoder encodeInteger:self.commentNum forKey:@"commentNum"];
    [encoder encodeInteger:self.likeNum forKey:@"likeNum"];
    [encoder encodeObject:self.nickname forKey:@"nickname"];
    [encoder encodeObject:self.headPic forKey:@"headPic"];
    [encoder encodeObject:self.img forKey:@"img"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.createTime forKey:@"createTime"];
    [encoder encodeObject:self.content forKey:@"content"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.isLike     = [decoder decodeBoolForKey:@"isLike"];
        self.id         = [decoder decodeIntegerForKey:@"id"];
        self.isMy       = [decoder decodeIntegerForKey:@"isMy"];
        self.userId = [decoder decodeIntegerForKey:@"userId"];
        self.commentNum = [decoder decodeIntegerForKey:@"commentNum"];
        self.likeNum    = [decoder decodeIntegerForKey:@"likeNum"];
        self.nickname   = [decoder decodeObjectForKey:@"nickname"];
        self.headPic    = [decoder decodeObjectForKey:@"headPic"];
        self.img        = [decoder decodeObjectForKey:@"img"];
        self.title      = [decoder decodeObjectForKey:@"title"];
        self.createTime = [decoder decodeObjectForKey:@"createTime"];
        self.content    = [decoder decodeObjectForKey:@"content"];
    }
    return self;
}

@end
