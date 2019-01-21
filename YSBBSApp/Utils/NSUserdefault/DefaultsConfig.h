//
//  DefaultsConfig.h
//  
//
//  Created by Macmini2015 on 16/3/28.
//  Copyright © 2016年 HYcompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultsConfig : NSObject

+ (nullable id)objectForKey:(nonnull NSString *)strKey;
+ (void)setObject:(nullable id)value forKey:(nonnull NSString *)strKey;
/* 清除所有的存储本地的数据*/
+ (void)clearAllUserDefaultsData;
/*清除所有的存储本地的数据*/
+ (void)cleanAllUserDefault;

@end
