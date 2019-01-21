//
//  AppConfig.h
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/23.
//  Copyright © 2018 forever.love. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h

// 主题颜色
/** 黑色 */
#define kMainBlack kRGB(48, 48, 48)
/** 白色 */
#define kMainWhite kRGB(238, 235, 235)
/** 灰色 */
#define kMainGrey kRGB(175, 172, 172)
/** 深绿色 */
#define kMainDarkGreen kRGB(54, 166, 118)
/** 浅绿色 */
#define kMainLightGreen kRGB(101, 207, 150)

// Token
#define G_Authorization           @"Authorization"

// 是否已登录
#define G_IS_Login                @"isLogin"

// APP

#define kPOST_ARTICL_IMGAGE_WIDTH  ((UIScreen.mainScreen.bounds.size.width - 15 * 2 - 10 * 2))/3


#endif /* AppConfig_h */
