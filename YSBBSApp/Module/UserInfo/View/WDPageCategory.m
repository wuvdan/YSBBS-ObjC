//
//  WDPageCategory.m
//  NestingView
//
//  Created by wudan on 2018/9/27.
//  Copyright © 2018 wudan. All rights reserved.
//

#import "WDPageCategory.h"
#import <objc/runtime.h>

@implementation UIView (WDExtension)

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

@end

static char *scrollViewKey = "scrollViewKey";
@implementation UIViewController (AddScrollView)

- (void)setRootScrollView:(UIScrollView *)rootScrollView{
    objc_setAssociatedObject(self, scrollViewKey, rootScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIScrollView *)rootScrollView {
    return objc_getAssociatedObject(self, scrollViewKey);
}

@end
