//
//  WDNetWorkingTool.h
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/25.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RequsetMethod) {
    RequsetMethodPost = 0,
    RequsetMethodGet = 1,
};


typedef NS_ENUM(NSInteger, RequsetParameterLocation) {
    RequsetParameterLocationBody = 0,
    RequsetParameterLocationHeader = 1,
};

typedef void (^RequsetSuccess)(id obj);
typedef void (^RequsetFail)(id obj);

@interface WDNetWorkingTool : NSObject

+ (instancetype)shareInstance;
/**
 * 网络请求
 *
 @param method 请求方式--POST/GET
 @param parameterLocation 参数位置
 @param url 接口
 @param showIndicator 显示loding视图
 @param parameter 参数
 @param successBlock 成功回调
 @param failBlock 失败回调
 */
- (void)requestWithManthMethod:(RequsetMethod)method
       requsetParameteLocation:(RequsetParameterLocation)parameterLocation
                    urlAddress:(NSString *)url
               isShowIndicator:(BOOL)showIndicator
                  parameterDic:(NSDictionary *)parameter
           requsetSuccessBlock:(RequsetSuccess)successBlock
              requsetFailBlock:(RequsetFail)failBlock;

/**
 * 单图上传
 *
 @param aUrl 地址
 @param aImage 图片
 @param showIndicator 显示loding视图
 @param successBlock 成功回调
 @param failBlock 失败回调
 */
- (void)singlePictureUploadWithUrl:(NSString *)aUrl
                             image:(UIImage *)aImage
                   isShowIndicator:(BOOL)showIndicator
               requsetSuccessBlock:(RequsetSuccess)successBlock
                  requsetFailBlock:(RequsetFail)failBlock;
/**
 * 单图上传
 *
 @param aUrl 地址
 @param aImagesArray 图片数组
 @param showIndicator 显示loding视图
 @param successBlock 成功回调
 @param failBlock 失败回调
 */
- (void)multPictureUploadWithWithUrl:(NSString *)aUrl
                         imagesArray:(NSArray<UIImage *> *)aImagesArray
                     isShowIndicator:(BOOL)showIndicator
                 requsetSuccessBlock:(RequsetSuccess)successBlock
                    requsetFailBlock:(RequsetFail)failBlock;

@end

NS_ASSUME_NONNULL_END
