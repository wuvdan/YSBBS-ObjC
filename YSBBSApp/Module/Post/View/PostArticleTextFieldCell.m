//
//  PostArticleTextFieldCell.m
//  YSBBSApp
//
//  Created by wudan on 2018/11/14.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "PostArticleTextFieldCell.h"

@interface PostArticleTextFieldCell () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *bottomLine;

@end

@implementation PostArticleTextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupConstants];
    }
    return self;
}

- (void)setupUI {
    self.textField                 = [[UITextField alloc] init];
    self.textField.placeholder     = @"标题";
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.font            = [UIFont systemFontOfSize:20];
    self.textField.returnKeyType   = UIReturnKeyDone;
    self.textField.delegate        = self;
    [self.contentView addSubview:self.textField];

    self.bottomLine                = [[UIImageView alloc] init];
    [self.contentView addSubview:self.bottomLine];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.delegate &&  [self.delegate respondsToSelector:@selector(textChangeInPostArticleTextFieldCell:text:)]) {
        [self.delegate textChangeInPostArticleTextFieldCell:self text:textField.text];
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (void)setupConstants {
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(kRealWidthValue(15));
        make.top.bottom.mas_equalTo(self.contentView).inset(kRealHeightValue(8));
        make.height.mas_equalTo(kRealHeightValue(55));
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(currentContext, kRGBA(0, 0, 0.0980392, 0.22).CGColor);
    CGContextSetLineWidth(currentContext, 0.5);
    CGContextMoveToPoint(currentContext, 0, self.contentView.frame.size.height-0.5);
    CGContextAddLineToPoint(currentContext, self.frame.origin.x + self.frame.size.width, self.contentView.frame.size.height-0.5);
    CGFloat arr[] = {3,1};
    CGContextSetLineDash(currentContext, 0, arr, 1);
    CGContextDrawPath(currentContext, kCGPathStroke);
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
