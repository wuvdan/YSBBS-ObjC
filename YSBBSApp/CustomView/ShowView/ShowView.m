//
//  ShowView.m
//  BBSApp
//
//  Created by 吴丹 on 2018/8/14.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "ShowView.h"

@interface ShowView  () <UIGestureRecognizerDelegate>

@end

@implementation ShowView

- (instancetype)init{

    self = [super init];
    if(self){
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        self.frame = UIScreen.mainScreen.bounds;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (void)showView {
    [UIApplication.sharedApplication.delegate.window addSubview:self];
}

- (void)dismissView {
    [self removeFromSuperview];
}

@end
