//
//  AppDelegate.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/23.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Initialization.h"
#import "AppDelegate+Socket.h"
#import "WDWebSoketManager.h"
#import "LZSystemSDKManager.h"
#import <UserNotifications/UserNotifications.h>
#import <WHDebugTool/WHDebugToolManager.h>


@interface AppDelegate ()<WDWebSoketManagerDelegate, UNUserNotificationCenterDelegate>


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLogInfo(@"APP打开");

    // 配置根控制器
    [self setupRootViewController];
    
   
    // 添加B腾讯Bugly
    [self initialTencentBugly];
    
    // 打开数据库
    [self openDataBase];
    
    // 开启网络检测
    [self networkStateChange];
    
    [self setup3DTouch];
    
    [self startSocket];
    
    //本地推送
    [self requestAuthor];
    
#ifdef DEBUG
     [[WHDebugToolManager sharedInstance] toggleWith: DebugToolTypeAll];
#else
    // do sth
#endif
  
    return YES;
}

- (void)startSocket {
    NSString *url = [NSString stringWithFormat:@"ws://118.31.12.178/%@/%@", getRemoteNotification, [DefaultsConfig objectForKey:G_Authorization]];
    [[WDWebSoketManager manager] contactToSeverWithUrlAddress:url];
    [WDWebSoketManager manager].delegate = self;
}

//创建本地通知
- (void)requestAuthor {
  
    if (@available(iOS 10.0, *)) { // iOS10 以上
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
    } else { // iOS8.0 以上
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
}

#pragma mark - UNUserNotificationCenterDelegate
//在展示通知前进行处理，即有机会在展示通知前再修改通知内容。
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    //1. 处理通知
    
    //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"1111111111");
}

- (void)getMassageFromSeverWithInfo:(NSString *)info {
    NSLog(@"%@", info);
    NSDictionary *dic = [self dictionaryWithJsonString:info];
    
    switch ([dic[@"code"] integerValue]) {
        case 1:
        {
            if (@available(iOS 10.0, *)) {
                [[LZSystemSDKManager manager] lz_pushNotification_IOS_10_Title:@"有推送啦~"
                                                                      subtitle:@""
                                                                          body:dic[@"msg"]
                                                                    promptTone:@""
                                                                     soundName:@""
                                                                     imageName:@""
                                                                     movieName:@""
                                                                  timeInterval:10
                                                                       repeats:false
                                                                    Identifier:@"111"];
            } else {
                [[LZSystemSDKManager manager] lz_pushNotifationWithTimeInterval:5
                                                                 repeatInterval:1
                                                                      alertBody:dic[@"msg"]
                                                                     alertTitle:@"提示"
                                                                    alertAction:@"查看"
                                                               alertLaunchImage:@""
                                                                      soundName:@""
                                                                       userInfo:dic];
            }        
        }
            break;
            
        default:
            break;
    }
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLogInfo(@"APP即将进从前台退出");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLogInfo(@"APP已经进入后台");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLogInfo(@"APP重新回到前台");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLogInfo(@"APP即将进入前台");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLogInfo(@"APP退出");
}

@end
