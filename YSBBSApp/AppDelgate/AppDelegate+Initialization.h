//
//  AppDelegate+Initialization.h
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/23.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Initialization)

/** 初始化window */
- (void)setupRootViewController;


/** 初始化腾讯Bugly */
- (void)initialTencentBugly;

/** 打开数据库 */
- (void)openDataBase;

/** 网络检测 */
- (void)networkStateChange;

- (void)setup3DTouch;

@end
