//
//  UIView+Create.h
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/24.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UIViewLineDirection) {
    UIViewLineDirectionTop,
    UIViewLineDirectionLeading,
    UIViewLineDirectionTrealing,
    UIViewLineDirectionBottom,
};

@interface UIView (Create)


/**
 添加边框

 @param direction 方向
 @param aLineColor 颜色
 @param aLineHeight 宽度或者高度
 */
- (void)addLineInDirection:(UIViewLineDirection)direction lineColor:(UIColor *)aLineColor lineHeight:(CGFloat)aLineHeight;

@end

NS_ASSUME_NONNULL_END
