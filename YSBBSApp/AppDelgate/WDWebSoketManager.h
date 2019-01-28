//
//  WDWebSoketManager.h
//  YSBBSApp
//
//  Created by wudan on 2019/1/25.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol WDWebSoketManagerDelegate <NSObject>

- (void)getMassageFromSeverWithInfo:(NSString *)info;

@end

@interface WDWebSoketManager : NSObject

@property (nonatomic, weak) id <WDWebSoketManagerDelegate> delegate;

+ (instancetype)manager;

- (void)contactToSeverWithUrlAddress:(NSString *)urlAddress;

- (void)closeContat;

- (void)senderMessager:(NSString *)messager;

@end


