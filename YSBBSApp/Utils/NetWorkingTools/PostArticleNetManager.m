//
//  PostArticleNetManager.m
//  YSBBSApp
//
//  Created by wudan on 2019/1/28.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import "PostArticleNetManager.h"
#import <AFNetworking.h>
#import "LZRemindBar.h"

@interface PostArticleNetManager ()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation PostArticleNetManager

static PostArticleNetManager *_instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

+ (instancetype)shareInstance {
    return  [[self alloc] init];
}

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer.acceptableContentTypes = [_sessionManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil]];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [_sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _sessionManager.requestSerializer.timeoutInterval = 20;
        [_sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    return _sessionManager;
}

- (void)multPictureUploadWithImagesArray:(NSArray<UIImage *> *)aImagesArray
                     requsetSuccessBlock:(void (^)(id _Nonnull))successBlock
                        requsetFailBlock:(void (^)(id _Nonnull))failBlock {
    
    [self multPictureUploadWithWithUrl:[NSString stringWithFormat:@"%@/%@",G_Http_URL,multifFleUploadAPI]
                           imagesArray:aImagesArray
                       isShowIndicator:false
                   requsetSuccessBlock:^(id obj) {
                       successBlock(obj);
                   } requsetFailBlock:^(id obj) {
                       failBlock(obj);
                   }];
}

- (void)getRequestWithParameterDictionary:(NSDictionary *)parameter
                      requsetSuccessBlock:(void (^)(id _Nonnull))successBlock
                         requsetFailBlock:(void (^)(id _Nonnull))failBlock {
    [self getRequestParameterInHeaderWithUrl:[NSString stringWithFormat:@"%@/%@",G_Http_URL,addPostAPI]
                             isShowIndicator:false
                         parameterDictionary:parameter
                         requsetSuccessBlock:^(id obj) {
                             successBlock(obj);
                         } requsetFailBlock:^(id obj) {
                             failBlock(obj);
                         }];
}

- (void)multPictureUploadWithWithUrl:(NSString *)aUrl
                         imagesArray:(NSArray<UIImage *> *)aImagesArray
                     isShowIndicator:(BOOL)showIndicator
                 requsetSuccessBlock:(void(^)(id obj))successBlock
                    requsetFailBlock:(void(^)(id obj))failBlock{
    
    // 设置请求头
    if ([[DefaultsConfig objectForKey:G_IS_Login] boolValue]) {
        [self.sessionManager.requestSerializer setValue:[DefaultsConfig objectForKey:G_Authorization] forHTTPHeaderField:@"Authorization"];
    }
    
    self.sessionManager.requestSerializer.timeoutInterval = 100;
    
    [self.sessionManager POST:aUrl
                   parameters:nil
    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < aImagesArray.count; i++) {
            
            UIImage  *image = aImagesArray[i];
            NSString *dateString = [self currentDate];
            
            NSData *imageData;
            if ([image isKindOfClass:[UIImage class]]) {
                imageData = UIImageJPEGRepresentation(image, 1);
                
                double scaleNum = (double)300*1024/imageData.length;
                imageData = scaleNum < 1 ? UIImageJPEGRepresentation(image, scaleNum) : UIImageJPEGRepresentation(image, 0.5);
                
                [formData  appendPartWithFileData:imageData
                                             name:@"files"
                                         fileName:[NSString  stringWithFormat:@"%@.png",dateString]
                                         mimeType:@"image/jpg/png/jpeg"];
            } else {
                [formData appendPartWithFileData:(NSData *)image
                                            name: @"files"
                                        fileName:[NSString  stringWithFormat:@"%@.gif",dateString]
                                        mimeType:@"image/gif"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"--------%f", (double)uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"code"] integerValue] == 0) {
            successBlock(dic);
        } else {
            failBlock(dic);
        }
        NSLog(@"------%@", dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == - 1001) {
            [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请求超时"] showBarAfterTimeInterval:1.2];
        } else {
            [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请求失败"] showBarAfterTimeInterval:1.2];
        }
    }];
}

- (void)getRequestParameterInHeaderWithUrl:(NSString *)url
                           isShowIndicator:(BOOL)showIndicator
                       parameterDictionary:(NSDictionary *)parameter
                       requsetSuccessBlock:(void(^)(id obj))successBlock
                          requsetFailBlock:(void(^)(id obj))failBlock {
    // 设置请求头
    if ([[DefaultsConfig objectForKey:G_IS_Login] boolValue]) {
        [self.sessionManager.requestSerializer setValue:[DefaultsConfig objectForKey:G_Authorization] forHTTPHeaderField:@"Authorization"];
    }

    [self.sessionManager GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLogInfo(@"发布帖子：%@--%@--%@",url,parameter,jsonStr);
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"code"] integerValue] == 0) {
            successBlock(dic);
        } else {
            failBlock(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        if (error.code == - 1001) {
            [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请求超时"] showBarAfterTimeInterval:1.2];
        } else {
            [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请求失败"] showBarAfterTimeInterval:1.2];
        }
    }];
}



#pragma mark  获取当前时间
- (NSString *)currentDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *formormat = [[NSDateFormatter alloc]init];
    [formormat setDateFormat:@"HH-mm-ss-sss"];
    return [formormat stringFromDate:date];
}

@end
