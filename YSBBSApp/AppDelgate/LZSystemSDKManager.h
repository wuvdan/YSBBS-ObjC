//
//  LZSystemSDKManager.h
//  YSBBSApp
//
//  Created by wudan on 2019/1/25.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ContactsUI/ContactsUI.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZSystemSDKManager : NSObject

+ (instancetype)manager;

/**
 选择联系人  先添加权限
 
 @param result 选择的信息
 */
- (void)lz_selecteContactResulet:(void(^)(CNContact *obj))result API_AVAILABLE(ios(9.0));

/**
 发送邮件
 
 @param toRecipients 收件人群组
 @param ccRecipients 抄送人群组
 @param bccRecipients 密送人群组
 @param theme 主题
 @param emailContent 正文内容
 @param isHTML 是否是HTML格式
 @param result 发送结果
 */
- (void)lz_postEmialWithToRecipients:(NSArray<NSString *> *)toRecipients
                        ccRecipients:(NSArray<NSString *> *)ccRecipients
                       bccRecipients:(NSArray<NSString *> *)bccRecipients
                               theme:(NSString *)theme
                        emailContent:(NSString *)emailContent
                              isHTML:(BOOL)isHTML
                               reslt:(void(^)(NSInteger))result;
/**
 发送短信
 
 @param toRecipients 收件人群组
 @param content 内容
 @param result 发送结果
 */
- (void)lz_sendMessageWithToRecipients:(NSArray<NSString *> *)toRecipients
                               content:(NSString *)content
                                 reslt:(void(^)(NSInteger))result;
/**
 拨号
 
 @param phoneNum 号码
 */
- (void)lz_dailPhone:(NSString *)phoneNum;

/**
 开启定位服务
 
 @param localResult 定位获取信息
 */
- (void)lz_openLocationService:(void(^)(id info))localResult;

/**
 IOS 10的通知   推送消息 支持的音频  图片 <= 10M  视频 <= 50M
 
 @param body 消息内容
 @param promptTone 提示音
 @param soundName 音频
 @param imageName 图片
 @param movieName 视频
 @param identifier 消息标识
 */
-(void)lz_pushNotification_IOS_10_Title:(NSString *)title
                               subtitle:(NSString *)subtitle
                                   body:(NSString *)body
                             promptTone:(NSString *)promptTone
                              soundName:(NSString *)soundName
                              imageName:(NSString *)imageName
                              movieName:(NSString *)movieName
                           timeInterval:(NSTimeInterval)TimeInterval
                                repeats:(BOOL)repeats
                             Identifier:(NSString *)identifier API_AVAILABLE(ios(10.0));

/**
 IOS 10前的通知
 
 @param timeInterval 延迟时间
 @param repeatInterval 重复提醒次数
 @param alertBody 内容
 @param alertTitle 标题
 @param alertAction 滑动文字
 @param alertLaunchImage alertLaunchImage
 @param soundName 声音 为空则为系统声音
 @param userInfo 字典参数
 */
- (void)lz_pushNotifationWithTimeInterval:(NSTimeInterval)timeInterval
                           repeatInterval:(NSInteger)repeatInterval
                                alertBody:(NSString *)alertBody
                               alertTitle:(NSString *)alertTitle
                              alertAction:(NSString *)alertAction
                         alertLaunchImage:(NSString *)alertLaunchImage
                                soundName:(NSString *)soundName
                                 userInfo:(NSDictionary *)userInfo;
@end

NS_ASSUME_NONNULL_END
