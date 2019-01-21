//
//  NetRequestLoading.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/25.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "NetRequestLoading.h"

@interface NetRequestLoading ()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *contextLabel;
@property (nonatomic, strong) UIButton *iconButton;
@end

@implementation NetRequestLoading

static NetRequestLoading *_instance;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[NetRequestLoading alloc] init];
    });
    return _instance;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = UIColor.whiteColor;
        _containerView.layer.cornerRadius = 5;
        _containerView.frame = CGRectMake(0, 0, 80, 80);
        _containerView.center = self.center;
        [self addSubview:_containerView];
    }
    return _containerView;
}

- (UIButton *)iconButton {
    if (!_iconButton) {
        _iconButton = [[UIButton alloc] init];
        _iconButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconButton;
}

- (UILabel *)contextLabel {
    if (!_contextLabel) {
        _contextLabel = [[UILabel alloc] init];
        _contextLabel.textAlignment = NSTextAlignmentCenter;
        [self.containerView addSubview:_contextLabel];
        _contextLabel.textColor = UIColor.blackColor;
    }
    return _contextLabel;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] init];
        [_indicatorView setHidesWhenStopped:true];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _indicatorView.frame = self.containerView.bounds;
        CGAffineTransform transform = CGAffineTransformMakeScale(1.4f, 1.4f);
        _indicatorView.transform = transform;
        [_indicatorView startAnimating];
    }
    return _indicatorView;
}

- (void)showViewWithindicatorViewWithRemindText:(NSString *)remindText showStyle:(NetRequestLoadingShowStyle)aShowStyle{
    
    for (UIView *view in self.containerView.subviews) {
        [view removeFromSuperview];
    }
    
    self.frame = UIScreen.mainScreen.bounds;
    [UIApplication.sharedApplication.delegate.window addSubview:self];
    
    self.containerView.backgroundColor = aShowStyle == NetRequestLoadingShowStyleDark ? UIColor.darkGrayColor : UIColor.whiteColor;
    self.indicatorView.activityIndicatorViewStyle = aShowStyle == NetRequestLoadingShowStyleDark ? UIActivityIndicatorViewStyleWhite : UIActivityIndicatorViewStyleGray;
    
    CGRect frame = (CGRect){CGPointZero, CGSizeMake(80, 80)};
    frame.origin.x = CGRectGetMidX(self.frame);
    frame.origin.y = CGRectGetMidY(self.frame);
    self.containerView.frame = (CGRect){CGPointMake(frame.origin.x-40, frame.origin.y-40),CGSizeMake(80, 80)};

    if (remindText.length != 0) {
        self.indicatorView.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height-20);
        CGAffineTransform transform = CGAffineTransformMakeScale(1.4f, 1.4f);
        self.indicatorView.transform = transform;
        self.contextLabel.frame = CGRectMake(0, self.containerView.frame.size.height-20, self.containerView.frame.size.width, 15);
        self.contextLabel.text = remindText;
        self.contextLabel.textColor = aShowStyle == NetRequestLoadingShowStyleDark ? UIColor.whiteColor : UIColor.darkGrayColor;
    }
    [self.containerView addSubview:self.indicatorView];
    [self.containerView addSubview:self.contextLabel];
}

- (void)showViewViewWithRemindText:(NSString *)remindText statusStyle:(NetRequestLoadingStatusStyle)aStatusStyle showStyle:(NetRequestLoadingShowStyle)aShowStyle {
    
    for (UIView *view in self.containerView.subviews) {
        [view removeFromSuperview];
    }
    
    self.frame = UIScreen.mainScreen.bounds;
    [UIApplication.sharedApplication.delegate.window addSubview:self];
    
    self.containerView.backgroundColor = aShowStyle == NetRequestLoadingShowStyleDark ? UIColor.darkGrayColor : UIColor.whiteColor;
    
    if (aStatusStyle == NetRequestLoadingStatusStyleFail) {
        [self.iconButton setImage:[[UIImage imageNamed:@"MBHUD_Error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    } else {
        [self.iconButton setImage:[[UIImage imageNamed:@"MBHUD_Info"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    
    CGRect frame = (CGRect){CGPointZero, CGSizeMake(80, 80)};
    frame.origin.x = CGRectGetMidX(self.frame);
    frame.origin.y = CGRectGetMidY(self.frame);
    self.containerView.frame = (CGRect){CGPointMake(frame.origin.x-40, frame.origin.y-40),CGSizeMake(80, 80)};
    
    [self.contextLabel setAdjustsFontSizeToFitWidth:true];
  
    self.iconButton.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height-20);
    self.iconButton.tintColor = aShowStyle == NetRequestLoadingShowStyleDark ? UIColor.whiteColor : UIColor.darkGrayColor;
    self.contextLabel.frame = CGRectMake(0, self.containerView.frame.size.height-20, self.containerView.frame.size.width, 15);
    self.contextLabel.text = remindText;
    self.contextLabel.textColor = aShowStyle == NetRequestLoadingShowStyleDark ? UIColor.whiteColor : UIColor.darkGrayColor;
    
    [self.containerView addSubview:self.iconButton];
    [self.containerView addSubview:self.contextLabel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissView];
    });
}

- (void)showViewWithAnimationPicture:(NSArray *)imageArray loadingTime:(CGFloat)loadingTime {
    
}

- (void)dismissView {
    [self removeFromSuperview];
}

@end
