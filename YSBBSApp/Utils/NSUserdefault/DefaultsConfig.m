
//
//  DefaultsConfig.m
//  
//
//  Created by Macmini2015 on 16/3/28.
//  Copyright © 2016年 HYcompany. All rights reserved.
//

#import "DefaultsConfig.h"

@implementation DefaultsConfig

+ (instancetype)objectForKey:(NSString *)strKey
{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    return [config objectForKey:strKey];
}

+ (void)setObject:(id)value forKey:(NSString *)strKey
{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    [config setObject:value forKey:strKey];
}

/*清除所有的存储本地的数据*/
+ (void)cleanAllUserDefault{
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    NSDictionary * dic = [config dictionaryRepresentation];
    for (id key in dic) {
        [config removeObjectForKey:key];
    }
}
/* 清除所有的存储本地的数据*/
+ (void)clearAllUserDefaultsData
{
    NSString * appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}
@end
