//
//  UIButton+Create.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/24.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "UIButton+Create.h"

@implementation UIButton (Create)


- (instancetype)initWithText:(NSString *)aText textColor:(UIColor *)aTextColor textFont:(CGFloat)aTextFont backgroundColor:(UIColor *)aBackgroundColor {
    self = [super init];
    if (self) {
        [self setTitle:aText forState:UIControlStateNormal];
        [self setTitleColor:aTextColor forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:aTextFont * UIScreen.mainScreen.bounds.size.width/375.0];
        self.backgroundColor = aBackgroundColor;
    }
    return self;
}

- (instancetype)initWithText:(NSString *)aText textColor:(UIColor *)aTextColor textFont:(CGFloat)aTextFont imageName:(NSString *)aImageName layoutStyle:(WDDropDownButtonStyle)style speace:(CGFloat)aSpeace backgroundColor:(UIColor *)aBackgroundColor {
    self = [super init];
    if (self) {
        [self setTitle:aText forState:UIControlStateNormal];
        [self setTitleColor:aTextColor forState:UIControlStateNormal];
        [self setImage:[[UIImage imageNamed:aImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self wd_layoutButtonWithEdgeInsetsStyle:style imageTitleSpace:aSpeace];
        self.titleLabel.font = [UIFont systemFontOfSize:aTextFont * UIScreen.mainScreen.bounds.size.width/375.0];
        self.backgroundColor = aBackgroundColor;
    }
    return self;
}

- (void)wd_layoutButtonWithEdgeInsetsStyle:(WDDropDownButtonStyle)style
                           imageTitleSpace:(CGFloat)space {
    CGFloat imageWith = self.imageView.frame.size.width;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    switch (style) {
        case WDDropDownButtonStyle_LeftImage:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space / 2.0, 0, space / 2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space / 2.0, 0, -space / 2.0);
        }
            break;
        case WDDropDownButtonStyle_RightImage:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + space / 2.0, 0, -labelWidth - space / 2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith - space / 2.0, 0, imageWith + space / 2.0);
        }
            break;
        default:
            break;
    }
    
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

@end
