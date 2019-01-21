//
//  UITextField+Limit.h
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/24.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Limit)
/**
 限制输入Emoji表情

 @param string 字符
 @return bool
 */
- (BOOL)stringContainsEmoji:(NSString *)string;

/**
 * 字母、数字、中文正则判断（不包括空格）
 */
- (BOOL)isInputRuleNotBlank:(NSString *)str;

/**
 * 字母、数字、中文正则判断（包括空格）【注意3】
 */
- (BOOL)isInputRuleAndBlank:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
