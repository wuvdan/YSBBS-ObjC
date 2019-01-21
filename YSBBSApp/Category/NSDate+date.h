//
//  NSDate+date.h
//  YSBBSApp
//
//  Created by wudan on 2018/11/15.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (date)

// 是否是今年
- (BOOL)isThisYear;

// 是否今天
- (BOOL)isThisToday;

// 是否昨天
- (BOOL)isThisYesterday;

@end

NS_ASSUME_NONNULL_END


