//
//  AppDelegate+Initialization.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/23.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "AppDelegate+Initialization.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import <Bugly/Bugly.h>
#import <AFNetworking.h>
#import <Social/Social.h>

@implementation AppDelegate (Initialization)

- (void)setupRootViewController {
    self.window                      = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor      = UIColor.whiteColor;
    // 登录
    LoginViewController *login       = [[LoginViewController alloc] init];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
    // 首页
    HomeViewController *home         = [[HomeViewController alloc] init];
    UINavigationController *homeNav  = [[UINavigationController alloc] initWithRootViewController:home];
    
    if ([[DefaultsConfig objectForKey:G_IS_Login] boolValue]) {
        self.window.rootViewController = homeNav;
    } else {
        self.window.rootViewController = loginNav;
    }
    
    [self.window makeKeyAndVisible];
}


#pragma mark  初始化腾讯Bugly 
- (void)initialTencentBugly {
    [Bugly startWithAppId:G_TencentBuglyKey];
}

- (void)openDataBase {
    [[DataBaseTools manager] createTableWithName:HomeListTable];
    [[DataBaseTools manager] createTableWithName:CommentListTable];
    [[DataBaseTools manager] createTableWithName:UserInfoTable];
}

- (void)networkStateChange {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 当网络状态改变时调用
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLogInfo(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"暂无网络，请检查网络是否已连接"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                break;
        }
    }];
    //开始监控
    [manager startMonitoring];
}

- (void)setup3DTouch {
    UIApplicationShortcutItem *shoreItem1 = [[UIApplicationShortcutItem alloc] initWithType:@"cn.damon.DM3DTouchDemo.openSearch" localizedTitle:@"发帖" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose] userInfo:nil];
    
    UIApplicationShortcutItem *shoreItem2 = [[UIApplicationShortcutItem alloc] initWithType:@"cn.damon.DM3DTouchDemo.openCompose" localizedTitle:@"分享" localizedSubtitle:@"" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare] userInfo:nil];
    
#if DEBUG
    [UIApplication sharedApplication].shortcutItems = @[shoreItem1, shoreItem2];
#else
    [UIApplication sharedApplication].shortcutItems = @[shoreItem1];
#endif
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    LoginViewController *login       = [[LoginViewController alloc] init];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
    
    HomeViewController *home         = [[HomeViewController alloc] init];
    UINavigationController *homeNav  = [[UINavigationController alloc] initWithRootViewController:home];
    
    if ([[DefaultsConfig objectForKey:G_IS_Login] boolValue]) {
        self.window.rootViewController = homeNav;
        home.needPushToPostArticleController = true;
    } else {
        self.window.rootViewController = loginNav;
    }
}


@end
