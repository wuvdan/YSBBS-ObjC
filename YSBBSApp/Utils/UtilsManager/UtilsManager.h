//
//  UtilsManager.h
//  YSBBSApp
//
//  Created by wudan on 2018/9/30.
//  Copyright © 2018 forever.love. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "WDTextView.h"
#import "WDInputView.h"

@interface UtilsManager : NSObject

+ (instancetype)shareInstance;

- (WDInputView *)createInputViewWithPlaceholder:(NSString *)aPlaceholder maxLength:(NSInteger)aMaxLength leftIconName:(NSString *)aleftIconName keyboardAppearance:(UIKeyboardAppearance)aKeyboardAppearance keyboardType:(UIKeyboardType)aKeyboardType;

- (void)loginLimtWithAcount:(NSString *)account password:(NSString *)aPassword showSuccess:(nonnull void (^)(void))aShowSuccess;

- (void)registerCheckEmial:(NSString *)anEmail showSuccess:(void(^)(void))aShowSuccess;

- (void)registerLimtWithAcount:(NSString *)account emailString:(NSString *)email emailCode:(NSString *)anEmailCode password:(NSString *)aPassword  againPassword:(NSString *)aAgainPassword  showSuccess:(nonnull void (^)(void))aShowSuccess;

- (void)modifyPassowordLimtWitholdPassword:(NSString *)oldPassowrd password:(NSString *)aPassword  againPassword:(NSString *)aAgainPassword  showSuccess:(nonnull void (^)(void))aShowSuccess ;

- (void)forgetPasswordCheckWithEmial:(NSString *)anEmial emailCode:(NSString *)anEmialCode password:(NSString *)aPassword  againPassword:(NSString *)againPassword showSuccess:(nonnull void (^)(void))aShowSuccess ;

- (UIFont *)createSytemFontSize:(CGFloat)fonySize fontName:(NSString *)aName;

- (CGFloat)getCacheSize;

- (void)cleanCache;

- (WDTextView *)textViewPlaceholder:(NSString *)aPlaceholder;

- (void)wd_masLayoutSubViewsWithViewArray:(NSArray<UIView *> *)viewArray
                              columnOfRow:(NSInteger)column
                    topBottomOfItemSpeace:(CGFloat)tbSpeace
                      leftRightItemSpeace:(CGFloat)lrSpeace
                     topOfSuperViewSpeace:(CGFloat)topSpeace
                 leftRightSuperViewSpeace:(CGFloat)lrSuperViewSpeace
                          addToSubperView:(UIView *)superView
                               viewHeight:(CGFloat)viewHeight;

- (NSString *)setupCreateTime:(NSString *)timeStr;

- (CGSize)sizeForLblContent:(NSString *)strContent fixMaxWidth:(CGFloat)w andFondSize:(int)fontSize;
@end
