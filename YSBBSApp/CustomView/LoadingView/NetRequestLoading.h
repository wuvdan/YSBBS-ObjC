//
//  NetRequestLoading.h
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/25.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NetRequestLoadingStyle) {
    NetRequestLoadingStyleHasText,
    NetRequestLoadingStyleNoText,
};

typedef NS_ENUM(NSInteger, NetRequestLoadingShowStyle) {
    NetRequestLoadingShowStyleDark,
    NetRequestLoadingShowStyleLight,
};

typedef NS_ENUM(NSInteger, NetRequestLoadingStatusStyle) {
    NetRequestLoadingStatusStyleSuccess,
    NetRequestLoadingStatusStyleFail,
};

@interface NetRequestLoading : UIView

+ (instancetype)shareInstance;

/**
 默认显示
 */
- (void)showViewWithindicatorViewWithRemindText:(NSString *)remindText showStyle:(NetRequestLoadingShowStyle)aShowStyle;


/**
 根据状态显示

 @param remindText 提示文字不能为空
 @param aStatusStyle 状态
 @param aShowStyle 显示样式
 */
- (void)showViewViewWithRemindText:(NSString *)remindText statusStyle:(NetRequestLoadingStatusStyle)aStatusStyle showStyle:(NetRequestLoadingShowStyle)aShowStyle;

/**
 消失
 */
- (void)dismissView;

@end

NS_ASSUME_NONNULL_END
