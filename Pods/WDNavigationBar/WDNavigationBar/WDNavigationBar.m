//
//  WDNavigationBar.m
//  AppProjiect
//
//  Created by wudan on 2018/8/5.
//  Copyright © 2018年 wudan. All rights reserved.
//

#import "WDNavigationBar.h"

@interface WDNavigationBar  ()

@property (nonatomic, strong) UILabel *lineLabel;
@property (nullable, nonatomic, readonly) UIViewController *viewController;

@end

@implementation WDNavigationBar

- (UIView *)mainView{
    if (!_mainView) {
        _mainView = [UIView new];
        _mainView.backgroundColor = [UIColor clearColor];
        [self addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        [_mainView.superview layoutIfNeeded];
    }
    return _mainView;
}

- (UIButton *)leftButton{
    if (!_leftButton) {
        // 左边按钮
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _leftButton.adjustsImageWhenHighlighted = NO;
        _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.mainView addSubview:_leftButton];
        [_leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.mainView.mas_bottom).with.offset(-22);
        }];
    }
    return _leftButton;
}

- (UIButton *)leftTwoButton{
    if (!_leftTwoButton) {
        // 左边第二个按钮
        _leftTwoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftTwoButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _leftTwoButton.adjustsImageWhenHighlighted = NO;
        _leftTwoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_leftTwoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.mainView addSubview:_leftTwoButton];
        [_leftTwoButton addTarget:self action:@selector(clickLeftTwoButton) forControlEvents:UIControlEventTouchUpInside];
        [_leftTwoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftButton.mas_right).mas_offset(10);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(40);
            make.centerY.mas_equalTo(self.mainView.mas_bottom).with.offset(-22);
        }];
    }
    return _leftTwoButton;
}

-(UIButton *)rightButton{
    if (!_rightButton) {
        //右边按钮
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        rightButton.adjustsImageWhenHighlighted = NO;
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.mainView addSubview:rightButton];
        self.rightButton = rightButton;
        [_rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-5);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(40);
            make.centerY.mas_equalTo(self.leftButton);
        }];
        [self.rightButton.superview layoutIfNeeded];
    }
    return _rightButton;
}

-(UIButton *)rightTwoButton{
    if (!_rightTwoButton) {
        //右边第二个按钮
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        rightButton.adjustsImageWhenHighlighted = NO;
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.mainView addSubview:rightButton];
        self.rightTwoButton = rightButton;
        [_rightTwoButton addTarget:self action:@selector(clickRightTwoButton) forControlEvents:UIControlEventTouchUpInside];
        [self.rightTwoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.rightButton.mas_left).mas_offset(-10);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(40);
            make.centerY.mas_equalTo(self.leftButton);
        }];
        [self.rightTwoButton.superview layoutIfNeeded];
    }
    return _rightTwoButton;
}

-(UIButton *)centerButton{
    if (!_centerButton) {
        //中间按钮
        UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        centerButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [centerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        centerButton.adjustsImageWhenHighlighted = NO;
        [self.mainView addSubview:centerButton];
        self.centerButton = centerButton;
        [_centerButton addTarget:self action:@selector(clickCenterButton) forControlEvents:UIControlEventTouchUpInside];
        [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(self.leftButton.mas_height);
            make.width.mas_equalTo(Screen_Width - (self.rightButton.frame.size.width + 38) * 2);
            make.centerY.mas_equalTo(self.leftButton);
        }];
        [self.centerButton.superview layoutIfNeeded];
    }
    return _centerButton;
}

-(UILabel *)lineLabel{
    if (!_lineLabel) {
        //底部分割线
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.backgroundColor = UIColor.lightGrayColor;
        self.lineLabel = lineLabel;
        [self.mainView addSubview:lineLabel];
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        [self.mainView bringSubviewToFront:lineLabel];
    }
    return _lineLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

/**
 *  UI 界面
 */
- (void)setupUI{
    [self lineLabel];
}

- (void)setShowBottomLabel:(BOOL)showBottomLabel{
    self.lineLabel.hidden = !showBottomLabel;
}
- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - private
- (void)clickLeftButton{
    //  获取返回视图的视图控制器
    [self.viewController.navigationController popViewControllerAnimated:YES];
    if (self.leftButtonBlock) {
        self.leftButtonBlock();
    }
}

- (void)clickLeftTwoButton{
    if (self.leftTwoButtonBlock) {
        self.leftTwoButtonBlock();
    }
}


- (void)clickCenterButton{
    if (self.cenTerButtonBlock) {
        self.cenTerButtonBlock();
    }
}

- (void)clickRightButton{
    if (self.rightButtonBlock) {
        self.rightButtonBlock();
    }
}

- (void)clickRightTwoButton{
    if (self.rightTwoButtonBlock) {
        self.rightTwoButtonBlock();
    }
}

@end
