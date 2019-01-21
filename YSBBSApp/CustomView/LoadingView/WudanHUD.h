//
//  WudanHUD.h
//  WudanHUD
//
//  Created by wudan on 2019/1/21.
//  Copyright © 2019 wudan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WudanHUDStyle) {
    WudanHUDStyleDark,
    WudanHUDStyleLight,
    WudanHUDStyleClear
};

@interface WudanHUD : UIView

+ (void)setStyle:(WudanHUDStyle)style;

+ (void)showText:(NSString *)text;

+ (void)showIndicator;
+ (void)showIndicatorWithText:(NSString *)text;

+ (void)showImageViewWithImageName:(UIImage *)image;
+ (void)showImageViewWithImageName:(UIImage *)image contentText:(NSString *)text;

+ (void)showCycleIndicatorWithBackColor:(UIColor *)backColor cycleColor:(UIColor *)cycleColor;

+ (void)showDotViewWithColor:(UIColor *)color;
+ (void)showWaveWithColor:(UIColor *)color;

+ (void)dismissDelayTimeInterval:(NSTimeInterval)interval;
+ (void)dismiss;
@end

NS_ASSUME_NONNULL_END
