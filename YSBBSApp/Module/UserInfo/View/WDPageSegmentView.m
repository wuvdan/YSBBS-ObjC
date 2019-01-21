//
//  WDPageSegmentView.m
//  NestingView
//
//  Created by wudan on 2018/9/27.
//  Copyright © 2018 wudan. All rights reserved.
//

#import "WDPageSegmentView.h"

@interface WDPageSegmentView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *indecatorView;
@property (nonatomic, strong) UIButton *lastButton;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;
@property (nonatomic, strong) UIView *spaceLine;

@end

@implementation WDPageSegmentView

#pragma mark  Setter 
- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    [self dataInitial];
    [self setupSubviews];
    [self setupSubviewsConstraints];
}

- (void)setIncationWithContentOffsetX:(CGFloat)incationWithContentOffsetX {
    _incationWithContentOffsetX = incationWithContentOffsetX;
    
    CGFloat slideItemWidth =  kSCREEN_WIDTH / 2;
    CGFloat sliderWidth =  slideItemWidth * 0.8;
    CGFloat position_x =  (slideItemWidth - sliderWidth) / 2.0;
    
    CGRect newFrame = CGRectMake((incationWithContentOffsetX/kSCREEN_WIDTH) * slideItemWidth + position_x, self.indecatorView.frame.origin.y, self.indecatorView.frame.size.width, self.indecatorView.frame.size.height);

    self.indecatorView.frame = newFrame;
    
    NSInteger buttonTag = 0;
    CGFloat ratio = incationWithContentOffsetX / kSCREEN_WIDTH;
    CGFloat tempRation = (int)ratio;
    
    CGFloat decimal = ratio - (CGFloat)tempRation;
    
    if (decimal >= 0.5) {
        buttonTag = (int)ratio + 1;
    } else {
        buttonTag = (int)ratio;
    }
    
    if (self.scrollToIndexBlock) {
        self.scrollToIndexBlock(buttonTag);
    }
}

#pragma mark  dataInitial 
- (void)dataInitial {
    self.buttonArray = [NSMutableArray array];
}

#pragma mark  SetupSubviewsUI 
- (void)setupSubviews{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.scrollView];
    
    self.indecatorView = [[UIView alloc] init];
    self.indecatorView.backgroundColor = kMainDarkGreen;
    [self.scrollView addSubview:self.indecatorView];
    
    self.spaceLine = [[UIView alloc] init];
    self.spaceLine.backgroundColor = UIColor.grayColor;
    [self addSubview:self.spaceLine];
}

#pragma mark  计算按钮间距 
- (CGFloat)calculateSpace {
    CGFloat minSpeace = 10;
    CGFloat space = 0.f;
    CGFloat totalWidth = 0.f;
    
    for (NSString *title in self.titleArray) {
        totalWidth += [self widthForString:title fontSize:13 andHeight:30];
    }
    
    space = (UIScreen.mainScreen.bounds.size.width - totalWidth) / self.titleArray.count / 2;
    if (space > minSpeace / 2) {
        return space;
    } else {
        return minSpeace / 2;
    }
}

#pragma mark  SetupSubviewsConstraints 
- (void)setupSubviewsConstraints{
    
    CGFloat item_x = 0;
    CGFloat buttonSpace = [self calculateSpace];
    
    for (int i = 0; i < self.titleArray.count; i++) {
        CGFloat titleW = [self widthForString:self.titleArray[i] fontSize:13 andHeight:30];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(item_x, 15/2, buttonSpace * 2 + titleW * 1.5, 30);
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColor.blackColor forState:UIControlStateSelected];
        [button setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
        item_x += buttonSpace * 2 + titleW;
        [self.scrollView addSubview:button];
        if ( i == 0 ) {
            button.selected = true;
            self.lastButton = button;
            [self.buttonArray addObject:button];
            
            self.indecatorView.bounds = CGRectMake(0, 0, kSCREEN_WIDTH/4, 2);
            self.indecatorView.center = CGPointMake(self.lastButton.center.x, CGRectGetMaxY(self.lastButton.frame));
        }
    }
    self.scrollView.contentSize = CGSizeMake(item_x, 0);
}

#pragma mark -- 根据选中调整segementView的offset
- (void)scrollSegementView {
    CGFloat selectedWidth = self.lastButton.frame.size.width;
    CGFloat offsetX = (self.scrollView.frame.size.width - selectedWidth) / 2;
    
    if (self.lastButton.frame.origin.x <= self.scrollView.frame.size.width / 2) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:true];
    } else if (CGRectGetMaxX(self.lastButton.frame) >= (self.scrollView.contentSize.width - self.scrollView.frame.size.width / 2)) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - self.scrollView.frame.size.width, 0) animated:true];
    } else {
        [self.scrollView setContentOffset:CGPointMake(CGRectGetMinX(self.lastButton.frame) - offsetX, 0) animated:true];
    }
    
    for (UIView *view in self.scrollView.subviews) {
        if ([view isEqual:self.indecatorView]) {
            [view removeFromSuperview];
        }
    }
    
    [self.scrollView addSubview:self.indecatorView];
}

- (void)scrollToIndex:(NSInteger)index {
    
    for (UIView *view in self.scrollView.subviews) {
        if ([view isEqual:self.indecatorView]) {
            [view removeFromSuperview];
        }
    }
    
    UIButton *sender = self.scrollView.subviews[index];
    self.lastButton = sender;
    [self.buttonArray addObject:sender];
    for (UIButton *button in self.buttonArray) {
        if ([button isEqual:self.lastButton]) {
            button.selected = true;
        } else {
            button.selected= false;
        }
    }
    
    [self scrollSegementView];
    [self moveIndecator];
}

- (void)buttonSelected:(UIButton *)sender {
    self.lastButton = sender;
    [self.buttonArray addObject:sender];
    for (UIButton *button in self.buttonArray) {
        if ([button isEqual:self.lastButton]) {
            button.selected = true;
        } else {
            button.selected= false;
        }
    }
    [self scrollSegementView];
    
    [self moveIndecator];
    
    for (NSInteger i = 0; i < self.scrollView.subviews.count; i++) {
        if ([self.lastButton isEqual:self.scrollView.subviews[i]]) {
            if (self.scrollToIndexBlock) {
                self.scrollToIndexBlock(i);
            }
            break;
        }
    }
}


- (void)moveIndecator {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.indecatorView.center = CGPointMake(self.lastButton.center.x, CGRectGetMaxY(self.lastButton.frame));
    }];
}

#pragma mark  获取字符串的宽度 
- (CGFloat)widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height {
    CGRect rect = [value boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return rect.size.width;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    self.spaceLine.frame = CGRectMake(0, self.bounds.size.height-0.5, self.bounds.size.width, 0.5);
}

@end
