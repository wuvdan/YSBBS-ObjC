//
//  UIScrollView+Addition.m
//  YSBBSApp
//
//  Created by wudan on 2019/1/17.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import "UIScrollView+Addition.h"
#import "UITextView+Addition.h"
#import <objc/runtime.h>

@implementation UIScrollView (Addition)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(setContentSize:)), class_getInstanceMethod(self, @selector(st_setContentSize:)));
    });
}

- (void)st_setContentSize:(CGSize)contentSize{
    if ([self isKindOfClass:[UITextView class]]) {
        UITextView * t_view = (UITextView *)self;
        if (t_view.isAutoHeightEnable) {
            NSString * key = t_view.layout_key;
            CGFloat height = contentSize.height;
            CGRect frame = self.frame;
            if (t_view.st_maxHeight > 0 && height > t_view.st_maxHeight) {
                height = t_view.st_maxHeight;
            }
            if (height < t_view.st_minHeight && t_view.st_minHeight > 0) {
                height = t_view.st_minHeight;
            }
            frame.size.height = height;
            if ([key isEqualToString:st_layout_frame]) {
                self.frame = frame;
            }else{
                if (t_view.heightConstraint) {
                    if ([t_view.heightConstraint isKindOfClass:NSClassFromString(@"NSContentSizeLayoutConstraint")]) {
                        self.scrollEnabled = NO;
                    }else{
                        //主动添加了高度约束
                        self.scrollEnabled = YES;
                        self.frame = frame;
                        t_view.heightConstraint.constant = height;
                    }
                }else{
                    self.scrollEnabled = NO;
                }
                
            }
        }
    }
    [self st_setContentSize:contentSize];
}
@end
