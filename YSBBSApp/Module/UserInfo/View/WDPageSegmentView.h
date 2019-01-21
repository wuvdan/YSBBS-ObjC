//
//  WDPageSegmentView.h
//  NestingView
//
//  Created by wudan on 2018/9/27.
//  Copyright © 2018 wudan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDPageSegmentView : UIView

- (void)scrollToIndex:(NSInteger)index;
@property (nonatomic, copy) void (^scrollToIndexBlock)(NSInteger index);
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, assign) CGFloat incationWithContentOffsetX;

@end

NS_ASSUME_NONNULL_END
