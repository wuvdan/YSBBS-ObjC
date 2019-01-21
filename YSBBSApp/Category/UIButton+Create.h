//
//  UIButton+Create.h
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/24.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    WDDropDownButtonStyle_RightImage,
    WDDropDownButtonStyle_LeftImage,
} WDDropDownButtonStyle;

@interface UIButton (Create)

/**
 快速创建（仅文字）

 @param aText 标题
 @param aTextColor 标题颜色
 @param aTextFont 标题字体大小
 @param aBackgroundColor 背景颜色
 @return self
 */
- (instancetype)initWithText:(NSString *)aText textColor:(UIColor *)aTextColor textFont:(CGFloat)aTextFont backgroundColor:(UIColor *)aBackgroundColor;

- (instancetype)initWithText:(NSString *)aText textColor:(UIColor *)aTextColor textFont:(CGFloat)aTextFont imageName:(NSString *)aImageName layoutStyle:(WDDropDownButtonStyle)style speace:(CGFloat)aSpeace backgroundColor:(UIColor *)aBackgroundColor;

- (void)wd_layoutButtonWithEdgeInsetsStyle:(WDDropDownButtonStyle)style
                           imageTitleSpace:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
