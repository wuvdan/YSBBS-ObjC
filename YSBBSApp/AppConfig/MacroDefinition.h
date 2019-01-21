//
//  MacroDefinition.h
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/23.
//  Copyright © 2018 forever.love. All rights reserved.
//

#ifndef MacroDefinition_h
#define MacroDefinition_h

// 自定义高效率的 NSLog
#ifdef DEBUG
#define NSLogError(FORMAT, ...) fprintf(stderr,"[%s:%d]【❌】\t %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define NSLogWarn(FORMAT, ...) fprintf(stderr,"[%s:%d]【⚠️】\t %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define NSLogInfo(FORMAT, ...) fprintf(stderr,"[%s:%d]【✅】\t %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLogError(...)
#define NSLogWarn(...)
#define NSLogInfo(...)
#endif

// 屏幕尺寸
#define kSCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

// 屏幕大小
#define kScreenSize [UIScreen mainScreen].bounds

#define kScreenWidthRate (kSCREEN_WIDTH /375.0)



// 状态栏的高度
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

// 导航栏的高度
#define kNavBarHeight 44.0

// iphoneX-SafeArea的高度
#define kSafeAreaHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)

// 分栏+iphoneX-SafeArea的高度
#define kTabBarHeight (49+kSafeAreaHeight)

// 导航栏+状态栏的高度
#define kTopHeight (kStatusBarHeight + kNavBarHeight)


/***************************视图,类初始化*****************************/

//property属性快速声明
#define kPropertyString(s)      @property(nonatomic,copy) NSString * s
#define kPropertyNSInteger(s)   @property(nonatomic,assign) NSIntegers
#define kPropertyFloat(s)       @property(nonatomic,assign) floats
#define kPropertyLongLong(s)    @property(nonatomic,assign) long long s
#define kPropertyNSDictionary(s)@property(nonatomic,strong) NSDictionary * s
#define kPropertyNSArray(s)     @property(nonatomic,strong) NSArray * s
#define kPropertyNSMutableArray(s)    @property(nonatomic,strong) NSMutableArray * s

/**
 根据ip6的屏幕来拉伸
 */
#define kRealWidthValue(width) ((width)*(kSCREEN_WIDTH/375.0f))
#define kRealHeightValue(height) ((height)*(kSCREEN_HEIGHT/667.0f))

/*
 字体
 */
#define kFontBold(X) [UIFont boldSystemFontOfSize:X]
#define kFont(X)  [UIFont systemFontOfSize:X]

/*
 定义UIImage对象
 */
#define kImageName(X)  [UIImage imageNamed:X]
#define kTempImageName(X)  [[UIImage imageNamed:X] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
#define kOriginalImageName(X)  [[UIImage imageNamed:X] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]


// 弧度来源于角度（x）
#define kRADIANS_FROM_DEGREES(x)       ((x) / 180.0 * M_PI)
// 角度来源于弧度（x）
#define kDEGREES_FROM_RADIANS(x)       ((x) / M_PI * 180.0)

// 随机柔和颜色
// Hue:色像 0-360度（对应0.0-1.0）。全范围。
// Saturation:饱和度 0-100（对应0.0-1.0）。越大越鲜艳，只取0.5以下。
// Brightness:亮度 0-100（对应0.0-1.0）。越大越亮，只取0.8以上。
#define kRANDOM_COLOR(colorAlpha)    [UIColor colorWithHue:( arc4random() % 361 / 360.0 ) \
saturation:( arc4random() % 50 / 100.0 ) \
brightness:( arc4random() % 20 / 100.0 ) + 0.8 \
alpha:colorAlpha];


// 设置随机颜色
#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
// 颜色
#undef    kRGB
#define kRGB(R,G,B)    [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

#undef    kRGBA
#define kRGBA(R,G,B,A)    [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

// 弱引用/强引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kRStrongSelf(type)  __strong typeof(type) type = weak##type;






#endif /* MacroDefinition_h */
