//
//  WDNetWorkingTool.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/25.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "WDNetWorkingTool.h"
#import <AFNetworking.h>
#import "LZRemindBar.h"
#import "WudanHUD.h"

@interface WDNetWorkingTool ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation WDNetWorkingTool

static WDNetWorkingTool *_instance;
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

- (void)requestWithManthMethod:(RequsetMethod)method
       requsetParameteLocation:(RequsetParameterLocation)parameterLocation
                    urlAddress:(NSString *)url
               isShowIndicator:(BOOL)showIndicator
                  parameterDic:(NSDictionary *)parameter
           requsetSuccessBlock:(RequsetSuccess)successBlock
              requsetFailBlock:(RequsetFail)failBlock {
    
    if (method < 0 || method > 1) {
        @throw [NSException exceptionWithName:@"" reason:@"没有对应的请求方法" userInfo:nil];
    }
    
    if (method < 0 || method > 1) {
        @throw [NSException exceptionWithName:@"" reason:@"没有对应的参数位置" userInfo:nil];
    }
    
    if (url.length == 0) {
        @throw [NSException exceptionWithName:@"" reason:@"请求地址无效" userInfo:nil];
    }
    
    [WudanHUD setStyle:WudanHUDStyleDark];
        
    if (method == RequsetMethodPost) {
        
        if (parameterLocation == RequsetParameterLocationBody) {
            [self postRequestParameterInBodyWithUrl:url isShowIndicator:showIndicator parameterDictionary:parameter requsetSuccessBlock:successBlock requsetFailBlock:failBlock];
        } else {
            [self postRequestParameterInHeaderWithUrl:url isShowIndicator:showIndicator parameterDictionary:parameter requsetSuccessBlock:successBlock requsetFailBlock:failBlock];
        }
        
    } else {
        
        if (parameterLocation == RequsetParameterLocationHeader) {
            [self getRequestParameterInHeaderWithUrl:url isShowIndicator:showIndicator parameterDictionary:parameter requsetSuccessBlock:successBlock requsetFailBlock:failBlock];
        } else {
            [self getRequestParameterInBodyWithUrl:url isShowIndicator:showIndicator parameterDictionary:parameter requsetSuccessBlock:successBlock requsetFailBlock:failBlock];
        }
    }
}

- (void)postRequestParameterInBodyWithUrl:(NSString *)url
                          isShowIndicator:(BOOL)showIndicator
                      parameterDictionary:(NSDictionary *)parameter
                      requsetSuccessBlock:(RequsetSuccess)successBlock
                         requsetFailBlock:(RequsetFail)failBlock {
    
    if (showIndicator) {
        [WudanHUD showIndicator];
    }
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:parameter error:nil];
 
    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (showIndicator) {
            [WudanHUD dismiss];
        }
        if (!error) {
            if ([responseObject[@"code"] integerValue] == 0) {
                successBlock(responseObject);
            } else {
                failBlock(error);
            }
        } else {
            [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请求失败"] showBarAfterTimeInterval:1.2];
        }
    }];
    
    [task resume];
}

- (void)getRequestParameterInBodyWithUrl:(NSString *)url
                         isShowIndicator:(BOOL)showIndicator
                     parameterDictionary:(NSDictionary *)parameter
                     requsetSuccessBlock:(RequsetSuccess)successBlock
                        requsetFailBlock:(RequsetFail)failBlock {
    
    if (showIndicator) {
        [WudanHUD showIndicator];
    }
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:url parameters:parameter error:nil];
    
    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        if (showIndicator) {
            [WudanHUD dismiss];
        }

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

        if (!error) {
            if ([dic[@"code"] integerValue] == 0) {
                successBlock(dic);
            } else {
                failBlock(dic);
            }
        } else {
            [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请求失败"] showBarAfterTimeInterval:1.2];
        }
    }];

    [task resume];
}


- (void)postRequestParameterInHeaderWithUrl:(NSString *)url
                            isShowIndicator:(BOOL)showIndicator
                        parameterDictionary:(NSDictionary *)parameter
                        requsetSuccessBlock:(RequsetSuccess)successBlock
                           requsetFailBlock:(RequsetFail)failBlock {
    
    if ([[DefaultsConfig objectForKey:G_IS_Login] boolValue]) {
        [self.sessionManager.requestSerializer setValue:[DefaultsConfig objectForKey:G_Authorization] forHTTPHeaderField:@"Authorization"];
    }
    
    if (showIndicator) {
        [WudanHUD showIndicator];
    }
    
    [self.sessionManager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (showIndicator) {
            [WudanHUD dismiss];
        }
        
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
        
        if (showIndicator) {
            [WudanHUD dismiss];
        }
    }];
}

- (void)getRequestParameterInHeaderWithUrl:(NSString *)url
                           isShowIndicator:(BOOL)showIndicator
                       parameterDictionary:(NSDictionary *)parameter
                       requsetSuccessBlock:(RequsetSuccess)successBlock
                          requsetFailBlock:(RequsetFail)failBlock {
    // 设置请求头
    if ([[DefaultsConfig objectForKey:G_IS_Login] boolValue]) {
        [self.sessionManager.requestSerializer setValue:[DefaultsConfig objectForKey:G_Authorization] forHTTPHeaderField:@"Authorization"];
    }
    
    if (showIndicator) {
        [WudanHUD showIndicator];
    }
    
    [self.sessionManager GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showIndicator) {
            [WudanHUD dismiss];
        }
        
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLogInfo(@"%@--%@--%@",url,parameter,jsonStr);
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"code"] integerValue] == 0) {
            successBlock(dic);
        } else {
            failBlock(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (showIndicator) {
            [WudanHUD dismiss];
        }
            
        if (error.code == - 1001) {
            [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请求超时"] showBarAfterTimeInterval:1.2];
        } else {
            [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请求失败"] showBarAfterTimeInterval:1.2];
        }
    }];
}

- (void)singlePictureUploadWithUrl:(NSString *)aUrl
                             image:(UIImage *)aImage
                   isShowIndicator:(BOOL)showIndicator
               requsetSuccessBlock:(RequsetSuccess)successBlock
                  requsetFailBlock:(RequsetFail)failBlock{
    
    // 设置请求头
    if ([[DefaultsConfig objectForKey:G_IS_Login] boolValue]) {
        [self.sessionManager.requestSerializer setValue:[DefaultsConfig objectForKey:G_Authorization] forHTTPHeaderField:@"Authorization"];
    }
    
    [self.sessionManager POST:aUrl
                   parameters:nil
    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
        
        UIImage  *image = aImage;
        
        NSString *dateString = [self currentDate];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        double scaleNum = (double)300*1024/imageData.length;
        imageData = scaleNum < 1 ? UIImageJPEGRepresentation(image, scaleNum) : UIImageJPEGRepresentation(image, 0.5);
        
        [formData  appendPartWithFileData:imageData
                                     name:@"file"
                                 fileName:[NSString  stringWithFormat:@"%@.png",dateString]
                                 mimeType:@"image/jpg/png/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"--------%f", (double)uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@", dic);
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

- (void)multPictureUploadWithWithUrl:(NSString *)aUrl
                         imagesArray:(NSArray<UIImage *> *)aImagesArray
                     isShowIndicator:(BOOL)showIndicator
                 requsetSuccessBlock:(RequsetSuccess)successBlock
                    requsetFailBlock:(RequsetFail)failBlock{
    
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


#pragma mark  获取当前时间 
- (NSString *)currentDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *formormat = [[NSDateFormatter alloc]init];
    [formormat setDateFormat:@"HH-mm-ss-sss"];
    return [formormat stringFromDate:date];
}

@end
