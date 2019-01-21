//
//  UITextView+Addition.h
//  YSBBSApp
//
//  Created by wudan on 2019/1/17.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const st_layout_frame = @"st_layout_frame";
static NSString * const st_auto_layout = @"st_auto_layout";

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Addition)
/**
 是否自适应高度
 */

@property (nonatomic, assign)IBInspectable BOOL isAutoHeightEnable;

/**
 设置最大高度
 */
@property (nonatomic, assign)IBInspectable CGFloat st_maxHeight;

/**
 最小高度
 */
@property (nonatomic, assign) CGFloat st_minHeight;

/**
 占位符
 */
@property (nonatomic, copy)IBInspectable NSString * st_placeHolder;
/**
 占位符颜色
 */
@property (nonatomic, strong) UIColor * st_placeHolderColor;

/**
 占位Label
 */
@property (nonatomic, strong) UITextView * st_placeHolderLabel;

/**
 行间距
 */
@property (nonatomic, assign)IBInspectable CGFloat st_lineSpacing;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, copy) NSString *layout_key;
@property (nonatomic, copy) void(^textViewHeightDidChangedHandle)(CGFloat textViewHeight);

@end

NS_ASSUME_NONNULL_END
