//
//  WDPageCategory.h
//  NestingView
//
//  Created by wudan on 2018/9/27.
//  Copyright © 2018 wudan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (WDExtension)

@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat height;

@end

@interface UIViewController (AddScrollView)

@property (nonatomic, strong) UIScrollView *rootScrollView;

@end

NS_ASSUME_NONNULL_END
