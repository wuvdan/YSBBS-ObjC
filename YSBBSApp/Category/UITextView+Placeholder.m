//
//  UITextView+Placeholder.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/27.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "UITextView+Placeholder.h"
#import <objc/runtime.h>

@implementation UITextView (Placeholder)

+(void)load{
    
    // 获取类方法 class_getClassMethod
    // 获取对象方法 class_getInstanceMethod
    Method setFontMethod = class_getInstanceMethod(self, @selector(setFont:));
    Method was_setFontMethod =class_getInstanceMethod(self, @selector(was_setFont:));
    // 交换方法的实现
    method_exchangeImplementations(setFontMethod, was_setFontMethod);
}

-(void)wd_setPlaceholderWithText:(NSString *)text Color:(UIColor *)color{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = self.font;
    label.textColor = color;
    label.numberOfLines = 0;
    [self addSubview:label];
    [self setValue:label forKey:@"_placeholderLabel"];
}

- (void)was_setFont:(UIFont *)font{
    //调用原方法 setFont:
    [self was_setFont:font];
    //设置占位字符串的font
    UILabel *label = [self valueForKey:@"_placeholderLabel"];
    label.font = font;
}

@end
