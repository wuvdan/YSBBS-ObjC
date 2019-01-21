//
//  UILabel+Create.h
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/24.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Create)

/**
 初始化

 @param aText 文字
 @param aTextColor 颜色
 @param aTextFont 字体大小
 @param atextAlignment 对齐方式
 @return self
 */
- (instancetype)initWithText:(NSString *)aText textColor:(UIColor *)aTextColor textFont:(CGFloat)aTextFont textAlignment:(NSTextAlignment)atextAlignment;

@end

NS_ASSUME_NONNULL_END
