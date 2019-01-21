//
//  WDSpreadButton.m
//  SpreadButton
//
//  Created by 吴丹 on 2018/8/22.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "WDSpreadButton.h"

@interface WDSpreadButton  () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *personButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, strong) UIView *oldView;


@end

@implementation WDSpreadButton

- (instancetype)init{

    self = [super init];
    if(self){
        [self addTarget:self action:@selector(dismissAllButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)layoutSubviews {
    [self addSubview:self.button];

    if (self.oldFrame.size.width == 0) {
        self.oldFrame = self.frame;
        self.button.frame = self.bounds;
        self.oldView = self.superview;
    }
}

- (void)buttonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 10 || button.tag == 11) {
        if (self.buttonAction) {
            self.buttonAction(button.tag);
        }
    }
    
    self.button.selected = !self.button.selected;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.8;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = ULLONG_MAX;
    
    if (self.button.selected) {
        [self spreadAllButton];
        [self.button.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    } else {
        [self dismissAllButton];
    }
}

- (void)dismissAllButton {
    
    self.button.selected = false;
    self.personButton.frame = self.button.frame;
    self.addButton.frame = self.button.frame;
    [self.personButton removeFromSuperview];
    [self.addButton removeFromSuperview];
    [self removeFromSuperview];
    [self.oldView addSubview:self];
    self.frame = self.oldFrame;
    
    self.button.frame = self.bounds;
    
    [self.button.layer removeAllAnimations];
}

- (void)spreadAllButton {

    [self removeFromSuperview];
    
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    
    self.frame = UIScreen.mainScreen.bounds;
    self.backgroundColor = UIColor.clearColor;
    
    self.button.frame = self.oldFrame;
    
    [self addSubview:self.personButton];
    [self addSubview:self.addButton];
    
    self.personButton.frame = self.button.frame;
    self.addButton.frame = self.button.frame;
    
 
    
    [UIView animateWithDuration:0.5 animations:^{
        self.personButton.frame = CGRectMake(self.button.frame.origin.x+kRealWidthValue(40)+10, self.button.frame.origin.y, self.button.frame.size.width, self.button.frame.size.height);
        self.addButton.frame = CGRectMake(self.button.frame.origin.x+kRealWidthValue(40) * 2 +20, self.button.frame.origin.y, self.button.frame.size.width, self.button.frame.size.height);
    }];
}

- (UIButton *)addButton {
    if (!_addButton){
        _addButton = ({
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            b.tag = 11;
            [b setImage:[[UIImage imageNamed:@"post"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            b.tintColor = kMainWhite;
            b.backgroundColor = kMainBlack;
            b.layer.cornerRadius = kRealWidthValue(20);
            [b addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            b;
        });
    }
    return _addButton;
}

- (UIButton *)personButton {
    if (!_personButton){
        _personButton = ({
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            b.tag = 10;
            [b setImage:[[UIImage imageNamed:@"userCenter"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            b.backgroundColor = kMainBlack;
            b.tintColor = kMainWhite;
            b.layer.cornerRadius = kRealWidthValue(20);
            [b addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            b;
        });
    }
    return _personButton;
}

- (UIButton *)button {
    if (!_button){
        _button = ({
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            [b setImage:[[UIImage imageNamed:@"plus_F"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [b setImage:[[UIImage imageNamed:@"plus_F"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
            [b setTitleColor:kMainWhite forState:UIControlStateNormal];
            b.tintColor = kMainBlack;
            b.titleLabel.font = kFont(13);
            b.layer.cornerRadius = kRealWidthValue(20);
            [b addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            b;
        });
    }
    return _button;
}
@end
