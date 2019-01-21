//
//  UILabel+Create.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/24.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "UILabel+Create.h"

@implementation UILabel (Create)

- (instancetype)initWithText:(NSString *)aText textColor:(UIColor *)aTextColor textFont:(CGFloat)aTextFont textAlignment:(NSTextAlignment)atextAlignment {
    self = [super init];
    if (self) {
        self.text = aText;
        self.textColor = aTextColor;
        self.font = [UIFont systemFontOfSize:aTextFont * UIScreen.mainScreen.bounds.size.width/375.0];
        self.textAlignment = atextAlignment;
    }
    return self;
}

@end
