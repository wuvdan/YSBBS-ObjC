//
//  WudanHUD.m
//  WudanHUD
//
//  Created by wudan on 2019/1/21.
//  Copyright © 2019 wudan. All rights reserved.
//

#import "WudanHUD.h"

#define  kWudanHUD_KSCEEN_WIDTH UIScreen.mainScreen.bounds.size.width
#define  kWudanHUD_KSCEEN_HEIGHT UIScreen.mainScreen.bounds.size.height

#define  kWudan_SCREEN_RATIO  (kWudanHUD_KSCEEN_WIDTH / 375.0)

#define  kWudan_BACK_MIN_WIDTH (kWudanHUD_KSCEEN_WIDTH * 0.25)
#define  kWudan_BACK_MAX_WIDTH (kWudanHUD_KSCEEN_WIDTH * 0.5)

#define  kLabelSpace (10 * kWudan_SCREEN_RATIO)

@interface WudanHUD ()

@property (nonatomic, assign) WudanHUDStyle style;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL isShowing;
@end

@implementation WudanHUD

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static WudanHUD *manager;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (void)setStyle:(WudanHUDStyle)style {
    [WudanHUD defaultManager].style = style;
}

+ (void)showText:(NSString *)text {
    
    if ([WudanHUD defaultManager].isShowing) {
        [WudanHUD dismiss];
    }
    
    [[WudanHUD defaultManager] addSubview:[WudanHUD defaultManager].backgroundView];
    [[WudanHUD defaultManager].backgroundView addSubview:[WudanHUD defaultManager].contentLabel];
    
    [WudanHUD defaultManager].frame = UIScreen.mainScreen.bounds;
    [UIApplication.sharedApplication.delegate.window addSubview:[WudanHUD defaultManager]];
    
    switch ([WudanHUD defaultManager].style) {
        case WudanHUDStyleDark:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor blackColor];
            [WudanHUD defaultManager].contentLabel.textColor = [UIColor whiteColor];
        }
            break;
        case WudanHUDStyleLight:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor whiteColor];
            [WudanHUD defaultManager].contentLabel.textColor = [UIColor grayColor];
        }
            break;
        case WudanHUDStyleClear:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor clearColor];
            [WudanHUD defaultManager].contentLabel.textColor = [UIColor blackColor];
        }
            break;
        default:
            break;
    }
    
    [WudanHUD defaultManager].contentLabel.text = text;
    
    CGFloat textHeight = [[WudanHUD defaultManager] getTextHeightWithText:text].height;
    CGFloat textWidth = [[WudanHUD defaultManager] getTextHeightWithText:text].width;
    
    if (textWidth > kWudan_BACK_MAX_WIDTH) {
        textWidth = kWudan_BACK_MAX_WIDTH;
    } else if (textWidth < kWudan_BACK_MIN_WIDTH) {
        textWidth = kWudan_BACK_MIN_WIDTH;
    } else {
        textWidth = textWidth;
    }
    
    [WudanHUD defaultManager].backgroundView.bounds = CGRectMake(0,
                                                                 0,
                                                                 textWidth + 2 * kLabelSpace,
                                                                 textHeight + 2 * kLabelSpace);
    
    [WudanHUD defaultManager].backgroundView.center = [WudanHUD defaultManager].center;
    [WudanHUD defaultManager].backgroundView.layer.cornerRadius = (textWidth + 2 * kLabelSpace) / 10;
    
    [WudanHUD defaultManager].contentLabel.frame = CGRectMake(kLabelSpace,
                                                              kLabelSpace,
                                                              textWidth,
                                                              textHeight);
    [[WudanHUD defaultManager].indicatorView startAnimating];
    
    [WudanHUD defaultManager].isShowing = true;
}

+ (void)showIndicator {
    
    if ([WudanHUD defaultManager].isShowing) {
        [WudanHUD dismiss];
    }
    
    [[WudanHUD defaultManager] addSubview:[WudanHUD defaultManager].backgroundView];
    [[WudanHUD defaultManager].backgroundView addSubview:[WudanHUD defaultManager].indicatorView];
    
    [WudanHUD defaultManager].frame = UIScreen.mainScreen.bounds;
    [UIApplication.sharedApplication.delegate.window addSubview:[WudanHUD defaultManager]];
    
    switch ([WudanHUD defaultManager].style) {
        case WudanHUDStyleDark:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor blackColor];
            [WudanHUD defaultManager].indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        }
            break;
        case WudanHUDStyleLight:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor whiteColor];
            [WudanHUD defaultManager].indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        }
            break;
        case WudanHUDStyleClear:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor clearColor];
            [WudanHUD defaultManager].indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        }
            break;
        default:
            break;
    }
    
    [WudanHUD defaultManager].backgroundView.bounds = CGRectMake(0, 0, kWudan_BACK_MIN_WIDTH, kWudan_BACK_MIN_WIDTH);
    [WudanHUD defaultManager].backgroundView.center = [WudanHUD defaultManager].center;
    [WudanHUD defaultManager].backgroundView.layer.cornerRadius = kWudan_BACK_MIN_WIDTH/10;
    [WudanHUD defaultManager].indicatorView.frame = [WudanHUD defaultManager].backgroundView.bounds;
    
    [[WudanHUD defaultManager].indicatorView startAnimating];
    
    [WudanHUD defaultManager].isShowing = true;
}

+ (void)showIndicatorWithText:(NSString *)text {
    
    if ([WudanHUD defaultManager].isShowing) {
        [WudanHUD dismiss];
    }
    
    [[WudanHUD defaultManager] addSubview:[WudanHUD defaultManager].backgroundView];
    [[WudanHUD defaultManager].backgroundView addSubview:[WudanHUD defaultManager].indicatorView];
    [[WudanHUD defaultManager].backgroundView addSubview:[WudanHUD defaultManager].contentLabel];
    
    [WudanHUD defaultManager].frame = UIScreen.mainScreen.bounds;
    [UIApplication.sharedApplication.delegate.window addSubview:[WudanHUD defaultManager]];
    
    [WudanHUD defaultManager].contentLabel.text = text;
    
    switch ([WudanHUD defaultManager].style) {
        case WudanHUDStyleDark:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor blackColor];
            [WudanHUD defaultManager].indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            [WudanHUD defaultManager].contentLabel.textColor = [UIColor whiteColor];
        }
            break;
        case WudanHUDStyleLight:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor whiteColor];
            [WudanHUD defaultManager].indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [WudanHUD defaultManager].contentLabel.textColor = [UIColor blackColor];
        }
            break;
        case WudanHUDStyleClear:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor clearColor];
            [WudanHUD defaultManager].indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [WudanHUD defaultManager].contentLabel.textColor = [UIColor blackColor];
        }
            break;
        default:
            break;
    }
    
    CGFloat textHeight = [[WudanHUD defaultManager] getTextHeightWithText:text].height;
    CGFloat textWidth = [[WudanHUD defaultManager] getTextHeightWithText:text].width + kLabelSpace * 2;

    if (textWidth > kWudan_BACK_MAX_WIDTH) {
        textWidth = kWudan_BACK_MAX_WIDTH;
    } else if (textWidth < kWudan_BACK_MIN_WIDTH) {
        textWidth = kWudan_BACK_MIN_WIDTH;
    } else {
        textWidth = textWidth;
    }
    
    CGFloat backGroundViewHeight = kWudan_BACK_MIN_WIDTH * 0.5 + textHeight + 2 * kLabelSpace;
    
    [WudanHUD defaultManager].backgroundView.bounds = CGRectMake(0, 0, textWidth, backGroundViewHeight);
    [WudanHUD defaultManager].backgroundView.center = [WudanHUD defaultManager].center;
    [WudanHUD defaultManager].backgroundView.layer.cornerRadius = textWidth / 10;
    [WudanHUD defaultManager].indicatorView.frame = CGRectMake(0, kLabelSpace, textWidth, kWudan_BACK_MIN_WIDTH / 2);
    [WudanHUD defaultManager].contentLabel.frame = CGRectMake(kLabelSpace,
                                                              CGRectGetMaxY([WudanHUD defaultManager].indicatorView.frame),
                                                              textWidth - 2 * kLabelSpace,
                                                              textHeight);

    [[WudanHUD defaultManager].indicatorView startAnimating];
    
    [WudanHUD defaultManager].isShowing = true;
}

+ (void)showImageViewWithImageName:(UIImage *)image {
    if ([WudanHUD defaultManager].isShowing) {
        [WudanHUD dismiss];
    }
    
    [[WudanHUD defaultManager] addSubview:[WudanHUD defaultManager].backgroundView];
    [[WudanHUD defaultManager].backgroundView addSubview:[WudanHUD defaultManager].imageView];
    
    [WudanHUD defaultManager].frame = UIScreen.mainScreen.bounds;
    [UIApplication.sharedApplication.delegate.window addSubview:[WudanHUD defaultManager]];
    
    [WudanHUD defaultManager].imageView.image = image;
    
    switch ([WudanHUD defaultManager].style) {
        case WudanHUDStyleDark:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor blackColor];
        }
            break;
        case WudanHUDStyleLight:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor whiteColor];
        }
            break;
        case WudanHUDStyleClear:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor clearColor];
        }
            break;
        default:
            break;
    }
    
    CGFloat imageWidth = 0.0;
    
    if (image.size.width > kWudan_BACK_MAX_WIDTH) {
        imageWidth = kWudan_BACK_MAX_WIDTH;
    } else {
        imageWidth = image.size.width;
    }
    
    CGFloat imageHeight = 0.0;
    
    if (image.size.height > kWudan_BACK_MAX_WIDTH) {
        imageHeight = kWudan_BACK_MAX_WIDTH;
    } else {
        imageHeight = image.size.width;
    }
    
    [WudanHUD defaultManager].backgroundView.bounds = CGRectMake(0, 0, imageWidth, imageHeight);
    [WudanHUD defaultManager].backgroundView.center = [WudanHUD defaultManager].center;
    [WudanHUD defaultManager].backgroundView.layer.cornerRadius = kWudan_BACK_MIN_WIDTH/10;
    [WudanHUD defaultManager].imageView.frame = CGRectMake(kLabelSpace,
                                                           kLabelSpace,
                                                           imageWidth - 2 * kLabelSpace,
                                                           imageHeight - 2 * kLabelSpace);
    
    [WudanHUD defaultManager].isShowing = true;
}

+ (void)showImageViewWithImageName:(UIImage *)image contentText:(NSString *)text {
    if ([WudanHUD defaultManager].isShowing) {
        [WudanHUD dismiss];
    }
    
    [[WudanHUD defaultManager] addSubview:[WudanHUD defaultManager].backgroundView];
    [[WudanHUD defaultManager].backgroundView addSubview:[WudanHUD defaultManager].imageView];
    [[WudanHUD defaultManager].backgroundView addSubview:[WudanHUD defaultManager].contentLabel];
    
    [WudanHUD defaultManager].frame = UIScreen.mainScreen.bounds;
    [UIApplication.sharedApplication.delegate.window addSubview:[WudanHUD defaultManager]];
    
    [WudanHUD defaultManager].imageView.image = image;
    [WudanHUD defaultManager].contentLabel.text = text;
    
    switch ([WudanHUD defaultManager].style) {
        case WudanHUDStyleDark:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor blackColor];
            [WudanHUD defaultManager].contentLabel.textColor = [UIColor whiteColor];
        }
            break;
        case WudanHUDStyleLight:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor whiteColor];
            [WudanHUD defaultManager].contentLabel.textColor = [UIColor blackColor];
        }
            break;
        case WudanHUDStyleClear:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor clearColor];
            [WudanHUD defaultManager].contentLabel.textColor = [UIColor blackColor];
        }
            break;
        default:
            break;
    }
    
    CGFloat textHeight = [[WudanHUD defaultManager] getTextHeightWithText:text maxWidth:kWudan_BACK_MAX_WIDTH - 2 * kLabelSpace].height;
    CGFloat textWidth = [[WudanHUD defaultManager] getTextHeightWithText:text maxWidth:kWudan_BACK_MAX_WIDTH - 2 * kLabelSpace].width;
    
    CGFloat imageWidth = 0.0;
    
    if (textWidth > kWudan_BACK_MAX_WIDTH) {
        textWidth = kWudan_BACK_MAX_WIDTH;
    } else if (textWidth < kWudan_BACK_MIN_WIDTH){
        textWidth = kWudan_BACK_MIN_WIDTH;
    } else {
        textWidth = textWidth;
    }
    
    if (image.size.width > (textWidth - 2 * kLabelSpace)) {
        imageWidth = textWidth - 2 * kLabelSpace;
    } else {
        imageWidth = image.size.width;
    }
    
    CGFloat scale = imageWidth/image.size.width;
    
    CGFloat imageHeight = image.size.height * scale;
    
    [WudanHUD defaultManager].backgroundView.bounds = CGRectMake(0, 0, textWidth, imageHeight + textHeight + 3 * kLabelSpace);
    [WudanHUD defaultManager].backgroundView.center = [WudanHUD defaultManager].center;
    [WudanHUD defaultManager].backgroundView.layer.cornerRadius = kWudan_BACK_MIN_WIDTH/10;
    
    [WudanHUD defaultManager].imageView.frame = CGRectMake(kLabelSpace,
                                                           kLabelSpace,
                                                           textWidth - 2 * kLabelSpace,
                                                           imageHeight);
    
    [WudanHUD defaultManager].contentLabel.frame = CGRectMake(kLabelSpace,
                                                              CGRectGetMaxY([WudanHUD defaultManager].imageView.frame) + kLabelSpace,
                                                              textWidth - 2 * kLabelSpace,
                                                              textHeight);
    [WudanHUD defaultManager].isShowing = true;
}

+ (void)showCycleIndicatorWithBackColor:(UIColor *)backColor cycleColor:(UIColor *)cycleColor {
    
    if ([WudanHUD defaultManager].isShowing) {
        [WudanHUD dismiss];
    }
    
    [[WudanHUD defaultManager] addSubview:[WudanHUD defaultManager].backgroundView];
    
    [WudanHUD defaultManager].frame = UIScreen.mainScreen.bounds;
    [UIApplication.sharedApplication.delegate.window addSubview:[WudanHUD defaultManager]];
    
    switch ([WudanHUD defaultManager].style) {
        case WudanHUDStyleDark:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor blackColor];
        }
            break;
        case WudanHUDStyleLight:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor whiteColor];
        }
            break;
        case WudanHUDStyleClear:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor clearColor];
        }
            break;
        default:
            break;
    }
        
    [WudanHUD defaultManager].backgroundView.bounds = CGRectMake(0, 0, kWudan_BACK_MIN_WIDTH, kWudan_BACK_MIN_WIDTH);
    [WudanHUD defaultManager].backgroundView.center = [WudanHUD defaultManager].center;
    [WudanHUD defaultManager].backgroundView.layer.cornerRadius = kWudan_BACK_MIN_WIDTH/10;
    
    CGFloat width = kWudan_BACK_MIN_WIDTH/2 - 2 * kLabelSpace;
    
    [[WudanHUD defaultManager] createCycleLayerWithBackColor:backColor cycleColor:cycleColor lineWidth:3 center:[WudanHUD defaultManager].backgroundView.center radius:width];
    
    [WudanHUD defaultManager].isShowing = true;
}

+ (void)showWaveWithColor:(UIColor *)color {
    
    if ([WudanHUD defaultManager].isShowing) {
        [WudanHUD dismiss];
    }
    
    [[WudanHUD defaultManager] addSubview:[WudanHUD defaultManager].backgroundView];
    
    [WudanHUD defaultManager].frame = UIScreen.mainScreen.bounds;
    [UIApplication.sharedApplication.delegate.window addSubview:[WudanHUD defaultManager]];
    
    switch ([WudanHUD defaultManager].style) {
        case WudanHUDStyleDark:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor blackColor];
        }
            break;
        case WudanHUDStyleLight:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor whiteColor];
        }
            break;
        default:
            break;
    }
    
    [WudanHUD defaultManager].backgroundView.bounds = CGRectMake(0, 0, kWudan_BACK_MIN_WIDTH, kWudan_BACK_MIN_WIDTH);
    [WudanHUD defaultManager].backgroundView.center = [WudanHUD defaultManager].center;
    [WudanHUD defaultManager].backgroundView.layer.cornerRadius = kWudan_BACK_MIN_WIDTH/10;
    
    CGFloat radius = 12 * kWudan_SCREEN_RATIO;
    CGFloat between = (kWudan_BACK_MIN_WIDTH - 2 * kLabelSpace - radius * 3)/2;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(CGRectGetMinX([WudanHUD defaultManager].backgroundView.frame) + kLabelSpace,
                             CGRectGetMidY([WudanHUD defaultManager].backgroundView.frame) - radius * 2.5 * kWudan_SCREEN_RATIO/2,
                             radius,
                             radius * 2.5 * kWudan_SCREEN_RATIO);
    layer.backgroundColor = color.CGColor;
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = CGRectMake(0,
                                       0,
                                       [WudanHUD defaultManager].backgroundView.frame.size.width - 2 * kLabelSpace,
                                       [WudanHUD defaultManager].backgroundView.frame.size.height - 2 * kLabelSpace);
    replicatorLayer.instanceDelay = 0.2;
    replicatorLayer.instanceCount = 3;
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(between + radius, 0, 0);
    [replicatorLayer addSublayer:layer];
    
    [[WudanHUD defaultManager].layer addSublayer:replicatorLayer];
    
    CABasicAnimation * animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    animation1.fromValue          = @(1);
    animation1.toValue            = @(0);
    animation1.duration           = 0.6;
    animation1.autoreverses       = YES;
    animation1.repeatCount        = MAXFLOAT;
    [layer addAnimation:animation1 forKey:nil];
    
    [WudanHUD defaultManager].isShowing = true;
}

+ (void)showDotViewWithColor:(UIColor *)color {
    
    if ([WudanHUD defaultManager].isShowing) {
        [WudanHUD dismiss];
    }
    
    [[WudanHUD defaultManager] addSubview:[WudanHUD defaultManager].backgroundView];
    
    [WudanHUD defaultManager].frame = UIScreen.mainScreen.bounds;
    [UIApplication.sharedApplication.delegate.window addSubview:[WudanHUD defaultManager]];
    
    switch ([WudanHUD defaultManager].style) {
        case WudanHUDStyleDark:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor blackColor];
        }
            break;
        case WudanHUDStyleLight:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor whiteColor];
        }
            break;
        case WudanHUDStyleClear:
        {
            [WudanHUD defaultManager].backgroundView.backgroundColor = [UIColor clearColor];
        }
            break;
        default:
            break;
    }
    
    [WudanHUD defaultManager].backgroundView.bounds = CGRectMake(0, 0, kWudan_BACK_MIN_WIDTH, kWudan_BACK_MIN_WIDTH);
    [WudanHUD defaultManager].backgroundView.center = [WudanHUD defaultManager].center;
    [WudanHUD defaultManager].backgroundView.layer.cornerRadius = kWudan_BACK_MIN_WIDTH/10;
    
    CGFloat radius = 15 * kWudan_SCREEN_RATIO;
    CGFloat between = 5.0 * kWudan_SCREEN_RATIO;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, 0, radius, radius);
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    shapeLayer.fillColor = color.CGColor;
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = CGRectMake(CGRectGetMinX([WudanHUD defaultManager].backgroundView.frame) + kLabelSpace,
                                       CGRectGetMidY([WudanHUD defaultManager].backgroundView.frame) - kLabelSpace/2,
                                       [WudanHUD defaultManager].backgroundView.frame.size.width - 2 * kLabelSpace,
                                       [WudanHUD defaultManager].backgroundView.frame.size.height - 2 * kLabelSpace);
    replicatorLayer.instanceDelay = 0.2;
    replicatorLayer.instanceCount = 3;
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(between + radius,0,0);
    replicatorLayer.instanceRedOffset = -0.3;
    replicatorLayer.instanceGreenOffset = -0.3;
    replicatorLayer.instanceBlueOffset = -0.3;
    [replicatorLayer addSublayer:shapeLayer];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    scale.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
    scale.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 0.0)];
    scale.autoreverses = YES;
    scale.repeatCount = HUGE;
    scale.duration = 0.6;
    [shapeLayer addAnimation:scale forKey:nil];
    
    [[WudanHUD defaultManager].layer addSublayer:replicatorLayer];
    
    [WudanHUD defaultManager].isShowing = true;
}

+ (void)dismissDelayTimeInterval:(NSTimeInterval)interval {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

+ (void)dismiss {
    for (UIView *subview in [WudanHUD defaultManager].subviews) {
        [subview removeFromSuperview];
    }
    
    for (UIView *subview in [WudanHUD defaultManager].backgroundView.subviews) {
        [subview removeFromSuperview];
    }
    
    [[WudanHUD defaultManager] removeFromSuperview];
    [WudanHUD defaultManager].isShowing = false;
}

#pragma mark - Tool

- (CGSize)getTextHeightWithText:(NSString *)text {
    return [self getTextHeightWithText:text maxWidth:kWudan_BACK_MAX_WIDTH];
}

- (CGSize)getTextHeightWithText:(NSString *)text maxWidth:(CGFloat)width {
    
    CGSize labelsize  = [text
                         boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 * kWudan_SCREEN_RATIO]}
                         context:nil].size;
    return labelsize;
}

- (void)createCycleLayerWithBackColor:(UIColor *)backColor cycleColor:(UIColor *)cycleColor lineWidth:(CGFloat)lineWidth center:(CGPoint)center radius:(CGFloat)radius {
    
    UIBezierPath *backPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:true];
    
    UIBezierPath *cyclePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:true];
    
    CAShapeLayer *backShapLayer = [CAShapeLayer layer];
    backShapLayer.path = backPath.CGPath;
    backShapLayer.strokeStart = 0;
    backShapLayer.strokeEnd = 1;
    backShapLayer.strokeColor = backColor.CGColor;
    backShapLayer.lineWidth = lineWidth;
    backShapLayer.fillColor = UIColor.clearColor.CGColor;
    [self.layer addSublayer:backShapLayer];
    
    CAShapeLayer *cycleShapLayer = [CAShapeLayer layer];
    cycleShapLayer.path = cyclePath.CGPath;
    cycleShapLayer.strokeStart = 0;
    cycleShapLayer.strokeEnd = 1;
    cycleShapLayer.strokeColor = cycleColor.CGColor;
    cycleShapLayer.lineWidth = lineWidth;
    cycleShapLayer.fillColor = UIColor.clearColor.CGColor;
    [backShapLayer addSublayer:cycleShapLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 3.0;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.repeatCount = MAXFLOAT;
    [cycleShapLayer addAnimation:animation forKey:@"strokeEndAnimation"];
}

#pragma mark - @property

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] init];
        _indicatorView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        [_indicatorView hidesWhenStopped];
    }
    return _indicatorView;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
    }
    return _backgroundView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:15 * kWudan_SCREEN_RATIO];
    }
    return _contentLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end
