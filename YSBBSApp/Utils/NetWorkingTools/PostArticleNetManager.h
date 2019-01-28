//
//  PostArticleNetManager.h
//  YSBBSApp
//
//  Created by wudan on 2019/1/28.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostArticleNetManager : NSObject
+ (instancetype)shareInstance;

- (void)getRequestWithParameterDictionary:(NSDictionary *)parameter
                      requsetSuccessBlock:(void(^)(id obj))successBlock
                         requsetFailBlock:(void(^)(id obj))failBlock;

- (void)multPictureUploadWithImagesArray:(NSArray<UIImage *> *)aImagesArray
                     requsetSuccessBlock:(void(^)(id obj))successBlock
                        requsetFailBlock:(void(^)(id obj))failBlock;

@end

NS_ASSUME_NONNULL_END
