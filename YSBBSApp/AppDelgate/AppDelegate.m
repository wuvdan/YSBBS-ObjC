//
//  AppDelegate.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/23.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Initialization.h"

@interface AppDelegate ()


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
  
 
    return YES;
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
