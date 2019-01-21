//
//  WDImagePicker.h
//  IntelligenceHome
//
//  Created by Vincent Yang on 2018/4/27.
//  Copyright © 2018年 xlz.foreve.love. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WDImagePicker;
/**
 选择器的回调
 
 @param picker 当前picker对象
 @param error error
 @param image 图片
 */
typedef void(^PickerCompletion)(WDImagePicker * picker,NSError* error,UIImage* image);

@interface WDImagePicker : NSObject


/**
 单例模式，可以直接获取对象
 
 @return ABImagePicker
 */
+(instancetype)shared;


/**
 设置当前选择器的VC
 
 @param vc 当前选择器的VC
 */
-(void)startWithVC:(UIViewController *)vc;


/**
 选择器的回调
 
 @param comp 回调中有图片
 */
-(void)setPickerCompletion:(PickerCompletion)comp;

@end
